#!/usr/bin/env bash

# install_julia.sh
# 
# Build and install Julia for Raspberry Pi
#
# created on : 2016.11.16.
# last update: 2017.04.14.
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

function prep {
	# install essential packages
	echo -e "${YELLOW}>>> Installing essential packages...${RESET}"

	sudo apt-get install -y libblas3gf liblapack3gf libarpack2 libfftw3-dev libgmp3-dev libmpfr-dev libblas-dev liblapack-dev cmake gcc-4.8 g++-4.8 gfortran libgfortran3 m4 libedit-dev
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
	# clean julia src
	echo -e "${YELLOW}>>> Cleaning julia...${RESET}"
	sudo rm -rf "$JULIA_SRC_DIR"
}

# do the actual job
install_julia

