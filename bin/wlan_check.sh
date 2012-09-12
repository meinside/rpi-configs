#!/bin/bash

if iwconfig wlan0 | grep -o "Access Point: Not-Associated"
then
	ifconfig wlan0 down
	sleep 10
	ifconfig wlan0 up
fi
