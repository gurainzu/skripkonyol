#!/bin/bash

#Run as root pls
if [ "$EUID" -ne 0 ]
  then echo "Tolong run as root"
  exit
fi

#Cloning Repository
echo -e "\e[92mStarting \e[1mCloning and Updating Repository"
cd /home/antix
git clone https://github.com/gurainzu/skripkonyol
mv /etc/apt/sources.list /etc/apt/sources.list-back
mv /home/antix/skripkonyol/repository/sources.list /etc/apt/
apt update -y
echo -e "\e[92mComplete \e[1mCloning and Updating Repository"

#Installing BIND9
echo -e "\e[92mStarting \e[1mInstalling BIND9"
apt install bind9 bind9utils dnsutils -y
echo -e "\e[92mComplete \e[1mInstalling Complete, configuring BIND9"

#Configuring BIND9
echo -e "\e[92mStarting \e[1mCopying Configuration"
mv /etc/bind/named.conf.local /etc/bind/named.comf.local-back
mv /etc/bind/named.conf.options /etc/bind/named.conf.options-back
mv /home/antix/skripkonyol/bind9conf/db.192 /etc/bind/
mv /home/antix/skripkonyol/bind9conf/db.absen /etc/bind/
mv /home/antix/skripkonyol/bind9conf/db.usk /etc/bind/
mv /home/antix/skripkonyol/bind9conf/named.conf.local /etc/bind/
mv /home/antix/skripkonyol/bind9conf/named.conf.options /etc/bind/
echo -e "\e[92mComplete \e[1mRestarting Services, generating status when complete."
systemctl restart bind9
systemctl status bind9

#Installing Apache2
echo -e "\e[92mStarting \e[1mInstalling Apache2"
apt install apache2 -y
echo -e "\e[92mComplete \e[1mInstalling Apache2"

#Installing PHP/PMA
echo -e "\e[92mStarting \e[1mInstalling PHP/PMA"
apt install php php-mysql php-json phpmyadmin -y
echo -e "\e[92mComplete \e[1mInstalling PHP/PMA"

#Installing MariaDB Server
echo -e "\e[92mStarting \e[1mInstalling MariaDB Server"
apt install mariadb-server -y
echo -e "\e[92mComplete \e[1mInstalling MariaDB Server"

#Configuring MariaDB Server
echo -e "\e[92mStarting \e[1mConfiguring MariaDB Server"
mysql -e "CREATE DATABASE IF NOT EXISTS wp-absen"
mysql -e "CREATE DATABASE IF NOT EXISTS wp-usk"
echo -e "\e[92mComplete \e[1mConfiguring MariaDB Server"

#Downloading Wordpress in Apache
echo -e "\e[92mStarting \e[1mDownloading Wordpress in Apache"
apt install unzip wget -y
cd /var/www/
wget https://wordpress.org/latest.zip
unzip latest.zip && mv wordpress wp-usk
unzip latest.zip && mv wordpress wp-absen
echo -e "\e[92mComplete \e[1mDownloading Wordpress in Apache"

#Configuring Virtual Host in Apache
mv /home/antix/skripkonyol/apacheconf/wp-usk.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apacheconf/wp-absen.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apacheconf/pma-usk.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apacheconf/pma-absen.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apacheconf/mail-absen.conf /etc/apache2/sites-available/
mv /home/antix/skripkonyol/apacheconf/cacti-usk.conf /etc/apache2/sites-available/
a2ensite wp-usk.conf
a2ensite wp-absen.conf
a2ensite pma-usk.conf
a2ensite pma-absen.conf
a2ensite mail-absen.conf
a2ensite cacti-usk.conf
systemctl restart apache2 && systemctl status apache2