#!/usr/bin/env bash

# install_nginx.sh
# 
# Build and install Nginx on Raspberry Pi
#
# created on : 2017.08.16.
# last update: 2017.08.17.
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

NGINX_CONF_FILE="/etc/nginx/conf/nginx.conf"
NGINX_SERVICE_FILE="/lib/systemd/system/nginx.service"

function prep {
	# install needed packages (gcc 4.9 is needed for some compiler options)
	sudo apt-get -y install gcc-4.9 g++-4.9 \
		&& sudo update-alternatives --remove-all gcc \
		&& sudo update-alternatives --remove-all g++ \
		&& sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 100 \
		&& sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 100

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
	# overwrite default config file
	echo -e "${RED}>>> Overwriting config file: ${NGINX_CONF_FILE}...${RESET}"
	sudo bash -c "cat > $NGINX_CONF_FILE" <<EOF

user  www-data;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

	#gzip  on;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # XXX - never use SSLv3 due to POODLE vulnerability
    ssl_prefer_server_ciphers on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php\$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php\$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
EOF

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

