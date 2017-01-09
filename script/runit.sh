#!/bin/sh
##  start script for DOCKER
if [ -f /proc/user_beancounters ] || [ -d /proc/bc ] ; then
    nohup /net_speeder venet0 "ip" &> /dev/null &
else
    nohup /net_speeder eth0 "ip" &> /dev/null &
fi
service shadowsocks-libev restart
/usr/sbin/sshd -D
exec "$@"
