#!/bin/bash 
# 101.231.200.238:30001->30001 for AA DF paypal
# paypal(aadfpaypal)
# new IP : 54.251.97.146

proxyIP="54.251.97.146"
proxyName="Singapore-proxy-1-pxy2_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="30001"
remote_port="3400"

echo "Start Proxy ${proxyName}"

autossh  -M 40001 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} httpproxy@${proxyIP} -p38022
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
