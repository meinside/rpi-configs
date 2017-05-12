#!/usr/bin/env bash

# install_haskell.sh
# 
# for installing haskell stack
# (referenced: http://allocinit.io/haskell/haskell-on-raspberry-pi-3/)
# 
# last update: 2017.05.12.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# prebuilt stack binary
STACK_BIN="https://github.com/commercialhaskell/stack/releases/download/v1.3.2/stack-1.3.2-linux-arm.tar.gz"

TMP_DIR="/tmp"
LOCAL_BIN_DIR="/usr/local/bin"

function prep {
	# install needed packages
	sudo apt-get install -y g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg llvm-3.7
	sudo ln -sf /usr/bin/opt-3.7 /usr/bin/opt
	sudo ln -sf /usr/bin/llc-3.7 /usr/bin/llc
}

# download stack binary
function download_stack {
	cd $TMP_DIR
	wget $STACK_BIN -O "stack.tgz"
	mkdir -p stack
	tar -xzvf "stack.tgz" -C stack --strip-components=1
	sudo cp stack/stack $LOCAL_BIN_DIR

	echo -e "${GREEN}>>> stack was installed in $LOCAL_BIN_DIR.${RESET}"
}

# install ghc & ghci
function install {
	stack update && stack setup

	echo -e "${GREEN}>>> ghc and ghci were installed.${RESET}"
}

prep
download_stack
install

