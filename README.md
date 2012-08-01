# Config/Profile files for Raspberry Pi #
by Sungjin Han <meinside@gmail.com>

## Description ##

My personal config/profile files for Raspberry Pi server, currently running on Raspbian.


* * *

## Additional Configurations ##

### Install RVM for multi-users ###

```
$ curl -L get.rvm.io | sudo bash -s stable
$ sudo /usr/sbin/usermod -a -G rvm username
$ sudo chown root.rvm /etc/profile.d/rvm.sh
```

``$ vi .bashrc``

```
# (add following)

# for RVM
[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"  # This loads RVM into a shell session.
```

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
#    wpa-ssid [some_ssid]
#    wpa-psk [some_password]
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


### Apache-Passenger configurations ###

#### How to install Apache-Passenger module ####

```
$ rvm use 1.9.3
$ gem install passenger
$ sudo passenger-install-apache2-module
$ sudo ln -sf ~/rails/rails_app/public /var/www/rails_app
$ sudo chown username.www-data ~/rails/rails_app -R
```

#### Configure rails page as webroot's subdir ####

``$ sudo vi /etc/apache2/sites-available/default``

```
# (add following)

<Directory /home/meinside/rails/rails_app/public>
    RailsBaseURI /rails_app
    PassengerResolveSymlinksInDocumentRoot on
</Directory>
```

#### Configure rails page as subdomain ####

``$ sudo vi /etc/apache2/sites-available/rails_app``

```
# (create a new file)

<VirtualHost *:80>
    ServerAdmin meinside@gmail.com
    ServerName rails_app.some_domain.com
    DocumentRoot ~/rails/rails_app/public
    <Directory ~/rails/rails_app/public>
        PassengerResolveSymlinksInDocumentRoot on
    </Directory>
</VirtualHost>
```
