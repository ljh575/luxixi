#!/bin/sh

locale-gen en_US.UTF-8
/bin/ln -sfT /bin/bash /bin/sh

GITHUB="https://github.com/ljh575/luxixi/raw/master"

INSTALL_TMP=/tmp/install.tmp
mkdir -p $INSTALL_TMP
cd $INSTALL_TMP

apt-get update
apt-get -y --force-yes install wget

rm $INSTALL_TMP/install.ss-libev.sh*
wget --no-check-certificate $GITHUB/script/install.ss-libev.sh

if [[ -f install.ss-libev.sh ]] ; then
    sh install.ss-libev.sh install $1
    echo "install.ss-libev done!"
else
    echo "wget install.ss-libev.sh failed"
fi

rm $INSTALL_TMP/install.netspeeder.sh*
wget --no-check-certificate $GITHUB/script/install.netspeeder.sh

if [[ -f install.netspeeder.sh ]] ; then
    sh install.netspeeder.sh
    echo "install.netspeeder done!"
else
    echo "wget install.netspeeder.sh failed"
fi


