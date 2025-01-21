#!/bin/bash

#Installing BIND9
echo "Starting Installing BIND"
sleep 2
apt install bind9 bind9utils dnsutils -y
echo "Complete Installing BIND"
sleep 2

#Copying BIND9 File Tempalte
echo "Starting Copying Template Configuration"
sleep 2

mv /etc/bind/named.conf.local /etc/bind/named.conf.local-back
mv /etc/bind/named.conf.options /etc/bind/named.conf.options-back
read -p "Enter the name of your db file, example=db.usk: " dbfile1
cp ~/skripkonyol/bind9-conf/db.local /etc/bind/$dbfile1
read -p "Enter the name of your second db file, example=db.absen: " dbfile2
cp ~/skripkonyol/bind9-conf/db.local /etc/bind/$dbfile2
read -p "Enter the name of your db reverse file, example=db.172: " filedbreverse
cp ~/skripkonyol/bind9-conf/db.reverse /etc/bind/$filedbreverse
cp ~/skripkonyol/bind9-conf/named.conf.local /etc/bind/
cp ~/skripkonyol/bind9-conf/named.conf.options /etc/bind/
sleep 2

#Replacing BIND9 File Template
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
sleep 2
clear

#Installing LAMP
echo "Starting Installing Apache2"
apt install apache2 mariadb-server php php-mysql php-json phpmyadmin -y
systemctl restart mariadb.service
echo "Complete Installing Apache2"
sleep 2
clear

#Configuring MariaDB Server
echo "Starting Configuring MariaDB Server"
sleep 2
read -p "Enter the first database name, example=wpusk: " database
echo "Please enter the MYSQL Password"
mysqladmin -u root -p create $database;
read -p "Enter the second database name, example=wpabsen: " DATABASE
mysqladmin -u root -p create $DATABASE;
echo "Please enter the MYSQL Password"
sleep 2
echo "Complete Configuring MariaDB Server"
sleep 2
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
mv ~/skripkonyol/apache-conf/wp-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/wp-usk.conf
mv ~/skripkonyol/apache-conf/wp-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/wp-absen.conf
mv ~/skripkonyol/apache-conf/pma-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/pma-usk.conf
mv ~/skripkonyol/apache-conf/pma-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/pma-absen.conf
mv ~/skripkonyol/apache-conf/mail-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/mail-absen.conf
mv ~/skripkonyol/apache-conf/cacti-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/cacti-usk.conf
a2ensite wp-usk.conf wp-absen2.conf pma-usk.conf pma-absen.conf mail-absen.conf cacti-usk.conf
systemctl restart apache2
echo "Complete Configuring VirtualHost in Apache"
sleep 2
clear

#Installing Postfix & Dovecot for Webmail
echo "Starting installing wembail dependencies"
sleep 2
apt install postfix dovecot-imapd dovecot-pop3d
clear

#Configuring Postfix & Dovecot for Webmail
echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf
maildirmake.dovecot /etc/skel/Maildir
dpkg-reconfigure postfix
systemctl restart postfix
mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf-back
mv /etc/dovecot/10-auth.conf /etc/dovecot/10-auth.conf-back
mv /etc/dovecot/10-mail.conf /etc/dovecot/10-mail.conf-back
cp ~/skripkonyol/mailserver-conf/dovecot.conf /etc/dovecot/dovecot.conf
cp ~/skripkonyol/mailserver-conf/10-auth.conf /etc/dovecot/10-auth.conf
cp ~/skripkonyol/mailserver-conf/10-mail.conf /etc/dovecot/10-mail.conf
systemctl restart dovecot
sleep 2

#Adding user for Webmail
echo "Starting Adding user for Webmail"
sleep 2
read -p "Enter username for webmail user-1: " user
adduser $user
read -p "Enter username for webmail user-2: " USER
adduser $USER
systemctl restart postfix dovecot

#Installing Roundcube for Webmail
echo "Starting Installing Roundcube for Webmail"
apt install mariadb-server roundcube -y
mv /etc/roundcube/config.inc.php /etc/roundcube/config.inc.php-back
cp ~/skripkonyol/mailserver-conf/config.inc.php /etc/roundcube/
sed -i "s/domain/$domain2/g" /etc/roundcube/config.inc.php
dpkg-reconfigure roundcube-core