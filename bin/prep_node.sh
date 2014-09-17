#!/usr/bin/env bash

# prep_node.sh
# 
# install pre-built node.js files for Raspberry Pi
# from: http://nodejs.org/dist/
# 
# created on : 2013.07.19
# last update: 2014.09.17
# 
# by meinside@gmail.com

VERSION="0.10.28"	# XXX - edit this for other versions

NODEJS_DIST_BASEURL="http://nodejs.org/dist"
TEMP_DIR="/tmp"
FILENAME="node-v$VERSION-linux-arm-pi.tar.gz"
DOWNLOAD_PATH="$NODEJS_DIST_BASEURL/v$VERSION/$FILENAME"
INSTALLATION_DIR="/opt"
NODE_DIR="$INSTALLATION_DIR/`basename $FILENAME .tar.gz`"

echo -e "\033[33m>>> downloading version $VERSION ...\033[0m"

wget "$DOWNLOAD_PATH" -P "$TEMP_DIR"

echo -e "\033[33m>>> extracting to: $NODE_DIR ...\033[0m"

sudo mkdir -p "$INSTALLATION_DIR"
sudo tar -xzvf "$TEMP_DIR/$FILENAME" -C "$INSTALLATION_DIR"
sudo chown -R $USER "$NODE_DIR"
sudo ln -sfn "$NODE_DIR" "$INSTALLATION_DIR/node"

echo -e "\033[33m>>> node v $VERSION was installed at: $NODE_DIR\033[0m"

