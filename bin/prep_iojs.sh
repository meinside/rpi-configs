#!/usr/bin/env bash

# prep_iojs.sh
# 
# install pre-built io.js files for Raspberry Pi
# from: https://iojs.org/dist/
# 
# created on : 2013.07.19.
# last update: 2015.08.12.
# 
# by meinside@gmail.com

VERSION="3.0.0"	# XXX - edit this for other versions

IOJS_DIST_BASEURL="https://iojs.org/dist"
TEMP_DIR="/tmp"
FILENAME="iojs-v$VERSION-linux-armv7l.tar.gz"
DOWNLOAD_PATH="$IOJS_DIST_BASEURL/v$VERSION/$FILENAME"
INSTALLATION_DIR="/opt"
IOJS_DIR="$INSTALLATION_DIR/`basename $FILENAME .tar.gz`"

echo -e "\033[33m>>> downloading version $VERSION ...\033[0m"

wget "$DOWNLOAD_PATH" -P "$TEMP_DIR"

echo -e "\033[33m>>> extracting to: $IOJS_DIR ...\033[0m"

sudo mkdir -p "$INSTALLATION_DIR"
sudo tar -xzvf "$TEMP_DIR/$FILENAME" -C "$INSTALLATION_DIR"
sudo chown -R $USER "$IOJS_DIR"
sudo ln -sfn "$IOJS_DIR" "$INSTALLATION_DIR/node"

echo -e "\033[33m>>> iojs v$VERSION was installed at: $IOJS_DIR\033[0m"

