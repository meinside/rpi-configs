#!/usr/bin/env bash

# install_nvim.sh
# 
# for building neovim from source code on Raspberry Pi
#
# last update: 2019.01.03.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

TMP_DIR=/tmp/nvim

NVIM_VERSION="v0.3.2"

function prep {
	# install needed packages
	sudo apt-get install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python-dev python3-pip gettext
	sudo pip3 install --upgrade pynvim

	# symlink .vimrc file
	mkdir -p ~/.config/nvim
	ln -sf ~/.vimrc ~/.config/nvim/init.vim

	# clean tmp directory
	clean
}

function clean {
	sudo rm -rf $TMP_DIR
}

function install {
	git clone https://github.com/neovim/neovim.git $TMP_DIR

	cd $TMP_DIR
	git checkout $NVIM_VERSION

	# configure and build
	rm -rf build
	make clean
	make CMAKE_BUILD_TYPE=RelWithDebInfo

	# install
	sudo make install
}

prep && install && clean

