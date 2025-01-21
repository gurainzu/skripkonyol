#!/bin/bash

# Debian 12 Repository
# deb http://deb.debian.org/debian bookworm contrib main non-free-firmware
# deb http://deb.debian.org/debian bookworm-updates contrib main non-free-firmware
# deb http://deb.debian.org/debian bookworm-backports contrib main non-free-firmware
# deb http://deb.debian.org/debian-security bookworm-security contrib main non-free-firmware

# Changing Repository
mv /etc/apt/sources.list /etc/apt/sources.list-back
touch /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm contrib main non-free-firmware" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm-updates contrib main non-free-firmware" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm-backports contrib main non-free-firmware" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security bookworm-security contrib main non-free-firmware" >> /etc/apt/sources.list

# Updating Repository
apt update
apt install dos2unix figlet -y && clear

# Installing BIND9
figlet -t "Starting Installing BIND" && sleep 2
apt install bind9 bind9utils dnsutils -y
figlet -t "Complete Installing BIND" && sleep 5 && clear

# Copying BIND9 File Tempalte
figlet -t "Starting Copying BIND Template" && sleep 2

# Backup-ing some important file sample
mv /etc/bind/named.conf.local /etc/bind/named.conf.local-back
mv /etc/bind/named.conf.options /etc/bind/named.conf.options-back

# First File
read -p "Enter the name of your db file, example=db.usk: " dbfile1
cp ~/skripkonyol/bind9-conf/db.local /etc/bind/$dbfile1

sleep 2

# Second File
# You can comment this if you dont need second domain
read -p "Enter the name of your second db file, example=db.absen: " dbfile2
cp ~/skripkonyol/bind9-conf/db.local /etc/bind/$dbfile2

sleep 2

# Reverse File
read -p "Enter the name of your db reverse file, example=db.172: " filedbreverse
cp ~/skripkonyol/bind9-conf/db.reverse /etc/bind/$filedbreverse

 sleep 2

# Copying template 
cp ~/skripkonyol/bind9-conf/named.conf.local /etc/bind/
cp ~/skripkonyol/bind9-conf/named.conf.options /etc/bind/

figlet -t "Completed Copying BIND Template" && sleep 5 && clear

# Replacing BIND9 File Template
figlet -t "Starting Configuring BIND Template" && sleep 2

# First Domain
read -p "Enter your domain for your first db file, example=usk13894.net: " domain1
sed -i "s/domain/$domain1/g" /etc/bind/$dbfile1

sleep 2

read -p "Enter your IP for your first db file, example=172.16.31.10: " ipdomain1
sed -i "s/IP/$ipdomain1/g" /etc/bind/$dbfile1

sleep 2

# Second Domain
# You can comment this if you dont need second domain.
read -p "Enter your domain for your second db file, example=absen2.my.id: " domain2
sed -i "s/domain/$domain2/g" /etc/bind/$dbfile2

sleep 2

read -p "Enter your IP for your second db file, example=172.16.31.10: " ipdomain2
sed -i "s/IP/$ipdomain2/g" /etc/bind/$dbfile2

sleep 2

# Reverse Domain
read -p "Enter your reverse IP that you use in first db file, example=10.31.16: " ipreverse1
sed -i "s/domain/$domain1/g" /etc/bind/$filedbreverse
sed -i "s/reverseIP/$ipreverse1/g" /etc/bind/$filedbreverse

sleep 2

# Second Reverse Domain
# You can comment this if you dont need second domain
read -p "Enter your reverse IP that you use in second db file, example=10.31.16: " ipreverse2
sed -i "s/DOMAIN/$domain2/g" /etc/bind/$filedbreverse
sed -i "s/kedua/$ipreverse2/g" /etc/bind/$filedbreverse

sleep 2

# Path for BIND9 Configuration
read -p "Enter the first block of your IP, example=172: " firstblock
sed -i "s/domain/$domain1/g" /etc/bind/named.conf.local
sed -i "s/DOMAIN/$domain2/g" /etc/bind/named.conf.local
sed -i "s/firstblock/$firstblock/g" /etc/bind/named.conf.local
sed -i "s/dbfile/$dbfile1/g" /etc/bind/named.conf.local
sed -i "s/DBFILE/$dbfile2/g" /etc/bind/named.conf.local
sed -i "s/filedbreverse/$filedbreverse/g" /etc/bind/named.conf.local

# Restarting BIND9 Services
systemctl restart bind9
figlet -t "Success Configuring BIND9" && sleep 5 && clear

# Installing LAMP
figlet -t "Starting Installing LAMP" && sleep 2

apt install apache2 mariadb-server php php-mysql php-json phpmyadmin -y

# Restarting MariaDB first to avoid error at configuring
systemctl restart mariadb.service

figlet -t "Completed Installing LAMP" && sleep 5 && clear

# Configuring MariaDB Server
figlet -t "Starting Configuring MariaDB Server" && sleep 2

# Creating first database for Wordpress
read -p "Enter the first database name, example=wpusk: " database
echo "Please enter the MYSQL Password"
mysqladmin -u root -p create $database;

# Creating second database for Wordpress
# You can comment this if you dont need second database
read -p "Enter the second database name, example=wpabsen: " DATABASE
mysqladmin -u root -p create $DATABASE;
echo "Please enter the MYSQL Password"

figlet -t "Completed Configuring MariaDB Server" && sleep 5 && clear

# Downloading Wordpress in Apache
figlet -t "Starting Downloading Wordpress" && sleep 2

# Packages for Wordpress
apt install unzip wget -y

cd /var/www/
wget https://wordpress.org/latest.zip
unzip latest.zip && mv wordpress wp-usk
unzip latest.zip && mv wordpress wp-absen
sleep 2 && clear

figlet -t "Completed Downloading Wordpress" && sleep 5 && clear

# Configuring Virtual Host in Apache
figlet -t "Start Configuring VHost in Apache" && sleep 2

# Copying and Replacing path for www. subdomain in first domain
mv ~/skripkonyol/apache-conf/wp-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/wp-usk.conf

# Copying and Replacing path for www. subdomain in second domain
# You can comment this if you didnt use the second domain
mv ~/skripkonyol/apache-conf/wp-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/wp-absen.conf

# Copying and Replacing path for pma. subdomain in first domain
mv ~/skripkonyol/apache-conf/pma-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/pma-usk.conf

# Copying and Replacing path for pma. subdomain in second domain
# You can comment this if you didnt use the second domain
mv ~/skripkonyol/apache-conf/pma-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/pma-absen.conf

# Copying and Replacing path for mail. subdomain in second domain
# Disclaimer : I use second domain for the webmail
# You can comment or change this if you didnt use the second domain
mv ~/skripkonyol/apache-conf/mail-absen.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain2/g" /etc/apache2/sites-available/mail-absen.conf

# Copying and Replacing path for cacti. subdomain in first domain
mv ~/skripkonyol/apache-conf/cacti-usk.conf /etc/apache2/sites-available/
sed -i "s/domain/$domain1/g" /etc/apache2/sites-available/cacti-usk.conf

# Enabling all the apache config
a2ensite wp-usk.conf wp-absen2.conf pma-usk.conf pma-absen.conf mail-absen.conf cacti-usk.conf

systemctl restart apache2

figlet -t "Completed Configuring VHost in Apache" && sleep 5 && clear

# Changing resolv.conf
echo "nameserver $ipdomain1" > /etc/resolv.conf

# Installing Postfix & Dovecot for Webmail
figlet -t "Starting Installing Webmail Packages" && sleep 2

apt install postfix dovecot-imapd dovecot-pop3d -y

# Configuring Postfix & Dovecot for Webmail
# Adding mailbox path
echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf
maildirmake.dovecot /etc/skel/Maildir
dpkg-reconfigure postfix

systemctl restart postfix

# Backup-ing some important file sample
mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf-back
mv /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf-back
mv /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf-back

# Copying file sample template
cp ~/skripkonyol/mailserver-conf/dovecot.conf /etc/dovecot/dovecot.conf
cp ~/skripkonyol/mailserver-conf/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
cp ~/skripkonyol/mailserver-conf/10-mail.conf /etc/dovecot/conf.d/10-mail.conf

systemctl restart dovecot && sleep 2

figlet -t "Completed Installing Webmail Packages" && sleep 5 && clear

# Adding user for Webmail
figlet -t "Starting Adding user for Webmail" && sleep 2

# User 1
read -p "Enter username for webmail user-1: " user
adduser $user

# User 2
read -p "Enter username for webmail user-2: " USER
adduser $USER

systemctl restart postfix dovecot

figlet -t "Completed Adding user for Webmail" && sleep 5 && clear

# Installing Roundcube for Webmail
figlet -t "Starting Installing Roundcube for Webmail" && sleep 2

apt install mariadb-server roundcube -y

# Backup-ing some important file sample
mv /etc/roundcube/config.inc.php /etc/roundcube/config.inc.php-back

# Copying and replacing file sample template
cp ~/skripkonyol/mailserver-conf/config.inc.php /etc/roundcube/
sed -i "s/domain/$domain2/g" /etc/roundcube/config.inc.php

dpkg-reconfigure roundcube-core

figlet -t "Completed Installing Webmail" && sleep 5 && clear