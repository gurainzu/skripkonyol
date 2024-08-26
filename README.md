# Write Up? cobain aja aowkwokw
<sub>unclompleted</sub>

Berdasar soal : [USK 2022-2023](https://drive.google.com/file/d/1fjrXfFwDtSrC8JPv1sdGqdAucCUhhWtE/view?usp=sharing)

## Instalasi Debian ?
cari aja di youtube banyak, xD

## Konfigurasi Network
` # This file describes the network interfaces available on your system` \
` # and how to activate them. For more information, see interfaces(5).`

` source /etc/network/interfaces.d/* `

` # The loopback network interface` \
` auto lo ` \
` iface lo inet loopback ` 

` # The primary network interface` \
` auto enp0s3 ` \
` iface enp0s3 inet dhcp `

` auto enp0s8 ` \
` iface enp0s8 inet static ` \
`         address 172.16.31.130/25 ` \
`         gateway 192.168.31.129 ` 

> Ini gua pake 2 interface, enp0s3 bridge, enp0s8 host only.

## Konfigurasi Repository Debian 11 Bullseye
>Ada kok filenya di folder "repository" di repo ini, tinggal copy paste aja.

<sup>jangan tanya gua kenapa gua gapake repo antix</sup>

## Instalasi DNS Server - BIND9
>Semua file konfigurasi udah ada di repo ini, tinggal copy paste sesuain kondisi masing masing.

`$ apt update` \
`$ apt install bind9 bind9utils dnsutils -y` \
`$ cd /etc/bind/` \
`$ cp db.local db.usk && nano db.usk` \
`$ cp db.local db.absen && nano db.absen` \
`$ cp db.127 db.172 && nano db.172` \
`$ nano named.conf.local` \
`$ nano named.conf.options` \
`$ systemctl restart bind9` \
`$ systemctl stsatus bind9`

## Instalasi Wordpress & VHost Apache2
>Semua file konfigurasi udah ada di repo ini, tinggal copy paste sesuain kondisi masing masing.

`$ apt install apache2 wget unzip -y` \
`$ cd /var/www/` \
`$ wget https://wordpress.org/latest.zip` \
`$ unzip latest.zip && mv wordpress wp-usk` \
`$ unzip latest.zip && mv wordpress wp-absen` \
`$ chmod -R 777 wp-usk` \
`$ chmod -R 777 wp-absen` \
`$ cd /etc/apache2/sites-available` \
`$ cp 000-default.conf wp-usk.conf && nano wp-usk.conf` \
`$ cp 000-default.conf wp-absen.conf && nano wp-absen.conf` \
`$ cp 000-default.conf pma-usk.conf && nano pma-usk.conf` \
`$ cp 000-default.conf pma-absen.conf && nano pma-absen.conf` \
`$ cp 000-default.conf mail-absen.conf && nano mail-absen.conf` \
`$ cp 000-default.conf cacti-usk.conf && nano cacti-usk.conf` \
`$ a2ensite wp-usk.conf && systemctl reload apache2` \
`$ a2ensite wp-absen.conf && systemctl reload apache2` \
`$ a2ensite pma-usk.conf && systemctl reload apache2` \
`$ a2ensite pma-absen.conf && systemctl reload apache2` \
`$ a2ensite mail-absen.conf && systemctl reload apache2` \
`$ a2ensite cacti-usk.conf && systemctl reload apache2`
`$ systemctl restart apache2`