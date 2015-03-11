#!/usr/bin/env bash

# prep_go.sh
# 
# Build and install Golang from the official repository
# for Raspberry Pi
#
# (or, can get prebuilt packages at: http://dave.cheney.net/unofficial-arm-tarballs)
# 
# created on : 2014.07.01.
# last update: 2015.03.11.
# 
# by meinside@gmail.com

REPOSITORY="https://github.com/golang/go.git"
RELEASE_BRANCH_VERSION="1.4"	# XXX - edit this for different version of Go (https://github.com/golang/go/branches/active)

TEMP_DIR="/tmp"
INSTALLATION_DIR="/opt"

# install essential packages
sudo apt-get install -y git gcc libc6-dev

echo -e "\033[33m>>> cloning the repository...\033[0m"

# clone the repository
SRC_DIR="$TEMP_DIR/go-$RELEASE_BRANCH_VERSION"
rm -rf "$SRC_DIR"
git clone -b "release-branch.go$RELEASE_BRANCH_VERSION" "$REPOSITORY" "$SRC_DIR"

echo -e "\033[33m>>> building...\033[0m"

# build
cd "$SRC_DIR/src"
./make.bash

echo -e "\033[33m>>> installing...\033[0m"

# install
GO_DIR="$INSTALLATION_DIR/go-$RELEASE_BRANCH_VERSION"
cd ../..
sudo mv "$SRC_DIR" "$GO_DIR"
sudo chown -R "$USER" "$GO_DIR"
sudo ln -sfn "$GO_DIR" "$INSTALLATION_DIR/go"

echo -e "\033[33m>>> Go release branch version $RELEASE_BRANCH_VERSION was installed at: $GO_DIR\033[0m"

