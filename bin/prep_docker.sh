#!/usr/bin/env bash

# prep_docker.sh
# 
# Install docker and setup related stuffs
# for Raspberry Pi
#
# (.deb files are from: http://blog.hypriot.com/downloads/)
#
# It can be uninstalled with: sudo dpkg -r docker-hypriot
# 
# created on : 2015.12.24.
# last update: 2016.02.18.
# 
# by meinside@gmail.com

DEB_FILE="http://downloads.hypriot.com/docker-hypriot_1.10.1-1_armhf.deb"	# XXX - edit this for newer package

TEMP_DIR="/tmp"
TEMP_FILE="$TEMP_DIR/`basename $DEB_FILE`"

# download
function download {
	wget $DEB_FILE -P $TEMP_DIR
}

# setup
function setup {
	sudo dpkg -i $TEMP_FILE
	sudo sh -c 'usermod -aG docker $SUDO_USER'
	sudo systemctl enable docker.service
}

# clean
function clean {
	rm -f $TEMP_FILE
}

# install
function install {
	download
	setup
	clean
}

# do the actual job
install

