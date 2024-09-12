# Write Up? cobain aja aowkwokw
<sub>unclompleted</sub>

Berdasar soal : [USK 2022-2023](https://drive.google.com/file/d/1fjrXfFwDtSrC8JPv1sdGqdAucCUhhWtE/view?usp=sharing)

## Instalasi Debian ?
cari aja di youtube banyak, xD

## Konfigurasi Network
```console
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/* 

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet dhcp

auto enp0s8
iface enp0s8 inet static
        address 172.16.31.130/25
        gateway 192.168.31.129
```

> Ini gua pake 2 interface, enp0s3 bridge, enp0s8 host only.

## Konfigurasi Repository Debian 11 Bullseye

```console
# deb cdrom:[Debian GNU/Linux 11.4.0 _Bullseye_ - Official amd64 NETINST 20220709-10:31]/ bullseye main

#deb cdrom:[Debian GNU/Linux 11.4.0 _Bullseye_ - Official amd64 NETINST 20220709-10:31]/ bullseye main

#deb http://security.debian.org/debian-security bullseye-security main
#deb-src http://security.debian.org/debian-security bullseye-security main

deb http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb http://security.debian.org/debian-security/ bullseye-security main contrib non-free

# This system was installed using small removable media
# (e.g. netinst, live or single CD). The matching "deb cdrom"
# entries were disabled at the end of the installation process.
# For information about how to configure apt package sources,
# see the sources.list(5) manual.
```

<sup>jangan tanya gua kenapa gua gapake repo antix</sup>

## Instalasi DNS Server - BIND9

>Semua file konfigurasi ada di repo ini, tinggal copy paste aja.

```console

root@gurainzu:~# apt update
root@gurainzu:~# apt install bind9 bind9utils dnsutils -y
root@gurainzu:~# cd /etc/bind/
root@gurainzu:~# cp db.local db.usk && nano db.usk
root@gurainzu:~# cp db.local db.absen && nano db.absen
root@gurainzu:~# cp db.127 db.172 && nano db.172
root@gurainzu:~# nano named.conf.local
root@gurainzu:~# nano named.conf.options
root@gurainzu:~# systemctl restart bind9
root@gurainzu:~# systemctl stsatus bind9

```

## Instalasi Wordpress & VHost Apache2

>Semua file konfigurasi ada di repo ini, tinggal copy paste aja.

```console

root@gurainzu:~# apt install apache2 wget unzip -y
root@gurainzu:~# cd /var/www/
root@gurainzu:~# wget https://wordpress.org/latest.zip
root@gurainzu:~# unzip latest.zip && mv wordpress wp-usk
root@gurainzu:~# unzip latest.zip && mv wordpress wp-absen
root@gurainzu:~# chmod -R 777 wp-usk
root@gurainzu:~# chmod -R 777 wp-absen
root@gurainzu:~# cd /etc/apache2/sites-available
root@gurainzu:~# cp 000-default.conf wp-usk.conf && nano wp-usk.conf
root@gurainzu:~# cp 000-default.conf wp-absen.conf && nano wp-absen.conf
root@gurainzu:~# cp 000-default.conf pma-usk.conf && nano pma-usk.conf
root@gurainzu:~# cp 000-default.conf pma-absen.conf && nano pma-absen.conf
root@gurainzu:~# cp 000-default.conf mail-absen.conf && nano mail-absen.conf
root@gurainzu:~# cp 000-default.conf cacti-usk.conf && nano cacti-usk.conf
root@gurainzu:~# a2ensite wp-usk.conf && systemctl reload apache2
root@gurainzu:~# a2ensite wp-absen.conf && systemctl reload apache2
root@gurainzu:~# a2ensite pma-usk.conf && systemctl reload apache2
root@gurainzu:~# a2ensite pma-absen.conf && systemctl reload apache2
root@gurainzu:~# a2ensite mail-absen.conf && systemctl reload apache2
root@gurainzu:~# a2ensite cacti-usk.conf && systemctl reload apache2
root@gurainzu:~# systemctl restart apache2

```

## Instalasi LAMP

```console

root@gurainzu:~# apt install mariadb-server -y
root@gurainzu:~# mysql_secure_installation
root@gurainzu:~# mysql -u root -p
MariaDB [(none)]> create database wpusk;
MariaDB [(none)]> create database wpabsen;
MariaDB [(none)]> show databases;
MariaDB [(none)]> quit;
root@gurainzu:~# apt install php libapache2-mod-php php-mysql phpmyadmin -y
```