#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]
  then echo "Tolong run as root"
  exit
fi

# Update sistem dan install bind9
echo "Updating system and installing BIND9..."
apt-get update -y
apt-get install bind9 bind9utils bind9-doc -y

# Enable dan start layanan bind9
echo "Enabling and starting BIND9 service..."
systemctl enable bind9
systemctl start bind9

# Verifikasi instalasi
echo "Checking BIND9 status..."
systemctl status bind9

echo "BIND9 installation completed!"
