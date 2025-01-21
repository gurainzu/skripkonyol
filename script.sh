#!/bin/bash

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
cp /bind9-conf/db.local /etc/bind/$dbfile1
read -p "Enter the name of your second db file, example=db.absen: " dbfile2
cp /bind9-conf/db.local /etc/bind/$dbfile2
read -p "Enter the name of your db reverse file, example=db.172: " filedbreverse
cp /bind9-conf/db.reverse /etc/bind/$filedbreverse
cp /bind9-conf/named.conf.local /etc/bind/
cp /bind9-conf/named.conf.options /etc/bind/
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
sed -i "s/domain/$domain1/g" /etc/bind/$filedbreverse
sed -i "s/reverseIP/$ipreverse1/g" /etc/bind/$filedbreverse
sleep 2
read -p "Enter your reverse IP that you use in second db file, example=10.31.16: " ipreverse2
sed -i "s/DOMAIN/$domain2/g" /etc/bind/$filedbreverse
sed -i "s/kedua/$ipreverse2/g" /etc/bind/$filedbreverse
sleep 2
read -p "Enter the first block of your IP, example=172: " firstblock
sed -i "s/domain/$domain1/g" /etc/bind/named.conf.local
sed -i "s/DOMAIN/$domain2/g" /etc/bind/named.conf.local
sed -i "s/firstblock/$firstblock/g" /etc/bind/named.conf.local
sed -i "s/dbfile/$dbfile1/g" /etc/bind/named.conf.local
sed -i "s/DBFILE/$dbfile2/g" /etc/bind/named.conf.local
sed -i "s/filedbreverse/$filedbreverse/g" /etc/bind/named.conf.local
systemctl restart bind9
echo "Success replacing domain and IP for your BIND Configuration"

sleep 5
clear

#Installing Apache2
echo "Starting Installing Apache2"
apt install apache2 -y
echo "Complete Installing Apache2"

sleep 5
clear

#Installing PHP/PMA
echo "Starting Installing PHP/PMA"
apt install php php-mysql php-json phpmyadmin -y
echo "Complete Installing PHP/PMA"

sleep 5
clear

#Installing MariaDB Server
echo "Starting Installing MariaDB Server"
apt install mariadb-server -y
systemctl restart mariadb
echo "Complete Installing MariaDB Server"

sleep 5
clear

#Configuring MariaDB Server
echo "Starting Configuring MariaDB Server"
read -p "Enter the first database name, example=wpusk: " database
echo "Please enter the MYSQL Password"
mysqladmin -u root -p create $database;
sleep 2
read -p "Enter the second database name, example=wpabsen: " DATABASE
mysqladmin -u root -p create $DATABASE;
echo "Please enter the MYSQL Password"
sleep 2
echo "Complete Configuring MariaDB Server"

sleep 5
clear

#Downloading Wordpress in Apache
echo "Starting Downloading Wordpress in Apache"
sleep 2
apt install unzip wget -y
cd /var/www/
wget https://wordpress.org/latest.zip
unzip latest.zip && mv wordpress wp-usk
unzip latest.zip && mv wordpress wp-absen
sleep 2
echo "Complete Downloading Wordpress in Apache"

sleep 5
clear

#Configuring Virtual Host in Apache
mv /apache-conf/wp-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/wp-usk.conf
mv /apache-conf/wp-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/wp-absen.conf
mv /apache-conf/pma-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/pma-usk.conf
mv /apache-conf/pma-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/pma-absen.conf
mv /apache-conf/mail-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/mail-absen.conf
mv /apache-conf/cacti-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/cacti-usk.conf
a2ensite wp-usk.conf
a2ensite wp-absen.conf
a2ensite pma-usk.conf
a2ensite pma-absen.conf
a2ensite mail-absen.conf
a2ensite cacti-usk.conf
systemctl restart apache2
sleep 2
echo "Complete Configuring VirtualHost in Apache"
clear
sleep 2

#Installing Postfix & Dovecot for Webmail
apt install postfix dovecot-imapd dovecot-pop3d
echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf
maildirmake.dovecot /etc/skel/Maildir
dpkg-reconfigure postfix
systemctl restart postfix

mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf-back
mv /etc/dovecot/ /etc/dovecot/dovecot.conf-back