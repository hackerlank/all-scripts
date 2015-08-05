#!/bin/bash
# $1 = old-IP
# $2 = new-IP
# chang-proxy-IP.sh $1 $2 
# Step 1 : update wj_proxy_hosts.txt file
# Step 2 : update haproxy.cfg files
cd $(dirname $0) && pwd
oldIPs=(
	"52.74.236.200"
	"52.74.236.201"
	"52.74.236.202"
	"52.74.236.203"
)
newIPs=(
	"52.74.236.200"
	"52.76.11.171"
	"52.74.98.63"
	"52.76.15.252"
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
		# Step 3 : update ssh_to_SG_proxy.sh files
		sed -i -r "s|$oldIP|$newIP|g" ssh_to_SG_proxy.sh
		echo "update ssh_to_SG_proxy.sh files OK ^-^"
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
	# Step 3 : update ssh_to_SG_proxy.sh files
	sed -i -r "s|$oldIP|$newIP|g" ssh_to_SG_proxy.sh
	echo "update ssh_to_SG_proxy.sh files OK ^-^"
fi


