#!/bin/bash

# cron script for checking wlan connectivity
# (should be run as root)
#
# last update: 2013.05.21.

IP_FOR_TEST="8.8.8.8"
PING_COUNT=5
PING="/bin/ping"

IFDOWN="/sbin/ifdown"
INTERFACE="wlan0"
SERVICE="networking"

AVAHI_DISABLED_FILE="/var/run/avahi-daemon/disabled-for-unicast-local"

# ping test
$PING -c $PING_COUNT $IP_FOR_TEST > /dev/null
if [ $? -ge 1 ];
then
	echo "$INTERFACE seems to be down, trying to bring it up..."

	# bring down the interface
	sudo $IFDOWN $INTERFACE

	sleep 10

	# restart networking service
	sudo service $SERVICE restart

	# restart avahi-daemon
	if [ -f $AVAHI_DISABLED_FILE ];
	then
		sudo rm -f $AVAHI_DISABLED_FILE
		sudo service avahi-daemon restart
	fi
else
	echo "$INTERFACE is up"
fi

