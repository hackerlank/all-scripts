#!/bin/bash

BASEDIR=$(dirname $0)
cd ${BASEDIR}

port=$1
host_ip="192.168.1.41"

curl -s  -x ${host_ip}:${port} www.google.com -o /dev/null
if [ $? -ne 0 ]; then
	bash ${port}-proxy.sh
	if [ $? = 0 ];then
		echo "Start proxy prot $1 OK!!!"
	else
		bash ../kill_port.sh ${port} > /dev/null 2>&1
	fi
else
	echo " Proxy port $1 alive! ^_^"
fi


