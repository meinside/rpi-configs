# Config/Profile files for Raspberry Pi #
by Sungjin Han <meinside@gmail.com>

## Description ##

My personal config/profile files for Raspberry Pi server, currently running on Raspbian.

(dependent on: https://github.com/meinside/myrubyscripts as $HOME/ruby/)


* * *

## Useful Configurations ##

### Setting up watchdog ###

```
$ sudo modprobe bcm2708_wdog

$ sudo vi /etc/modules

# Add following line:
bcm2708_wdog

# and install watchdog daemon:
$ sudo apt-get install watchdog
$ chkconfig watchdog on
$ sudo /etc/init.d/watchdog start

$ sudo vi /etc/watchdog.conf

# Uncomment line: 'watchdog-device = /dev/watchdog'
```

### Setting up i2c ###

```
$ sudo modprobe i2c_dev

$ sudo vi /etc/modules

# Add following line:
i2c-dev

$ sudo vi /etc/modprobe.d/raspi-blacklist.conf 

# Comment out following lines:
blacklist spi-bcm2708
blacklist i2c-bcm2708

$ sudo apt-get install i2c-tools

$ sudo usermod -a -G i2c USERNAME
```

## Additional Configurations ##

### Install RVM for multi-users ###

```
$ curl -L get.rvm.io | sudo bash -s stable
$ sudo /usr/sbin/usermod -a -G rvm USERNAME
$ sudo chown root.rvm /etc/profile.d/rvm.sh
```

#### * if gem complains about bundler like: 'Gem::InstallError: gem "bundler" is not installed': ####
``$ rvm gemset use global``

### WiFi Configuration ###

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

### run WiFi connection checker periodically ###

``$ sudo crontab -e``

```
# (add following)

# will check wlan connectivity every 5 minutes
*/5 * * * * /home/USERNAME/cron/wlan_check.sh
```


### UTF-8 configuration for MySQL ###

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


### Apache-Passenger configurations ###

#### How to install Apache-Passenger module ####

```
$ gem install passenger
$ sudo passenger-install-apache2-module

# (and do as the install script says...)
```

#### Configure rails page as webroot's subdir ####

```
$ sudo ln -sf /path/to/rails_app/public /var/www/rails_app
$ sudo chown USERNAME.www-data /path/to/rails_app -R
$ sudo vi /etc/apache2/sites-available/default

# (add following)

<Directory /path/to/rails_app/public>
    RailsBaseURI /rails_app
    PassengerResolveSymlinksInDocumentRoot on
</Directory>
```

#### Configure rails page as subdomain ####

``$ sudo vi /etc/apache2/sites-available/rails_app``

```
# (create a new file)

<VirtualHost *:80>
    ServerAdmin someone@some_domain.com
    ServerName rails_app.some_domain.com
    DocumentRoot /path/to/rails_app/public
    <Directory /path/to/rails_app/public>
        PassengerResolveSymlinksInDocumentRoot on
    </Directory>
</VirtualHost>
```
