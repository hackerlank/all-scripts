#!/bin/bash 
# 101.231.200.238:30005 -> 192.168.1.41:30005
# new for GC
# SG proxy-1-pxy1


proxyIP="54.251.121.152"
proxyName="SG-proxy-1-pxy1_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="30005"
remote_port="3400"

echo "Start Proxy ${proxyName}"

autossh  -M 40005 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} httpproxy@${proxyIP} -p38022
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
