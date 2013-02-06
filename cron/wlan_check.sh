#!/bin/bash

# cron script for checking wlan connectivity
# last update: 2013.02.06.

IP_FOR_TEST="8.8.8.8"
PING_COUNT=5
PING="/bin/ping"

IFUP="/sbin/ifup"
IFDOWN="/sbin/ifdown"
INTERFACE="wlan0"

FILES_TO_BE_DELETED="/var/run/avahi-daemon/disabled-for-unicast-local"

# ping test
$PING -c $PING_COUNT $IP_FOR_TEST > /dev/null
if [ $? -ge 1 ]
then
	echo "$INTERFACE seems to be down, trying to bring it up..."

	# delete files
	sudo rm -f $FILES_TO_BE_DELETED

	# bring down and up the interface
	$IFDOWN $INTERFACE
	sleep 10
	$IFUP $INTERFACE
else
	echo "$INTERFACE is up"
fi
