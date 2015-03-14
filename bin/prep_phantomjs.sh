#!/usr/bin/env bash

# prep_phantomjs.sh
# 
# Build and install Phantomjs from the official repository
# for Raspberry Pi
# 
# http://phantomjs.org/build.html
#
# (or, can get prebuilt packages at: http://phantomjs.org/download.html)
# 
# created on : 2015.03.11.
# last update: 2015.03.11.
# 
# by meinside@gmail.com

REPOSITORY="https://github.com/ariya/phantomjs.git"
RELEASE_BRANCH_VERSION="2.0"	# XXX - edit this for different version

TEMP_DIR="/tmp"
INSTALLATION_DIR="/opt"
NUM_JOBS=2

# install essential packages
sudo apt-get -y install build-essential g++ flex bison gperf ruby perl libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev libpng12-dev libjpeg8-dev ttf-mscorefonts-installer

echo -e "\033[33m>>> cloning the repository...\033[0m"

# clone the repository
SRC_DIR="$TEMP_DIR/phantomjs-$RELEASE_BRANCH_VERSION"
rm -rf "$SRC_DIR"
git clone -b "$RELEASE_BRANCH_VERSION" "$REPOSITORY" "$SRC_DIR"

echo -e "\033[33m>>> building...\033[0m"

# build
cd "$SRC_DIR"
./build.sh --confirm --jobs $NUM_JOBS

echo -e "\033[33m>>> installing...\033[0m"

# install
PHANTOMJS_DIR="$INSTALLATION_DIR/phantomjs-$RELEASE_BRANCH_VERSION"
cd ..
sudo mv "$SRC_DIR" "$PHANTOMJS_DIR"
sudo chown -R "$USER" "$PHANTOMJS_DIR"
sudo ln -sfn "$PHANTOMJS_DIR" "$INSTALLATION_DIR/phantomjs"

echo -e "\033[33m>>> Phantomjs version $RELEASE_BRANCH_VERSION was installed at: $PHANTOMJS_DIR\033[0m"

