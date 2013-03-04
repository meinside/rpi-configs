#!/bin/bash

# clone_configs.sh
# 
# for cloning config files from github for Raspberry Pi
# (https://raw.github.com/meinside/raspiconfigs/master/bin/clone_configs.sh)
# 
# last update: 2013.03.04.
# 
# by meinside@gmail.com

#REPOSITORY="git@github.com:meinside/raspiconfigs.git"
REPOSITORY="git://github.com/meinside/raspiconfigs.git"
TMP_DIR="$HOME/configs.tmp"

echo -e "\033[32mThis script will clone config files for Raspberry Pi\033[0m\n"

if ! `which git`; then
	echo -e "\033[33m>>> installing git...\033[0m\n"
	sudo apt-get install git
fi
rm -rf $TMP_DIR
git clone git://github.com/meinside/raspiconfigs.git $TMP_DIR

shopt -s dotglob nullglob
mv $TMP_DIR/* $HOME/
rm -rf $TMP_DIR

# re-login for loading configs
echo
echo -e "\033[31m*** logout, and login again for reloading configs ***\033[0m"
echo "$ exit\n"
