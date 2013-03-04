#!/bin/bash

# prep_ruby.sh
# 
# for setting up environment for ruby on Raspberry Pi
# (https://raw.github.com/meinside/raspiconfigs/master/bin/prep_ruby.sh)
# 
# last update: 2013.03.04.
# 
# by meinside@gmail.com

echo -e "\033[32mThis script will help setting up rvm on this Raspberry Pi\033[0m"

# install essential packages for rvm and ruby
echo
echo -e "\033[33m>>> installing essential packages for RVM and Ruby...\033[0m"
echo
sudo apt-get --no-install-recommends install bash build-essential bzip2 curl openssl libreadline6 libreadline6-dev curl git git-core zlib1g zlib1g-dev libssl-de
v libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libgdbm-dev libncurses5-dev automake libtool bison subversion patch pkg-config 
libffi-dev

# install RVM for multi-users
echo
echo -e "\033[33m>>> installing RVM for multi-users...\033[0m"
echo
curl -L get.rvm.io | sudo bash -s stable
sudo /usr/sbin/usermod -a -G rvm $USER
sudo chown root.rvm /etc/profile.d/rvm.sh

# re-login for loading rvm and installing ruby
echo
echo -e "\033[31m*** logout, and login again for installing Ruby ***\033[0m"
echo "$ rvm install ruby"
echo
