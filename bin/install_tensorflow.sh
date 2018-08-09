#!/usr/bin/env bash

# install_tensorflow.sh
# 
# install Tensorflow for Raspberry Pi
# (https://www.tensorflow.org/install/install_raspbian)
# 
# created on : 2018.08.09.
# last update: 2018.08.09.
# 
# by meinside@gmail.com

sudo apt-get install python3-pip libatlas-base-dev && \
	pip3 install --upgrade --user tensorflow && \
	python3 -c "import tensorflow as tf;print(\"Tensorflow version\", tf.__version__, \"installed.\")"
