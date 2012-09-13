#!/bin/bash

# cron script for checking wlan connectivity

IP_FOR_TEST="8.8.8.8"
INTERFACE="wlan0"

# ping test
`which ping` -c 5 $IP_FOR_TEST > /dev/null
if [ $? -ge 1 ]
then
	echo "$INTERFACE seems to be down, trying to bring it up..."

	ifconfig $INTERFACE down
	sleep 10
	ifconfig $INTERFACE up
else
	echo "$INTERFACE is up"
fi
