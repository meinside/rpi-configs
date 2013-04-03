#!/bin/bash

# prep.sh
# 
# for cloning config files from github for Raspberry Pi
# (https://raw.github.com/meinside/raspiconfigs/master/bin/prep.sh)
# 
# last update: 2013.04.03.
# 
# by meinside@gmail.com

#REPOSITORY="git@github.com:meinside/raspiconfigs.git"
REPOSITORY="git://github.com/meinside/raspiconfigs.git"
TMP_DIR="$HOME/configs.tmp"

echo -e "\033[32mThis script will clone config files for Raspberry Pi\033[0m\n"

# clone config files
if ! which git > /dev/null; then
	echo -e "\033[33m>>> installing git...\033[0m\n"
	sudo apt-get update
	sudo apt-get -y install git
fi
rm -rf $TMP_DIR
git clone $REPOSITORY $TMP_DIR

# move to $HOME directory
shopt -s dotglob nullglob
mv $TMP_DIR/* $HOME/
rm -rf $TMP_DIR

# upgrade packages
sudo apt-get -y upgrade

# install other essential packages
sudo apt-get -y install vim

# cleanup
sudo apt-get -y autoremove
sudo apt-get -y autoclean

# re-login for loading configs
echo
echo -e "\033[31m*** logout, and login again for reloading configs ***\033[0m"
echo "$ exit"
echo
