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
read -p "Enter the name of your db file, example=db.usk: " dbfile1
cp /home/antix/skripkonyol/bind9-conf/db.local /etc/bind/$dbfile1
read -p "Enter the name of your second db file, example=db.absen: " dbfile2
cp /home/antix/skripkonyol/bind9-conf/db.local /etc/bind/$dbfile2
read -p "Enter the name of your db reverse file, example=db.172: " dbfilereverse
cp /home/antix/skripkonyol/bind9-conf/db.reverse /etc/bind/$dbfilereverse
cp /home/antix/skripkonyol/bind9-conf/named.conf.local /etc/bind/
cp /home/antix/skripkonyol/bind9-conf/named.conf.options /etc/bind/
sleep 2
echo "Complete Copying Template Configuration"
sleep 1
echo "Starting to replace all the domain and IP's"
sleep 2
read -p "Enter your domain for your first db file, example=usk13894.net: " domain1
sed -i "s/domain/$domain1/g" /etc/bind/$dbfile1
sleep 2
read -p "Enter your IP for your first db file, example=172.16.31.10: " ipdomain1
sed -i "s/IP/$ipdomain1/g" /etc/bind/$dbfile1
sleep 2
read -p "Enter your domain for your second db file, example=absen2.my.id: " domain2
sed -i "s/domain/$domain2/g" /etc/bind/$dbfile2
sleep 2
read -p "Enter your IP for your second db file, example=172.16.31.10: " ipdomain2
sed -i "s/IP/$ipdomain2/g" /etc/bind/$dbfile2
sleep 2
read -p "Enter your reverse IP that you use in first db file, example=10.31.16: " ipreverse1
sed -i "s/domain/$domain1/g" /etc/bind/$dbfilereverse
sed -i "s/reverseIP/$ipreverse1/g" /etc/bind/$dbfilereverse
sleep 2
read -p "Enter your reverse IP that you use in second db file, example=10.31.16: " ipreverse2
sed -i "s/DOMAIN/$domain2/g" /etc/bind/$dbfilereverse
sed -i "s/kedua/$ipreverse2/g" /etc/bind/$dbfilereverse
sleep 2
read -p "Enter the first block of your IP, example=172: " firstblock
sed -i "s/domain/$domain1/g" /etc/bind/named.conf.local
sed -i "s/DOMAIN/$domain2/g" /etc/bind/named.conf.local
sed -i "s/firstblock/$firstblock/g" /etc/bind/named.conf.local
sed -i "s/dbfile/$dbfile1/g" /etc/bind/named.conf.local
sed -i "s/DBFILE/$dbfile2/g" /etc/bind/named.conf.local
sed -i "s/dbfilereverse/$dbfilereverse/g" /etc/bind/named.conf.local
echo "Success replacing domain and IP for your BIND Configuration, Restarting...."
systemctl restart bind9

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