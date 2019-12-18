#!/usr/bin/env bash

# install_nodejs.sh
# 
# install pre-built Node.js (LTS) for Raspberry Pi
# from: https://nodejs.org/dist
# 
# created on : 2013.07.19.
# last update: 2019.12.18.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

VERSION="12.14.0"	# XXX - edit this for other versions
PLATFORM=`uname -m`	# armv7l, armv6l, ...

NODEJS_DIST_BASEURL="https://nodejs.org/dist"
TEMP_DIR="/tmp"
FILENAME="node-v${VERSION}-linux-${PLATFORM}.tar.gz"
DOWNLOAD_PATH="$NODEJS_DIST_BASEURL/v$VERSION/$FILENAME"
INSTALLATION_DIR="/opt"
NODEJS_DIR="$INSTALLATION_DIR/`basename $FILENAME .tar.gz`"

echo -e "${YELLOW}>>> downloading version $VERSION ...${RESET}"

wget "$DOWNLOAD_PATH" -P "$TEMP_DIR"

echo -e "${YELLOW}>>> extracting to: $NODEJS_DIR ...${RESET}"

sudo mkdir -p "$INSTALLATION_DIR"
sudo tar -xzvf "$TEMP_DIR/$FILENAME" -C "$INSTALLATION_DIR"
sudo chown -R $USER "$NODEJS_DIR"
sudo ln -sfn "$NODEJS_DIR" "$INSTALLATION_DIR/node"

echo -e "${GREEN}>>> nodejs v$VERSION was installed at: $NODEJS_DIR ${RESET}"

