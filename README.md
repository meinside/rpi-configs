# Config/Profile files for Raspberry Pi #
by Sungjin Han <meinside@gmail.com>

## Description ##

My personal config/profile files for Raspberry Pi server, currently running on Raspbian.

* * *

## 0. For My Comfort ##

### A. use prep script ###

```
$ wget "https://github.com/meinside/raspiconfigs/raw/master/bin/prep.sh"
$ chmod +x prep.sh
$ ./prep.sh
```

## 1. Useful Configurations ##

### A. Setting up watchdog ###

``$ sudo modprobe bcm2708_wdog``

``$ sudo vi /etc/modules``

```
# Add following line:
bcm2708_wdog
```

``$ sudo apt-get install watchdog``

``$ sudo chkconfig watchdog on``

``$ sudo /etc/init.d/watchdog start``

``$ sudo vi /etc/watchdog.conf``

```
# Uncomment line:

watchdog-device = /dev/watchdog
```

### B. Setting up i2c ###

``$ sudo modprobe i2c_dev``

``$ sudo vi /etc/modules``

```
# Add following line:

i2c-dev
```

``$ sudo vi /etc/modprobe.d/raspi-blacklist.conf ``

```
# Comment out following lines:

blacklist spi-bcm2708
blacklist i2c-bcm2708
```

``$ sudo apt-get install i2c-tools``

``$ sudo usermod -a -G i2c USERNAME``

## 2. Additional Configurations ##

### A. Install RVM for multi-users ###

``$ curl -L get.rvm.io | sudo bash -s stable``

``$ sudo /usr/sbin/usermod -a -G rvm USERNAME``

``$ sudo chown root.rvm /etc/profile.d/rvm.sh``

### B. WiFi Configuration ###

``$ sudo vi /etc/network/interfaces``

```
# (add following)

# for hidden ssid (PSK)
allow-hotplug wlan0
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
#allow-hotplug wlan0
#auto wlan0
#iface wlan0 inet dhcp
#    wpa-ssid [some_ssid]
#    wpa-psk [some_password]
```

``$ sudo ifup wlan0``

### C. run WiFi connection checker periodically ###

``$ sudo crontab -e``

```
# (add following)

# will check wlan connectivity every 5 minutes
*/5 * * * * /home/USERNAME/cron/wlan_check.sh
# or every 1 hour
0 */1 * * * /home/USERNAME/cron/wlan_check.sh
```


### D. UTF-8 configuration for MySQL ###

``$ sudo vi /etc/mysql/my.cnf``

```
# (add following)

[mysql]
default-character-set = utf8
 
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


### E. Rails: Passenger configurations ###

* see: https://github.com/meinside/rails-on-raspberrypi#install-passenger-module


### F. AFP & Zero-conf DNS configuration ###

#### a. install netatalk and avahi-daemon ####

``$ sudo apt-get install netatalk``

``$ sudo apt-get install avahi-daemon``

#### b. install dnssd module for apache2 ####

``$ sudo apt-get install libapache2-mod-dnssd``

``$ sudo a2enmod mod-dnssd``

#### c. add an avahi-daemon service ####

``$ sudo vi /etc/avahi/services/SERVICE_NAME.service``

```
# (create a new file with following content)

<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
    <name replace-wildcards="yes">%h</name>
    <service>
        <type>_afpovertcp._tcp</type>
        <port>548</port>
    </service>
    <service>
        <type>_http._tcp</type>
        <port>80</port>
    </service>
    <service>
        <type>_device-info._tcp</type>
        <port>0</port>
        <txt-record>model=Xserve</txt-record>
    </service>
</service-group>
```

## 3. Etc. Tips ##

### A. set static dns server even when using DHCP ###

``$ sudo vi /etc/dhcp/dhclient.conf``

```
# add following:
supersede domain-name-servers 8.8.8.8, 8.8.4.4;
```

### B. when using bluetooth with dongle ###

* referenced: http://wiki.debian.org/BluetoothUser

#### a. make raspberry pi discoverable by other bluetooth devices ####

``$ sudo hciconfig hci0 piscan``

``$ sudo bluetooth-agent 0000``

do something here,
and make raspberry pi hidden from other bluetooth devices again

``$ sudo hciconfig hci0 noscan``

#### b. display bluetooth device (for checking proper installation) ####

``$ hcitool dev``

#### c. scan nearby bluetooth devices ####

``$ hcitool scan``

#### d. settings ####

``$ sudo vi /etc/default/bluetooth``

```
# edit
#HID2HCI_ENABLED=0
HID2HCI_ENABLED=1

# add static device informations
device 01:23:45:AB:CD:EF {
    name "Bluetooth Device Name";
    auth enable;
    encrypt enable;
}
```

### C. use logrotate.d ###

``$ sudo vi /etc/logrotate.d/some_file``

```
    /some_where/*.log {
      compress
      copytruncate
      daily
      delaycompress
      missingok
      rotate 7
      size=5M
    }
```
