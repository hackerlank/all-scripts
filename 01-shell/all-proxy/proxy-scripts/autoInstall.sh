#!/bin/bash

# autoInstall haproxy
# autoInstall sh-41
# autoInstall sh-49
# autoInstall sz-15
cd $(dirname $0) && pwd
mark=`date +%F_%H-%M-%S`
conf="haproxy.cfg"
confDir="/etc/haproxy/"

case $1 in 
sh-41)
	cp haproxy/$conf.$1 $confDir 
	cd $confDir
	mv $conf $conf.$mark
	mv $conf.$1 $conf
	/etc/init.d/haproxy reload
	;;
sh-49)
	cp haproxy/$conf.$1 $confDir 
	cd $confDir
	mv $conf $conf.$mark
	mv $conf.$1 $conf
	/etc/init.d/haproxy reload
	;;
sz-15)
	cp haproxy/$conf.$1 $confDir 
	cd $confDir
	mv $conf $conf.$mark
	mv $conf.$1 $conf
	/etc/init.d/haproxy reload
	;;
*)
	echo "Usage autoInstall.sh (sh-41|sh-49|sz-15)"
esac
