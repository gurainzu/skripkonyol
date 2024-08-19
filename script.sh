#!/bin/bash

#Run as root pls
if [ "$EUID" -ne 0 ]
  then echo "Tolong run as root"
  exit
fi

#Cloning Repository
echo -e "Normal \e[1mCloning and Updating Repository"
cd /home/antix
git clone https://github.com/gurainzu/skripkonyol
mv /etc/apt/sources.list /etc/apt/sources.list-back
mv /home/antix/skripkonyol/repository/sources.list /etc/apt/
apt update -y

#Installing BIND9
echo -e "Normal \e[1mInstalling BIND9"
apt install bind9 bind9utils dnsutils -y
echo -e "Normal \e[1mInstalling Complete, configuring BIND9"

#Configuring BIND9
echo -e "Normal \e[1mCopying Configuration"
mv /etc/bind/named.conf.local /etc/bind/named.comf.local-back
mv /etc/bind/named.conf.options /etc/bind/named.conf.options-back
mv /home/antix/skripkonyol/bind9conf/db.172 /etc/bind/
mv /home/antix/skripkonyol/bind9conf/db.absen /etc/bind/
mv /home/antix/skripkonyol/bind9conf/db.usk /etc/bind/
echo -e "Normal \e[1mRestarting Services, generating status when complete."
systemctl status bind9
