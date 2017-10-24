#!/usr/bin/env bash
#
# script for recovering wifi connection
#
# last update: 2017.10.24.
#
#
# * for running every five minute:
#
# $ crontab -e
# 
# # m h  dom mon dow   command
# */5 * * * * /path/to/check_wlan.sh

PING_IP=8.8.8.8
SLEEP_SECONDS=5

while read -r interface; do
	echo "Checking wlan interface: ${interface}"

	# ping
	sudo /bin/ping -c 2 -I ${interface} ${PING_IP} > /dev/null

	# if ping fails,
	if [ $? != 0 ]; then
		echo "Restaring wlan interface: ${interface} ..."

		sudo /sbin/ifdown ${interface}
		sleep ${SLEEP_SECONDS}
		sudo /sbin/ifup --force ${interface}
	fi
done <<< `ls /sys/class/net | grep wl`

