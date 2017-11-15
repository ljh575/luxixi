#! /bin/bash
#===============================================================================================
#   System Required:  Debian or Ubuntu (32bit/64bit)
#   Description:  Install Shadowsocks(libev) for Debian or Ubuntu
#   Author: tennfy <admin@tennfy.com>
#   Intro:  http://www.tennfy.com
#===============================================================================================

function check_sanity {
	# Do some sanity checking.
	if [ $(/usr/bin/id -u) != "0" ]
	then
		die 'Must be run by root user'
	fi

	if [ ! -f /etc/debian_version ]
	then
		die "Distribution is not supported"
	fi
}

function die {
	echo "ERROR: $1" > /dev/null 1>&2
	exit 1
}

INSTALL_TMP=$HOME/install.ss-libev

rm -rf $INSTALL_TMP
mkdir -p $INSTALL_TMP

############################### install function##################################
function install_shadowsocks_tennfy(){
cd $INSTALL_TMP

# install
apt-get update 
apt-get install --no-install-recommends -y autoconf libtool shtool
apt-get install --no-install-recommends -y \
    git curl wget  build-essential automake \
    autoconf libtool libssl-dev  xmlto shtool \
    libpcre3 libpcre3-dev libudns-dev libev-dev \
    libmbedtls-dev libsodium-dev  libc-ares-dev libsodium18

if [[ -f /usr/lib/x86_64-linux-gnu/libsodium.so.18 ]] ; then
    \ln -sfT /usr/lib/x86_64-linux-gnu/libsodium.so.18 /usr/lib/x86_64-linux-gnu/libsodium.so
fi
if [[ -f /usr/lib/libsodium.so.18 ]] ; then
    \ln -sfT /usr/lib/libsodium.so.18 /usr/lib/libsodium.so
fi

#download source code
echo "================================"
echo "git clone https://github.com/shadowsocks/shadowsocks-libev.git"
git clone https://github.com/shadowsocks/shadowsocks-libev.git

#compile install
cd shadowsocks-libev

## get submodule
git submodule update --init --recursive

if [[ ! -f configure ]] ; then
    sh autogen.sh
    if [ $? -ne 0 ] ; then
        libtoolize --force
        aclocal
        autoheader
        automake --force-missing --add-missing
        autoconf
    fi
fi

if [[ $# -ge 1 ]] ; then
    echo "git reset --hard $1"
    git reset --hard $1
fi 

./configure --prefix=/usr --disable-documentation
make && make install

if [ $? -ne 0 ] ; then
    echo "shadowsocks compile/install failed"
    exit 
fi

mkdir -p /etc/shadowsocks-libev
cp ./debian/shadowsocks-libev.init /etc/init.d/shadowsocks-libev
cp ./debian/shadowsocks-libev.default /etc/default/shadowsocks-libev
chmod +x /etc/init.d/shadowsocks-libev

## config
wget --no-check-certificate https://github.com/ljh575/luxixi/raw/master/files/ssconfig.json
cat ssconfig.json > /etc/shadowsocks-libev/config.json


#aotustart configuration
update-rc.d shadowsocks-libev defaults

#start service
/etc/init.d/shadowsocks-libev start

#if failed, start again --debian8 specified
if [ $? -ne 0 ];then
#failure indication
    echo ""
    echo "Sorry, shadowsocks-libev install failed!"
else
#success indication
    echo ""
    echo "Congratulations, shadowsocks-libev install completed!"
    cat /etc/shadowsocks-libev/config.json
fi
}

############################### uninstall function##################################
function uninstall_shadowsocks_tennfy(){
#change the dir to shadowsocks-libev

if [ -d $INSTALL_TMP/shadowsocks-libev ] ; then
    cd $INSTALL_TMP/shadowsocks-libev

    #stop shadowsocks-libev process
    /etc/init.d/shadowsocks-libev stop

    #uninstall shadowsocks-libev
    make uninstall
    make clean
    cd ..
    rm -rf shadowsocks-libev
else
    echo "$INSTALL_TMP/shadowsocks-libev not exists !"
fi

# delete config file
rm -rf /etc/shadowsocks-libev

# delete shadowsocks-libev init file
rm -f /etc/init.d/shadowsocks-libev
rm -f /etc/default/shadowsocks-libev

#delete start with boot
update-rc.d -f shadowsocks-libev remove

echo "Shadowsocks-libev uninstall success!"

}

############################### update function##################################
function update_shadowsocks_tennfy(){
     uninstall_shadowsocks_tennfy
     install_shadowsocks_tennfy
	 echo "Shadowsocks-libev update success!"
}
############################### Initialization##################################
# Make sure only root can run our script
check_sanity

action=$1
[  -z $1 ] && action=install
case "$action" in
install)
    install_shadowsocks_tennfy $2
    ;;
uninstall)
    uninstall_shadowsocks_tennfy
    ;;
update)
    update_shadowsocks_tennfy
    ;;	
*)
    echo "Arguments error! [${action} ]"
    echo "Usage: `basename $0` {install|uninstall|update}"
    ;;
esac
