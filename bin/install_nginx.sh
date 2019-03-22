#!/usr/bin/env bash

# install_nginx.sh
# 
# Build and install Nginx on Raspberry Pi
#
# * for issuing and renewing SSL certificates:
#   (https://webcodr.io/2018/02/nginx-reverse-proxy-on-raspberry-pi-with-lets-encrypt/)
#   $ sudo apt-get -y install certbot
#   $ sudo certbot certonly --authenticator standalone -d example.com --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
#
# * for auto-renewing SSL certificates:
#   $ sudo crontab -e
#   0 0 1 * * certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
#
# created on : 2017.08.16.
# last update: 2019.03.22.
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
NGINX_VERSION="1.15.9"
OPENSSL_VERSION="1.1.1b"
ZLIB_VERSION="1.2.11"
PCRE_VERSION="8.42"

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

NGINX_CONF_FILE="/etc/nginx/conf/nginx.conf"
NGINX_SITES_DIR="/etc/nginx/sites-enabled"
NGINX_SERVICE_FILE="/lib/systemd/system/nginx.service"

function prep {
	echo -e "${YELLOW}>>> Preparing for essential libraries...${RESET}"

	# openssl: download and unzip
	echo -e "${YELLOW}>>> Downloading OpenSSL...${RESET}"
	url=$OPENSSL_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file

	# zlib: download and unzip
	echo -e "${YELLOW}>>> Downloading Zlib...${RESET}"
	url=$ZLIB_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file

	# pcre: download and unzip
	echo -e "${YELLOW}>>> Downloading PCRE...${RESET}"
	url=$PCRE_SRC_URL
	file=`basename $url`
	cd $TEMP_DIR \
		&& wget $url \
		&& tar -xzvf $file
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
		--with-http_ssl_module \
		--with-openssl="${OPENSSL_SRC_DIR}" \
		--with-openssl-opt="no-weak-ssl-ciphers no-ssl3 no-shared $ECFLAG -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong" \
		--with-pcre="${PCRE_SRC_DIR}" \
		--with-zlib="${ZLIB_SRC_DIR}"

	# make
	echo -e "${YELLOW}>>> Building Nginx...${RESET}"
	make

	# make install
	echo -e "${YELLOW}>>> Installing...${RESET}"
	sudo make install
}

function configure {
	# create sample sites
	sudo mkdir -p "$NGINX_SITES_DIR"
	echo -e "${YELLOW}>>> Creating sample site files in $NGINX_SITES_DIR/ ...${RESET}"
	sudo bash -c "cat > $NGINX_SITES_DIR/example.com" <<EOF
# reverse-proxy (http://localhost:80 => https://example.com:443)
server {
    listen 80;
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
    ssl_prefer_server_ciphers on;
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        limit_req zone=lr_zone burst=5 nodelay;
    }
}
EOF

	# edit default conf to include enabled sites
	sudo sed -i '/http {/a \ \ \ \ include /etc/nginx/sites-enabled/*.*;' $NGINX_CONF_FILE
	# and limit requests
	sudo sed -i '/http {/a \ \ \ \ limit_req_zone $binary_remote_addr zone=lr_zone:10m rate=30r/s;' $NGINX_CONF_FILE

	# create systemd service file
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
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID
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

