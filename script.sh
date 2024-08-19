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
mv /home/antix/skripkonyol/sources.list /etc/apt/
apt update -y

#Installing BIND9
echo -e "Normal \e[1mInstalling BIND9"
apt install bind9 bind9utils dnsutils -y
echo -e "Normal \e[1mInstalling Complete, generating status"