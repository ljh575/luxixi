#!/bin/sh

locale-gen en_US.UTF-8
/bin/ln -sfT /bin/bash /bin/sh

sh script/install.ss-libev.sh $1
sh script/install.netspeeder.sh
