#!/usr/bin/env bash

# install_leiningen.sh
# 
# for downloading and setting up 'lein' with 'zulu-embedded'
# 
# last update: 2019.09.10.
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

JDK_DIR=/opt/jdk

# https://www.azul.com/downloads/zulu-embedded/
ZULU_EMBEDDED_VERSION="zulu11.33.21-ca-jdk11.0.4-linux_aarch32hf"
ZULU_EMBEDDED_TGZ="http://cdn.azul.com/zulu-embedded/bin/${ZULU_EMBEDDED_VERSION}.tar.gz"

function prep {
	if [ -x  "${JDK_DIR}/${ZULU_EMBEDDED_VERSION}/bin/javac" ]; then
		echo -e "${YELLOW}>>> JDK already installed at: ${JDK_DIR}/${ZULU_EMBEDDED_VERSION}${RESET}"
		return 0
	fi

	# install zulue-embedded java
	sudo mkdir -p "$JDK_DIR" && \
		cd "$JDK_DIR" && \
		sudo wget "$ZULU_EMBEDDED_TGZ" && \
		sudo tar -xzvf "${ZULU_EMBEDDED_VERSION}.tar.gz" && \
		sudo update-alternatives --install /usr/bin/java java ${JDK_DIR}/${ZULU_EMBEDDED_VERSION}/bin/java 181 && \
		sudo update-alternatives --install /usr/bin/javac javac ${JDK_DIR}/${ZULU_EMBEDDED_VERSION}/bin/javac 181 && \
		echo -e "${GREEN}>>> Installed JDK at: ${JDK_DIR}/${ZULU_EMBEDDED_VERSION}${RESET}"
}

function install {
	if [ -x "${LEIN_BIN}" ]; then
		echo -e "${YELLOW}>>> leiningen already installed at: ${LEIN_BIN}${RESET}"
		return 0
	fi

	# install leiningen
	sudo wget "$LEIN_SRC" -O "$LEIN_BIN" && \
		sudo chown $USER.$USER "$LEIN_BIN" && \
		sudo chmod uog+x "$LEIN_BIN" && \
		echo -e "${GREEN}>>> ${LEIN_BIN} was installed.${RESET}"
}

function clean {
	sudo rm -f "${JDK_DIR}/${ZULU_EMBEDDED_TGZ}.tar.gz"
}

prep && install && clean

