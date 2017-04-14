#!/usr/bin/env bash

# install_nvim.sh
# 
# for building neovim from source code on Raspberry Pi
#
# last update: 2017.04.14.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

TMP_DIR=/tmp/nvim

NVIM_VERSION="v0.1.7"

function prep {
	# install needed packages
	sudo apt-get install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

	clean
}

function clean {
	rm -rf $TMP_DIR
}

function install {
	git clone https://github.com/neovim/neovim.git $TMP_DIR

	cd $TMP_DIR
	git checkout $NVIM_VERSION

	# configure and build
	make CMAKE_BUILD_TYPE=Release

	# install
	sudo make install
}

prep
install
clean

