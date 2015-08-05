#!/bin/bash
# $1 = old-IP
# $2 = new-IP
# chang-proxy-IP.sh $1 $2 
# Step 1 : update wj_proxy_hosts.txt file
# Step 2 : update haproxy.cfg files
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
		# Step 1 : update hosts file
		sed -i -r "s|$oldIP|$newIP|g" wj_proxy_hosts.txt
		echo "update hosts OK ^-^"
		# Step 2 : update haproxy.cfg files
		sed -i -r "s|$oldIP|$newIP|g" haproxy.cfg
		echo "update haproxy.cfg files OK ^-^"
	done
else
	oldIP=$1
	newIP=$2
	# Step 1 : update hosts file
	sed -i -r "s|$oldIP|$newIP|g" wj_proxy_hosts.txt
	echo "update hosts OK ^-^"
	# Step 2 : update haproxy.cfg files
	sed -i -r "s|$oldIP|$newIP|g" haproxy.cfg
	echo "update haproxy.cfg files OK ^-^"
fi


