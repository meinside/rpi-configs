#!/usr/bin/env bash

# install_nginx.sh
# 
# Build and install Nginx on Raspberry Pi
#
# created on : 2017.08.16.
# last update: 2017.08.16.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# temporary directory
TEMP_DIR="/tmp"

# versions
NGINX_VERSION="1.13.4"
OPENSSL_VERSION="1.1.0f"
ZLIB_VERSION="1.2.11"
PCRE_VERSION="8.41"

# source files
NGINX_SRC_URL="https://github.com/nginx/nginx/archive/release-${NGINX_VERSION}.tar.gz"
OPENSSL_SRC_URL="https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
ZLIB_SRC_URL="http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz"
PCRE_SRC_URL="https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz"

# extracted dirs
NGINX_SRC_DIR="${TEMP_DIR}/nginx-release-${NGINX_VERSION}"
OPENSSL_SRC_DIR="${TEMP_DIR}/openssl-${OPENSSL_VERSION}"
ZLIB_SRC_DIR="${TEMP_DIR}/zlib-${ZLIB_VERSION}"
PCRE_SRC_DIR="${TEMP_DIR}/pcre-${PCRE_VERSION}"

# XXX - built nginx binary will be placed as:
NGINX_BIN="/usr/local/sbin/nginx"

NGINX_SERVICE_FILE="/lib/systemd/system/nginx.service"

function prep {
	# TODO - install needed packages

	echo -e "${YELLOW}>>> Preparing for essential libraries...${RESET}"

	# openssl: download, unzip, configure, and build
	echo -e "${YELLOW}>>> Building OpenSSL...${RESET}"
	url=$OPENSSL_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file \
		&& cd $OPENSSL_SRC_DIR \
		&& ./config && make

	# zlib: download, unzip, configure, and build
	echo -e "${YELLOW}>>> Building Zlib...${RESET}"
	url=$ZLIB_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file \
		&& cd $ZLIB_SRC_DIR \
		&& ./configure && make

	# pcre: download, unzip, configure, and build
	echo -e "${YELLOW}>>> Building PCRE...${RESET}"
	url=$PCRE_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file \
		&& cd $PCRE_SRC_DIR \
		&& ./configure && make
}

function build {
	# download, unzip,
	url=$NGINX_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file \
		&& cd $NGINX_SRC_DIR

	# configure,
	echo -e "${YELLOW}>>> Configuring Nginx...${RESET}"
	./auto/configure \
		--user=www-data \
		--group=www-data \
		--sbin-path="${NGINX_BIN}" \
		--prefix=/etc/nginx \
		--pid-path=/var/run/nginx.pid \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--with-pcre="${PCRE_SRC_DIR}" \
		--with-openssl="${OPENSSL_SRC_DIR}" \
		--with-openssl-opt="no-weak-ssl-ciphers no-ssl3 no-shared $ECFLAG -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong" \
		--with-zlib="${ZLIB_SRC_DIR}"

	# make
	echo -e "${YELLOW}>>> Building Nginx...${RESET}"
	make

	# make install
	echo -e "${YELLOW}>>> Installing...${RESET}"
	sudo make install
}

function configure {
	if [ ! -e $NGINX_SERVICE_FILE ]; then
		echo -e "${YELLOW}>>> Creating systemd service file: ${NGINX_SERVICE_FILE}...${RESET}"

		sudo bash -c "cat > $NGINX_SERVICE_FILE" <<EOF
[Unit]
Description=NGINX Service
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/local/sbin/nginx -t
ExecStart=/usr/local/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
	fi
}

function clean {
	echo -e "${YELLOW}>>> Cleaning...${RESET}"

	# delete files
	cd $TEMP_DIR
	sudo rm -rf `basename $NGINX_SRC_URL` `basename $OPENSSL_SRC_URL` `basename $ZLIB_SRC_URL` `basename $PCRE_SRC_URL`

	# and directories
	sudo rm -rf $NGINX_SRC_DIR $OPENSSL_SRC_DIR $ZLIB_SRC_DIR $PCRE_SRC_DIR
}

prep && build && configure && clean

