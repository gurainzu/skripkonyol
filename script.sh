#!/bin/bash

#Run as root pls
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Installing BIND9
echo "Starting Installing BIND"
sleep 2
apt install bind9 bind9utils dnsutils -y
echo "Complete Installing BIND"
sleep 2

#Configuring BIND9
echo "Starting Copying Template Configuration"
sleep 2
mv /etc/bind/named.conf.local /etc/bind/named.comf.local-back
mv /etc/bind/named.conf.options /etc/bind/named.conf.options-back
mv /home/antix/skripkonyol/bind9-conf/db.192 /etc/bind/
mv /home/antix/skripkonyol/bind9-conf/db.172 /etc/bind/
mv /home/antix/skripkonyol/bind9-conf/db.absen /etc/bind/
mv /home/antix/skripkonyol/bind9-conf/db.usk /etc/bind/
mv /home/antix/skripkonyol/bind9-conf/named.conf.local /etc/bind/
mv /home/antix/skripkonyol/bind9-conf/named.conf.options /etc/bind/
sleep 2
echo "Complete Copying Template Configuration"
sleep 1
echo "Starting to replace all the domain and IP's"
sleep 2


#Installing Apache2
sleep 2
echo -e "\e[92mStarting \e[1mInstalling Apache2"
apt install apache2 -y
echo -e "\e[92mComplete \e[1mInstalling Apache2"
sleep 2

#Installing PHP/PMA
echo -e "\e[92mStarting \e[1mInstalling PHP/PMA"
apt install php php-mysql php-json phpmyadmin -y
echo -e "\e[92mComplete \e[1mInstalling PHP/PMA"

#Installing MariaDB Server
echo -e "\e[92mStarting \e[1mInstalling MariaDB Server"
apt install mariadb-server -y
echo -e "\e[92mComplete \e[1mInstalling MariaDB Server"

#Configuring MariaDB Server
sleep 2
echo -e "\e[92mStarting \e[1mConfiguring MariaDB Server"
mysqladmin -u root -p create wpabsen;
mysqladmin -u root -p create wpusk;
echo -e "\e[92mComplete \e[1mConfiguring MariaDB Server"
sleep 2

#Downloading Wordpress in Apache
echo -e "\e[92mStarting \e[1mDownloading Wordpress in Apache"
apt install unzip wget -y
cd /var/www/
wget https://wordpress.org/latest.zip
unzip latest.zip && mv wordpress wp-usk
unzip latest.zip && mv wordpress wp-absen
echo -e "\e[92mComplete \e[1mDownloading Wordpress in Apache"

#Configuring Virtual Host in Apache
mv /home/antix/skripkonyol/apache-conf/wp-usk.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apache-conf/wp-absen.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apache-conf/pma-usk.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apache-conf/pma-absen.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apache-conf/mail-absen.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apache-conf/cacti-usk.conf /etc/apache2/sites-available/
a2ensite wp-usk.conf
a2ensite wp-absen.conf
a2ensite pma-usk.conf
a2ensite pma-absen.conf
a2ensite mail-absen.conf
a2ensite cacti-usk.conf
systemctl restart apache2
echo -e "\e[92mComplete \e[1mConfiguring VirtualHost in Apache"
