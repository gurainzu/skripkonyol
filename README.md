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
`$ cp db.local db.usk` \
`$ nano db.usk` \
`$ cp db.local db.absen` \
`$ nano db.absen` \
`$ nano named.conf.local` \
`$ nano named.conf.options` \
`$ systemctl restart bind9` \
`$ systemctl stsatus bind9`