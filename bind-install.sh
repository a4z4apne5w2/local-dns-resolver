#!/bin/bash

if [ "$UID" -ne "0" ] #User check
then
   echo "Use this script as root."
   exit 1
else
   pacman -Sy bind dnsutils
   wget ftp://ftp.internic.net/domain/named.cache -O /var/named/root.hint #Root servers list
   sed -i 's|file "/var/named/root.hint"|file "root.hint"|' /etc/named.conf
   chattr -i /etc/resolv.conf #Allow the modification of the file
   sed -i 's|nameserver|#nameserver|' /etc/resolv.conf #Disable previous DNS servers
   echo "nameserver 127.0.0.1" >> /etc/resolv.conf #Set localhost as the DNS resolver
   chattr +i /etc/resolv.conf #Disallow the modification of the file
   systemctl start named && systemctl enable named #Enable named at boot and start it
   echo "The installation is done."
fi
