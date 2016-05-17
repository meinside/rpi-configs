#!/usr/bin/env bash

# prep_ffmpeg.sh
# 
# for building ffmpeg from source code on Raspberry Pi
# 
# last update: 2016.05.17.
# 
# by meinside@gmail.com

TMP_DIR=/tmp/ffmpeg

function prep {
	# install needed packages
	sudo apt-get install -y libx264-dev libvorbis-dev

	clean
}

function clean {
	rm -rf $TMP_DIR
}

function install {
	git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git $TMP_DIR
	cd $TMP_DIR
	./configure --arch=armel --target-os=linux --enable-gpl --enable-nonfree --enable-libx264 --enable-libvorbis
	make -j4

	# install
	sudo make install
}

prep
install
clean
