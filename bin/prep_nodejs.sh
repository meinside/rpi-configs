#!/usr/bin/env bash

# prep_nodejs.sh
# 
# install pre-built Node.js files for Raspberry Pi
# from: https://nodejs.org/dist
# 
# created on : 2013.07.19.
# last update: 2016.10.19.
# 
# by meinside@gmail.com

VERSION="4.6.1"	# XXX - edit this for other versions

NODEJS_DIST_BASEURL="https://nodejs.org/dist"
TEMP_DIR="/tmp"
FILENAME="node-v$VERSION-linux-armv7l.tar.gz"
DOWNLOAD_PATH="$NODEJS_DIST_BASEURL/v$VERSION/$FILENAME"
INSTALLATION_DIR="/opt"
NODEJS_DIR="$INSTALLATION_DIR/`basename $FILENAME .tar.gz`"

echo -e "\033[33m>>> downloading version $VERSION ...\033[0m"

wget "$DOWNLOAD_PATH" -P "$TEMP_DIR"

echo -e "\033[33m>>> extracting to: $NODEJS_DIR ...\033[0m"

sudo mkdir -p "$INSTALLATION_DIR"
sudo tar -xzvf "$TEMP_DIR/$FILENAME" -C "$INSTALLATION_DIR"
sudo chown -R $USER "$NODEJS_DIR"
sudo ln -sfn "$NODEJS_DIR" "$INSTALLATION_DIR/node"

echo -e "\033[33m>>> nodejs v$VERSION was installed at: $NODEJS_DIR\033[0m"

