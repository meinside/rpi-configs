#!/usr/bin/env bash

# install_opencv.sh
# 
# Build and install OpenCV on Raspberry Pi (for Python 2.7)
#
# created on : 2016.12.02.
# last update: 2017.08.16.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

TEMP_DIR="/tmp"
OPT_DIR="/opt"

# opencv version
VERSION="3.1.0"

# source files
OPENCV_SRC_TGZ="https://github.com/opencv/opencv/archive/${VERSION}.tar.gz"
OPENCV_MODULE_TGZ="https://github.com/opencv/opencv_contrib/archive/${VERSION}.tar.gz"

# downloaded src files
SRC_FILEPATH="${TEMP_DIR}/opencv-${VERSION}.tgz"
MODULE_FILEPATH="${TEMP_DIR}/opencv_contrib-${VERSION}.tgz"

# extracted dirs
SRC_DIRPATH="${TEMP_DIR}/`basename "$SRC_FILEPATH" .tgz`"
MODULE_DIRPATH="${TEMP_DIR}/`basename "$MODULE_FILEPATH" .tgz`"

# env name for virtualenv
ENV_NAME="opencv"

function prep {
	# install essential packages
	echo -e "${YELLOW}>>> Installing essential packages...${RESET}"

	sudo apt-get -y install build-essential cmake pkg-config libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libatlas-base-dev gfortran python2.7-dev

	sudo apt-get -y install python-pip
	sudo pip install virtualenv virtualenvwrapper

	# XXX - fix permissions
	sudo chmod -R go+rX /usr/local/lib/python2.7/site-packages
	sudo chmod -R go+rX /usr/local/lib/python2.7/dist-packages
	sudo chmod o+rx /usr/local/include/*
}

function build {
	# download,
	wget -O "$SRC_FILEPATH" "$OPENCV_SRC_TGZ"
	wget -O "$MODULE_FILEPATH" "$OPENCV_MODULE_TGZ"

	# unzip,
	cd "$TEMP_DIR"
	tar -xzvf `basename "$SRC_FILEPATH"`
	tar -xzvf `basename "$MODULE_FILEPATH"`

	# configure virtualenv
	export WORKON_HOME=$HOME/.virtualenvs
	source "/usr/local/bin/virtualenvwrapper.sh"
	mkvirtualenv $ENV_NAME

	# change env and install numpy
	echo -e "${YELLOW}>>> Building in virtualenv: ${ENV_NAME}...${RESET}"
	workon $ENV_NAME
	pip install numpy

	# cmake
	echo -e "${YELLOW}>>> CMake...${RESET}"
	cd "$SRC_DIRPATH"
	mkdir build
	cd build
	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH="$MODULE_DIRPATH/modules" -D BUILD_EXAMPLES=ON ..

	# make
	echo -e "${YELLOW}>>> Make...${RESET}"
	make

	# make install
	echo -e "${YELLOW}>>> Installing...${RESET}"
	sudo make install
	sudo ldconfig
	ln -sf /usr/local/lib/python2.7/site-packages/cv2.so $WORKON_HOME/$ENV_NAME/lib/python2.7/site-packages/cv2.so
}

function check_installation {
	INSTALLED_VERSION=`python -c "import cv2;print cv2.__version__"`
	test $INSTALLED_VERSION = $VERSION && echo -e "${GREEN}>>> Successfully installed OpenCV ${VERSION} in virtualenv: ${ENV_NAME}.${RESET}" || echo -e "${RED}*** Failed to install OpenCV ${VERSION}.${RESET}"
}

function clean {
	echo -e "${YELLOW}>>> Cleaning...${RESET}"

	sudo rm -rf "$SRC_FILEPATH" "$MODULE_FILEPATH" "$SRC_DIRPATH" "$MODULE_DIRPATH"
	sudo rm -rf ~/.cache/pip
}

prep && build && check_installation && clean

