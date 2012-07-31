# config/profile files for Raspberry Pi #
by Sungjin Han <meinside@gmail.com>

## DESCRIPTION ##

My personal config/profile files for Raspberry Pi server,

currently running on Raspbian.

* * *

## Additional Configurations ##

### WiFi Configuration (Asus USB N10) ###

``$ sudo vi /etc/network/interfaces``

```

# (add following)

# for hidden ssid (PSK)
auto wlan0
iface wlan0 inet dhcp
  wpa-driver wext
	wpa-scan-ssid 1
	wpa-ap-scan 1
	wpa-key-mgmt WPA-PSK
	wpa-proto RSN WPA
	wpa-pairwise CCMP TKIP
	wpa-group CCMP TKIP
	wpa-ssid [some_ssid]
	wpa-psk [some_password]

# for typical ssid (PSK)
#auto wlan0
#iface wlan0 inet dhcp
#	wpa-ssid [some_ssid]
#	wpa-psk [some_password]
```

``$ sudo ifup wlan0``


### UTF-8 configuration for MySQL ###

``$ sudo vi /etc/mysql/my.cnf``

```
# (add following)

[mysql]default-character-set = utf8
 
[client]
default-character-set = utf8
 
[mysqld]
character-set-client-handshake=FALSE
init_connect="SET collation_connection = utf8_general_ci"
init_connect="SET NAMES utf8"
character-set-server = utf8
collation-server = utf8_general_ci
 
[mysqldump]
default-character-set = utf8
```
