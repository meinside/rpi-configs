#!/bin/bash
#
# script for recovering wifi connection
#
#
# * for running every five minute:
#
# $ crontab -e
# 
# # m h  dom mon dow   command
# */5 * * * * /path/to/check_wlan.sh

WLAN=wlan0

PING_IP=8.8.8.8
SLEEP_SECONDS=5

# ping
sudo /bin/ping -c4 ${PING_IP} > /dev/null

# if ping fails,
if [ $? != 0 ]; then
	echo "Restaring wlan interface: ${WLAN} ..."

	sudo /sbin/ifdown --force ${WLAN}
	sleep ${SLEEP_SECONDS}
	sudo /sbin/ifup --force ${WLAN}
fi
