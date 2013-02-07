#!/bin/bash

# cron script for checking wlan connectivity
# last update: 2013.02.07.

IP_FOR_TEST="8.8.8.8"
PING_COUNT=5
PING="/bin/ping"

IFUP="/sbin/ifup"
IFDOWN="/sbin/ifdown"
INTERFACE="wlan0"

AVAHI_DISABLED_FILE="/var/run/avahi-daemon/disabled-for-unicast-local"

# ping test
$PING -c $PING_COUNT $IP_FOR_TEST > /dev/null
if [ $? -ge 1 ];
then
	echo "$INTERFACE seems to be down, trying to bring it up..."

	# bring down and up the interface
	$IFDOWN $INTERFACE
	sleep 10
	$IFUP $INTERFACE

	# restart avahi-daemon
	if [ -f $AVAHI_DISABLED_FILE ];
	then
		sudo rm -f $AVAHI_DISABLED_FILE
		sudo service avahi-daemon restart
	fi
else
	echo "$INTERFACE is up"
fi

