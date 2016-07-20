#!/usr/bin/env bash

# prep_go.sh
# 
# Build and install Golang from the official repository
# for Raspberry Pi
#
# (or, can get prebuilt packages at: http://dave.cheney.net/unofficial-arm-tarballs)
# 
# created on : 2014.07.01.
# last update: 2016.07.20.
# 
# by meinside@gmail.com

TEMP_DIR="/tmp"
BOOTSTRAP_DIR="$TEMP_DIR/go-bootstrap"
INSTALLATION_DIR="/opt"

REPOSITORY="https://go.googlesource.com/go"
BOOTSTRAP_BRANCH="release-branch.go1.4"

# XXX - edit for different version of Go (see: https://go.googlesource.com/go/+refs)
#INSTALL_BRANCH="release-branch.go1.6"	# branch
INSTALL_BRANCH="go1.6.3"	# tag

function prep {
	# install essential packages
	echo -e "\033[33m>>> installing essential packages...\033[0m"
	sudo apt-get install -y git gcc libc6-dev
}

# build Go (for bootstrap)
function bootstrap {
	prep

	# if Go (for bootstrap) already exists,
	if [ -d "$INSTALLATION_DIR/go" ]; then
		# reuse it
		ln -sf "$INSTALLATION_DIR/go" "$BOOTSTRAP_DIR"

		echo -e "\033[33m>>> Reusing Go at: $INSTALLATION_DIR/go\033[0m"
	else
		# clone the repository
		echo -e "\033[33m>>> cloning repository for boostrap($BOOTSTRAP_BRANCH)...\033[0m"
		rm -rf "$BOOTSTRAP_DIR"
		git clone -b "$BOOTSTRAP_BRANCH" "$REPOSITORY" "$BOOTSTRAP_DIR"

		# build
		echo -e "\033[33m>>> building...\033[0m"
		cd "$BOOTSTRAP_DIR/src"
		./make.bash

		echo -e "\033[33m>>> Go for bootstrap was installed at: $BOOTSTRAP_DIR\033[0m"
	fi
}

# clean Go (for bootstrap)
function clean_bootstrap {
	# remove bootstrap go
	echo -e "\033[33m>>> cleaning Go bootstrap at: $BOOTSTRAP_DIR\033[0m"
	rm -rf "$BOOTSTRAP_DIR"
}

# install Go
function install_go {
	bootstrap

	# clone the repository
	echo -e "\033[33m>>> cloning repository...(branch/tag: $INSTALL_BRANCH)\033[0m"
	SRC_DIR="$TEMP_DIR/go-$INSTALL_BRANCH"
	rm -rf "$SRC_DIR"
	git clone -b "$INSTALL_BRANCH" "$REPOSITORY" "$SRC_DIR"

	# build
	echo -e "\033[33m>>> building go with bootstrap go...\033[0m"
	cd "$SRC_DIR/src"
	GOROOT_BOOTSTRAP=$BOOTSTRAP_DIR ./make.bash

	# install
	echo -e "\033[33m>>> installing...\033[0m"
	GO_DIR="$INSTALLATION_DIR/go-$INSTALL_BRANCH"
	cd ../..
	sudo mv "$SRC_DIR" "$GO_DIR"
	sudo chown -R "$USER" "$GO_DIR"
	sudo ln -sfn "$GO_DIR" "$INSTALLATION_DIR/go"

	clean_bootstrap

	echo -e "\033[33m>>> Go with branch/tag: $INSTALL_BRANCH was installed at: $GO_DIR\033[0m"
}

# do the actual job
install_go

