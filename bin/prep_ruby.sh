#!/bin/bash

# prep_ruby.sh
# 
# for setting up environment for ruby on Raspberry Pi
# (https://raw.github.com/meinside/raspiconfigs/master/bin/prep_ruby.sh)
# 
# last update: 2013.07.22.
# 
# by meinside@gmail.com

echo -e "\033[32mThis script will help setting up rvm on this Raspberry Pi\033[0m\n"

# install RVM for multi-users
echo -e "\033[33m>>> installing RVM and Ruby for multi-users...\033[0m\n"
curl -#L https://get.rvm.io | sudo bash -s stable --autolibs=3 --ruby

# install additional packages
sudo apt-get install -y libxml2-dev libxslt1-dev

# setting up permissions
sudo /usr/sbin/usermod -a -G rvm $USER
sudo chown root.rvm /etc/profile.d/rvm.sh

# re-login for loading rvm and installing ruby
echo
echo -e "\033[31m*** logout, and login again for using Ruby ***\033[0m"
echo
