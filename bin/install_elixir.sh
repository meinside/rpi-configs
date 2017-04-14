#!/usr/bin/env bash

# install_elixir.sh
# 
# Build and install Elixir (and Erlang)
# for Raspberry Pi
#
# created on : 2017.01.03.
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
INSTALLATION_DIR="/opt"

ERLANG_VERSION="19.2"
ERLANG_SRC="http://erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz"
ELIXIR_REPOSITORY="https://github.com/elixir-lang/elixir.git"

ERLANG_DIR="${INSTALLATION_DIR}/erlang-${ERLANG_VERSION}"
ELIXIR_DIR="${INSTALLATION_DIR}/elixir"

function prep {
	# install essential packages
	echo -e "${YELLOW}>>> Installing essential packages...${RESET}"
	sudo apt-get install -y libssl-dev ncurses-dev m4 unixodbc-dev
}

# install Erlang and Elixir
function install {
	prep
	
	# download source codes of Erlang,
	DOWNLOADED_ERLANG="$TEMP_DIR/erlang-${ERLANG_VERSION}.tar.gz"
	wget "$ERLANG_SRC" -O "$DOWNLOADED_ERLANG"

	# unzip it,
	cd "$TEMP_DIR"
	tar -xzvf "$DOWNLOADED_ERLANG"

	# build it,
	ERLANG_SRC_DIR="$TEMP_DIR/`basename "${ERLANG_SRC}" .tar.gz`"
	cd "$ERLANG_SRC_DIR"
	./configure --prefix="$ERLANG_DIR"
	make

	# install it,
	echo -e "${YELLOW}>>> Installing Erlang...${RESET}"
	sudo make install

	# and setup
	sudo chown -R "$USER" "$ERLANG_DIR"
	sudo ln -sfn "$ERLANG_DIR" "$INSTALLATION_DIR/erlang"

	# clone source codes of Elixir,
	echo -e "${YELLOW}>>> Installing Elixir...${RESET}"
	sudo git clone "$ELIXIR_REPOSITORY" "$ELIXIR_DIR"

	# and test
	sudo chown -R "$USER" "$ELIXIR_DIR"
	cd "$ELIXIR_DIR"
	make clean test

	# clean up
	sudo rm -rf "$ERLANG_SRC_DIR" "$DOWNLOADED_ERLANG"

	echo -e "${GREEN}>>> Installed Erlang-$ERLANG_VERSION in: $ERLANG_DIR, Elixir in: $ELIXIR_DIR ${RESET}"
}

# do the actual job
install

