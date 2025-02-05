#!/bin/bash

# VPS2RouterOS
# https://github.com/Jamesits/vps2routeros
# This script will cause permanent data loss
# Please read the documentation prior to running this
# You have been warned

# ======================= please change these =================================
# your network interface to internet
# this is used to auto configure IPv4 after reboot
# (this may not work for every device)
# eth0 for most devices, ens3 for Vultr
# you can use `ip addr` or `ifconfig` to find out this
# default: the interface on the default route

#source： https://www.digitalocean.com/community/questions/installing-mikrotik-routeros

wget -O chr.img.zip http://47.57.1.21:99/chr-7.17.1-patched.img.zip
gunzip -c chr.img.zip > chr.img
#wget http://r45ihwot8.hn-bkt.clouddn.com/MikroTik-RouterOS-7.1-disk1.img -O chr.img
#wget http://cc.aheig.cc/directlink/2/MikroTik-RouterOS-7.1-disk1.img -O chr.img
mount -o loop,offset=33554944 chr.img /mnt
ADDRESS=`ip addr show eth0 | grep global | cut -d' ' -f 6 | head -n 1`
GATEWAY=`ip route list | grep default | cut -d' ' -f 3`
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1] && \
/ip route add gateway=$GATEWAY && \
/ip service disable telnet && \
/ip service disable www && \
/ip service disable ftp && \
/ip service disable ssh && \
/ip service set winbox port=8192 && \
/user add name=g password=" " group=full && \
/user remove admin && \
 " > /mnt/rw/autorun.scr
umount /mnt
echo u > /proc/sysrq-trigger
dd if=chr.img bs=1024 of=/dev/vda
echo "sync disk"
echo s > /proc/sysrq-trigger
echo "Sleep 5 seconds"
sleep 5
echo "Ok, reboot"
echo b > /proc/sysrq-trigger
