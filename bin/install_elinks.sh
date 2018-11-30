#!/usr/bin/env bash

# install_elinks.sh
# 
# install elinks on Raspberry Pi
# 
# created on : 2018.11.30.
# last update: 2018.11.30.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# XXX - edit these for installing other versions
VERSION="0.13"

FILENAME="elinks-current-${VERSION}.tar.bz2"
SRC_URL="http://elinks.or.cz/download/${FILENAME}"
TEMP_DIR="/tmp"
DIR="elinks-src"

echo -e "${YELLOW}>>> downloading version $VERSION ...${RESET}" && \
	wget "$SRC_URL" -P "$TEMP_DIR" && \
echo -e "${YELLOW}>>> installing essential packages...${RESET}" && \
	sudo apt-get -y install libmozjs185-dev pkg-config libssl-dev && \
echo -e "${YELLOW}>>> extracting $FILENAME ...${RESET}" && \
	mkdir -p "$TEMP_DIR/$DIR" && \
	tar -xvf $FILENAME -C "$TEMP_DIR/$DIR" --strip-components=1 && \
	cd "$TEMP_DIR/$DIR" && \
echo -e "${YELLOW}>>> configuring/building in ${PWD}...${RESET}" && \
	./configure && \
	make -j 4 && \
	sudo make install && \
echo -e "${YELLOW}>>> cleaning...${RESET}" && \
	cd $TEMP_DIR && \
	rm -rf "$TEMP_DIR/$DIR" "$TEMP_DIR/$FILENAME" && \
echo -e "${GREEN}>>> elinks $VERSION was installed."

