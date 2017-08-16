#!/usr/bin/env bash

# install_ffmpeg.sh
# 
# for building ffmpeg from source code on Raspberry Pi
#
# (pass '--do-not-clean' argument for preserving files after install)
# 
# last update: 2017.08.16.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

TMP_DIR=/tmp/ffmpeg

function prep {
	# install needed packages
	sudo apt-get install -y build-essential libx264-dev libvorbis-dev libmp3lame-dev

	clean
}

function clean {
	rm -rf $TMP_DIR
}

function install {
	git clone --depth=1 https://github.com/FFmpeg/FFmpeg.git $TMP_DIR
	cd $TMP_DIR
	./configure --arch=armel --target-os=linux --enable-gpl --enable-nonfree --enable-libx264 --enable-libvorbis --enable-libmp3lame
	make -j4

	# install
	sudo make install
}

prep && install

# check if '--do-not-clean' argument was given
if [[ $1 != '--do-not-clean' ]]; then
	clean
else
	echo ">>> ffmpeg files remain in $TMP_DIR"
fi
