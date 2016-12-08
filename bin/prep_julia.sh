#!/usr/bin/env bash

# prep_julia.sh
# 
# Build and install Julia for Raspberry Pi
#
# created on : 2016.11.16.
# last update: 2016.12.08.
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

REPOSITORY="https://github.com/JuliaLang/julia.git"
BRANCH="master"	# tag
JULIA_SRC_DIR="$TEMP_DIR/julia"
JULIA_INSTALL_DIR="$OPT_DIR/julia-$BRANCH"
JULIA_SYM_DIR="$OPT_DIR/julia"

CMAKE_SRC="https://cmake.org/files/v3.7/cmake-3.7.0.tar.gz"
CMAKE_TGZ=`basename "${CMAKE_SRC}"`
CMAKE_DIR_NAME=`basename "${CMAKE_TGZ}" .tar.gz`

function prep {
	# install essential packages
	echo -e "${YELLOW}>>> Installing essential packages...${RESET}"

	# XXX - cmake of Raspbian Jessie is outdated,
	#sudo apt-get install -y libblas3gf liblapack3gf libarpack2 libfftw3-dev libgmp3-dev libmpfr-dev libblas-dev liblapack-dev cmake gcc-4.8 g++-4.8 gfortran libgfortran3 m4 libedit-dev
	sudo apt-get install -y libblas3gf liblapack3gf libarpack2 libfftw3-dev libgmp3-dev libmpfr-dev libblas-dev liblapack-dev gcc-4.8 g++-4.8 gfortran libgfortran3 m4 libedit-dev

	# XXX - so build cmake manually:
	echo -e "${YELLOW}>>> Building ${CMAKE_DIR_NAME}...${RESET}"
	wget "$CMAKE_SRC" -P "$TEMP_DIR"
	cd "$TEMP_DIR"
	tar -xzvf "$CMAKE_TGZ"
	cd "$CMAKE_DIR_NAME"
	./bootstrap
	make
	sudo make install
}

# install Julia
function install_julia {
	# prepare for build
	prep

	# clone the repository
	echo -e "${YELLOW}>>> Cloning repository...${RESET}"
	sudo rm -rf "$JULIA_SRC_DIR"
	git clone -b "$BRANCH" "$REPOSITORY" "$JULIA_SRC_DIR"

	# build
	echo -e "${YELLOW}>>> Building Julia...${RESET}"
	cd "$JULIA_SRC_DIR"
	sudo make all

	# install
	echo -e "${YELLOW}>>> Installing...${RESET}"
	sudo rm -rf "$JULIA_INSTALL_DIR"
	echo "prefix=${JULIA_INSTALL_DIR}" > Make.user
	sudo make install
	sudo chown -R "$USER" "$JULIA_INSTALL_DIR"
	sudo ln -sfn "$JULIA_INSTALL_DIR" "$JULIA_SYM_DIR"

	# clean
	clean

	echo -e "${GREEN}>>> Julia with branch/tag: $BRANCH was installed at: $JULIA_INSTALL_DIR${RESET}"
}

function clean {
	# uninstall cmake
	echo -e "${YELLOW}>>> Cleaning ${CMAKE_DIR_NAME}...${RESET}"
	cd "${TEMP_DIR}/${CMAKE_DIR_NAME}"
	sudo make uninstall
	cd ..
	sudo rm -rf "${TEMP_DIR}/${CMAKE_DIR_NAME}"

	# clean julia src
	echo -e "${YELLOW}>>> Cleaning julia...${RESET}"
	sudo rm -rf "$JULIA_SRC_DIR"
}

# do the actual job
install_julia

