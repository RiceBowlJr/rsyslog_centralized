#!/bin/bash
# Rsyslog server configuration
# Only tested for Debian Jessie

sudo su

sed --in-place -e 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
sed --in-place -e 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
echo '$template syslog,"/var/log/clients/%fromhost%/syslog.log"' >> /etc/rsyslog.conf
echo '*.* ?syslog' >> /etc/rsyslog.conf

systemctl restart rsyslog

echo 'Rsyslog server is now configured. Please make sure that clients are now pointing here.'

exit
