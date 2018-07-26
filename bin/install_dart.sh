#!/usr/bin/env bash

# install_dart.sh
# 
# install pre-built Dart SDK for Raspberry Pi
# from: https://www.dartlang.org/tools/sdk/archive
# 
# created on : 2018.06.28.
# last update: 2018.07.26.
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
#CHANNEL="stable"
#VERSION="1.24.3"
CHANNEL="dev"
VERSION="2.0.0-dev.69.3"

OS="linux"
PLATFORM="arm"	# arm, arm64, ...

DART_DIST_BASEURL="https://storage.googleapis.com/dart-archive/channels/${CHANNEL}/release"
FILENAME="dartsdk-${OS}-${PLATFORM}-release.zip"
DOWNLOAD_URL="${DART_DIST_BASEURL}/${VERSION}/sdk/${FILENAME}"
INSTALLATION_DIR="/opt"
DART_SDK_DIR="${INSTALLATION_DIR}/dart-sdk-${VERSION}"
TEMP_DIR="/tmp"

echo -e "${YELLOW}>>> downloading version $VERSION ...${RESET}" && \
	wget "$DOWNLOAD_URL" -P "$TEMP_DIR"

echo -e "${YELLOW}>>> extracting $FILENAME ...${RESET}" && \
	cd $TEMP_DIR && unzip "$TEMP_DIR/$FILENAME" && \
	sudo mv "$TEMP_DIR/dart-sdk" "$DART_SDK_DIR" && \
	sudo chown -R $USER "$DART_SDK_DIR" && \
	sudo ln -sfn "$DART_SDK_DIR" "$INSTALLATION_DIR/dart-sdk" && \
	sudo rm "$TEMP_DIR/$FILENAME"

echo -e "${GREEN}>>> Dart-SDK $VERSION was installed at: $DART_SDK_DIR ${RESET}"

