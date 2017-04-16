#!/bin/sh
service shadowsocks-libev restart
/usr/sbin/sshd -D
exec "$@"
