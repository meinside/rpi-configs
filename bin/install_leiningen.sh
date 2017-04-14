#!/usr/bin/env bash

# install_leiningen.sh
# 
# for downloading and setting up 'lein'
# 
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

LEIN_SRC="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
LEIN_BIN="/usr/local/bin/lein"

function prep {
	# install needed packages
	sudo apt-get install -y oracle-java8-jdk
}

function install {
	sudo wget "$LEIN_SRC" -O "$LEIN_BIN"
	sudo chown $USER.$USER "$LEIN_BIN"
	sudo chmod uog+x "$LEIN_BIN"

	echo -e "${GREEN}>>> ${LEIN_BIN} was installed.${RESET}"
}

prep

install

