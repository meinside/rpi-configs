#!/usr/bin/env bash

# install_rust.sh
# 
# Install Rust and its toolchain from rustup.rs
# for Raspberry Pi
# 
# created on : 2019.02.18.
# last update: 2019.02.18.
# 
# by meinside@gmail.com

# XXX - for making newly created files/directories less restrictive
umask 0022

curl https://sh.rustup.rs -sSf | sh
