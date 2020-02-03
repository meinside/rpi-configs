# dot/config files for Raspberry Pi
by Sungjin Han <meinside@gmail.com>

## Description

My personal dot/config files for Raspberry Pi server, currently running on **Raspbian Buster**.

**NOTE: these files are being maintained [here](https://github.com/meinside/dotfiles) since _2020-02-03_.**

---

## 0. Easy install

### A. use prep script

```
$ cd ~
$ wget -O - "https://raw.github.com/meinside/rpi-configs/master/bin/prep.sh" | bash
```

then this repository will be cloned to the user's home directory.

## 1. Useful Configurations

### A. Setting up watchdog

```bash
$ sudo modprobe bcm2708_wdog
$ sudo vi /etc/modules
```

then add following line:

```
bcm2708_wdog
```

Install watchdog and edit conf:

```bash
$ sudo apt-get install watchdog
$ sudo vi /etc/watchdog.conf
```

uncomment following line:

```
watchdog-device = /dev/watchdog
```

and restart the service:

```bash
$ sudo systemctl restart watchdog
```

### B. Setting up i2c

```bash
$ sudo modprobe i2c_dev
$ sudo vi /etc/modules
```

uncomment following line:

```
i2c-dev
```

edit blacklist:

```bash
$ sudo vi /etc/modprobe.d/raspi-blacklist.conf
```

and comment out following lines if exist:

```
blacklist spi-bcm2708
blacklist i2c-bcm2708
```

Then do the following:

```bash
$ sudo apt-get install i2c-tools
$ sudo usermod -a -G i2c USERNAME
```

## 2. Additional Configurations

### A. WiFi Configuration

#### a. Add a file on the sdcard and reboot

Create a file named `wpa_supplicant.conf` with following content:

```
country=JP
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
        ssid="YOUR-SSID"
        psk=YOUR-PSK

        # Protocol type can be: RSN (for WP2) and WPA (for WPA1)
        proto=RSN

        # Key management type can be: WPA-PSK or WPA-EAP (Pre-Shared or Enterprise)
        key_mgmt=WPA-PSK

        # Pairwise can be CCMP or TKIP (for WPA2 or WPA1)
        pairwise=CCMP

        # Authorization option should be OPEN for both WPA1/WPA2 (in less commonly used are SHARED and LEAP)
        auth_alg=OPEN

        # SSID scan technique (0 for broadcast, 1 for hidden)
        scan_ssid=1

        # Priority
        priority=1
}
```

Replace `YOUR-SSID` and `YOUR-PSK` to yours.

`YOUR-PSK` can be generated like this:

```bash
$ wpa_passphrase [SSID] [PASSWORD]
```

For example,

```bash
$ wpa_passphrase my_ssid 0123456789abc
```

Now put the file on the root of your **Raspberry-Pi-ready** sdcard and boot with it.

#### b. Edit conf file

Do the same on file: `/etc/wpa_supplicant/wpa_supplicant.conf`.

```bash
$ sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
```

After that, turn the WLAN device off and on:

```bash
$ sudo ifdown wlan0
$ sudo ifup wlan0
```

Your WLAN device's name may be different from 'wlan0'.

You can list yours with following command:

```bash
$ ls /sys/class/net | grep wl
```

### B. UTF-8 configuration for MySQL

Open conf:

```bash
$ sudo vi /etc/mysql/my.cnf
```

and add following lines:

```
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

### C. AFP & Zero-conf DNS configuration

#### a. install netatalk and avahi-daemon

```bash
$ sudo apt-get install netatalk
$ sudo apt-get install avahi-daemon
```

#### b. add an avahi-daemon service ####

Create a service file:

```bash
$ sudo vi /etc/avahi/services/SERVICE_NAME.service
```

and add following lines:

```
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
        <type>_ssh._tcp</type>
        <port>22</port>
    </service>
    <service>
        <type>_device-info._tcp</type>
        <port>0</port>
        <txt-record>model=Xserve</txt-record>
    </service>
</service-group>
```

## 3. Etc. Tips

### A. set static dns server even when using DHCP

Open conf:

```bash
$ sudo vi /etc/dhcp/dhclient.conf
```

and add following line:

```
supersede domain-name-servers 8.8.8.8, 8.8.4.4;
```

### B. when using bluetooth

#### 1. with on-board bluetooth module

##### a. install required packages

Install pi-bluetooth:

```bash
$ sudo apt-get install pi-bluetooth
```

and reboot.

##### b. use bluetoothctl

After reboot, use ``bluetoothctl`` for turning up, scanning, and connecting.

```bash
$ sudo bluetoothctl
```

Type ``help`` for commands and options.

#### 2. with dongle

* referenced: http://wiki.debian.org/BluetoothUser

##### a. make raspberry pi discoverable by other bluetooth devices

```bash
$ sudo hciconfig hci0 piscan
$ sudo bluetooth-agent 0000
```

Do as the screen says, and make Raspberry Pi hidden from other bluetooth devices again:

```bash
$ sudo hciconfig hci0 noscan
```

##### b. display bluetooth device (for checking proper installation)

```bash
$ hcitool dev
```

##### c. scan nearby bluetooth devices

```bash
$ hcitool scan
```

##### d. settings

Open conf:

```bash
$ sudo vi /etc/default/bluetooth
```

and add/alter following lines:

```
# edit
#HID2HCI_ENABLED=0
HID2HCI_ENABLED=1

# add static device information
device 01:23:45:AB:CD:EF {
    name "Bluetooth Device Name";
    auth enable;
    encrypt enable;
}
```

### C. use logrotate.d

Create a file:

```bash
$ sudo vi /etc/logrotate.d/some_file
```

and add following lines:

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

### D. mount external hdd on boot time

Open fstab:

```bash
$ sudo vi /etc/fstab
```

and add following lines:

```
/dev/some_hdd1  /some/where/to/mount1  ext4  defaults   0 0
/dev/some_hdd2  /some/where/to/mount2  vfat  rw,noatime,uid=7777,gid=7778,user   0 0
```

**uid** and **gid** can be retrieved with command 'id'.

### E. run scripts periodically

```bash
$ crontab -e
```

and add following lines:

```
# every 5 minutes
*/1 * * * * bash -l /some/script_that_needs_login.sh
# every 1 hour
0 1 * * * bash -l -c /some/ruby_script_under_rvm.rb
```

## 999. Troubleshooting

### Error message: 'smsc95xx 1-1.1:1.0: eth0: kevent 2 may have been dropped'

Append ``smsc95xx.turbo_mode=N`` to ``/boot/cmdline.txt`` file, and

add/alter following lines in ``/etc/sysctl.conf``:

```
#vm.vfs_cache_pressure = 100
vm.vfs_cache_pressure = 300
#vm.min_free_kbytes=8192
vm.min_free_kbytes=32768
```

