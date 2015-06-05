#!/bin/bash 
# 101.231.200.238:30003-> 192.168.1.41:30003
# azazie Paypal
# us-east-1 proxy-1-pxy1
# autossh -M 10003  -oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nnf -L 0.0.0.0:30005:127.0.0.1:3400 httpproxy@54.147.145.177  -p38022

proxyIP="54.147.145.177"
proxyName="us-east-proxy-1-pxy1_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="30003"
remote_port="3400"

echo "Start Proxy ${proxyName}"

autossh  -M 40003 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} httpproxy@${proxyIP} -p38022
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
