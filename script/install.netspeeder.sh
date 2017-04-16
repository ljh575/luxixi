#!/bin/bash
# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

echo "=========================================================================\n"
printf "Auto install net-speeder on your vps,written by tennfy \n"
printf "Version 0.1 \n"

apt-get update && apt-get install --no-install-recommends -y \
    gcc libnet1 libpcap0.8  \
    libnet1-dev libpcap0.8-dev

INSTALL_TMP=/tmp/install.tmp/install.netspeeder

mkdir -p $INSTALL_TMP
cd $INSTALL_TMP

wget --no-check-certificate https://github.com/snooda/net-speeder/raw/master/net_speeder.c
wget --no-check-certificate https://github.com/snooda/net-speeder/raw/master/build.sh

chmod +x build.sh

if [ -f /proc/user_beancounters ] || [ -d /proc/bc ]; then
    sh build.sh -DCOOKED
    INTERFACE=venet0
else
    sh build.sh
    INTERFACE=eth0
fi

if [ -e net_speeder ] ; then
    cp net_speeder /
else
    echo "build failed"
fi

#nohup /root/net_speeder $INTERFACE "ip" >/dev/null 2>&1 &

sed -i 's/exit\ 0/#exit\ 0/' /etc/rc.local
echo 'nohup /root/net_speeder $INTERFACE "ip" >/dev/null 2>&1 &' >> /etc/rc.local  
echo exit 0 >> /etc/rc.local

echo "=========================================================================\n"
echo "Auto install net-speeder Complete!Good Bye!"
echo "=========================================================================\n"
