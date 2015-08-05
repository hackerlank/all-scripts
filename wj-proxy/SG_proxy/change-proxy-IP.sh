#!/bin/bash
# $1 = old-IP
# $2 = new-IP
# chang-proxy-IP.sh $1 $2 
# Setp 1 : update proxy-IPs.sql file
# Step 2 : update hosts file
# Step 3 : update haproxy.cfg files
cd $(dirname $0) && pwd
oldIPs=(
	"54.169.151.171"
	"54.169.236.197"
	"54.169.240.130"
	"54.169.237.15"
)
newIPs=(
	"52.74.139.59"
	"52.74.14.154"
	"52.74.36.45"
	"52.74.28.15"
)
num=(0 1 2 3)
if [ $# != 2 ]; then
	for i in ${num[@]};do
		oldIP=${oldIPs[$i]}
		newIP=${newIPs[$i]}
		olderIP=`grep -C1 "${oldIPs[$i]}" proxy-IPs.sql |grep "delete" | awk '{print $7}' |awk -F"\"" '{print $2}'`
		# Setp 1 : update proxy-IPs.sql file
		sed -i -r "s|$oldIP|$newIP|g" proxy-IPs.sql
		sed -i -r "s|$olderIP|$oldIP|g" proxy-IPs.sql
		echo "update proxy-IPs.sql OK ^-^"
		# Step 2 : update hosts file
		sed -i -r "s|$oldIP|$newIP|g" hosts
		sed -i -r "s|$oldIP|$newIP|g" hosts-centos
		echo "update hosts OK ^-^"
		# Step 3 : update haproxy.cfg files
		sed -i -r "s|$oldIP|$newIP|g" haproxy/haproxy.cfg.sh-41
		sed -i -r "s|$oldIP|$newIP|g" haproxy/haproxy.cfg.sh-49
		sed -i -r "s|$oldIP|$newIP|g" haproxy/haproxy.cfg.sz-15
		echo "update haproxy.cfg files OK ^-^"
	done
else
	oldIP=$1
	newIP=$2
	olderIP=`grep -C1 $oldIP proxy-IPs.sql |grep "delete" | awk '{print $7}' |awk -F"\"" '{print $2}'`
	# Setp 1 : update proxy-IPs.sql file
	sed -i -r "s|$oldIP|$newIP|g" proxy-IPs.sql
	sed -i -r "s|$olderIP|$oldIP|g" proxy-IPs.sql
	echo "update proxy-IPs.sql OK ^-^"
	# Step 2 : update hosts file
	sed -i -r "s|$oldIP|$newIP|g" hosts
	sed -i -r "s|$oldIP|$newIP|g" hosts-centos 
	echo "update hosts OK ^-^"
	# Step 3 : update haproxy.cfg files
	sed -i -r "s|$oldIP|$newIP|g" haproxy/haproxy.cfg.sh-41
	sed -i -r "s|$oldIP|$newIP|g" haproxy/haproxy.cfg.sh-49
	sed -i -r "s|$oldIP|$newIP|g" haproxy/haproxy.cfg.sz-15
	echo "update haproxy.cfg files OK ^-^"
fi


