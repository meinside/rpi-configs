#!/bin/bash

# cron script for checking wlan connectivity
IP_FOR_TEST="8.8.8.8"
PING_COUNT=5

PING="/bin/ping"
IFUP="/sbin/ifup"
IFDOWN="/sbin/ifdown"

INTERFACE="wlan0"

# ping test
$PING -c $PING_COUNT $IP_FOR_TEST > /dev/null
if [ $? -ge 1 ]
then
	echo "$INTERFACE seems to be down, trying to bring it up..."

	$IFDOWN $INTERFACE
	sleep 10
	$IFUP $INTERFACE
else
	echo "$INTERFACE is up"
fi
