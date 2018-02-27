#!/usr/bin/env bash

# install_haskell.sh
# 
# for installing haskell stack
# (referenced: http://allocinit.io/haskell/haskell-on-raspberry-pi-3/)
# 
# last update: 2018.02.27.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# prebuilt stack binary (https://github.com/commercialhaskell/stack/releases)
STACK_VERSION="1.6.1"	# XXX - change this version
STACK_BIN="https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-arm.tar.gz"

TMP_DIR="/tmp"
LOCAL_BIN_DIR="/usr/local/bin"

function prep {
	# install needed packages
	sudo apt-get install -y g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg llvm-3.7
}

# download stack binary
function download_stack {
	cd $TMP_DIR && \
	wget $STACK_BIN -O "stack.tgz" && \
	mkdir -p stack && \
	tar -xzvf "stack.tgz" -C stack --strip-components=1 && \
	sudo cp stack/stack $LOCAL_BIN_DIR && \
	echo -e "${GREEN}>>> stack was installed in $LOCAL_BIN_DIR.${RESET}"
}

# install ghc & ghci
function install {
	stack update && stack setup && \
	echo -e "${GREEN}>>> ghc and ghci were installed.${RESET}"
}

prep && download_stack && install

