#!/usr/bin/env bash

# prep_go.sh
# 
# Build and install Golang from the official repository
# for Raspberry Pi
#
# (or, can get prebuilt packages at: http://dave.cheney.net/unofficial-arm-tarballs)
# 
# created on : 2014.07.01.
# last update: 2016.10.21.
# 
# by meinside@gmail.com

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

TEMP_DIR="/tmp"
BOOTSTRAP_DIR="$TEMP_DIR/go-bootstrap"
INSTALLATION_DIR="/opt"

REPOSITORY="https://go.googlesource.com/go"
BOOTSTRAP_BRANCH="release-branch.go1.4"

# XXX - edit for different version of Go (see: https://go.googlesource.com/go/+refs)
#INSTALL_BRANCH="release-branch.go1.6"	# branch
INSTALL_BRANCH="go1.7.3"	# tag

function prep {
	# install essential packages
	echo -e "${YELLOW}>>> Installing essential packages...${RESET}"
	sudo apt-get install -y git gcc libc6-dev
}

# build Go (for bootstrap)
function bootstrap {
	prep

	# if Go (for bootstrap) already exists,
	if [ -d "$INSTALLATION_DIR/go" ]; then
		# reuse it
		ln -sf "$INSTALLATION_DIR/go" "$BOOTSTRAP_DIR"

		echo -e "${YELLOW}>>> Reusing Go at: $INSTALLATION_DIR/go${RESET}"
	else
		# clone the repository
		echo -e "${YELLOW}>>> Cloning repository for boostrap($BOOTSTRAP_BRANCH)...${RESET}"
		rm -rf "$BOOTSTRAP_DIR"
		git clone -b "$BOOTSTRAP_BRANCH" "$REPOSITORY" "$BOOTSTRAP_DIR"

		# build
		echo -e "${YELLOW}>>> Building...${RESET}"
		cd "$BOOTSTRAP_DIR/src"
		./make.bash

		if [ -x "$BOOTSTRAP_DIR/bin/go" ]; then
			echo -e "${YELLOW}>>> Go for bootstrap was installed at: $BOOTSTRAP_DIR${RESET}"
		else
			echo -e "${RED}>>> Failed to build Go for bootstrap at: $BOOTSTRAP_DIR${RESET}"
			exit 1
		fi
	fi
}

# clean Go (for bootstrap)
function clean_bootstrap {
	# remove bootstrap go
	echo -e "${YELLOW}>>> Cleaning Go bootstrap at: $BOOTSTRAP_DIR${RESET}"
	rm -rf "$BOOTSTRAP_DIR"
}

# install Go
function install_go {
	bootstrap

	# clone the repository
	echo -e "${YELLOW}>>> Cloning repository...(branch/tag: $INSTALL_BRANCH)${RESET}"
	SRC_DIR="$TEMP_DIR/go-$INSTALL_BRANCH"
	rm -rf "$SRC_DIR"
	git clone -b "$INSTALL_BRANCH" "$REPOSITORY" "$SRC_DIR"

	# build
	echo -e "${YELLOW}>>> Building Go with bootstrap Go...${RESET}"
	cd "$SRC_DIR/src"
	GOROOT_BOOTSTRAP=$BOOTSTRAP_DIR ./make.bash

	# install
	echo -e "${YELLOW}>>> Installing...${RESET}"
	GO_DIR="$INSTALLATION_DIR/go-$INSTALL_BRANCH"
	cd ../..
	sudo mv "$SRC_DIR" "$GO_DIR"
	sudo chown -R "$USER" "$GO_DIR"
	sudo ln -sfn "$GO_DIR" "$INSTALLATION_DIR/go"

	clean_bootstrap

	echo -e "${GREEN}>>> Go with branch/tag: $INSTALL_BRANCH was installed at: $GO_DIR${RESET}"
}

# do the actual job
install_go

