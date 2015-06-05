#!/bin/bash 
# HK for XuMeng

proxyIP="123.1.160.243"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="19998"
remote_port="3400"

echo "Start HK-proxy_${proxyIP} "

autossh  -M 10101 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} httpproxy@${proxyIP} -p22 -i /root/.ssh/hk_xm_rsa
if [ $? = 0 ];then
	echo "Start monitor port ${local_port} to HK-proxy_${proxyIP}:${remote_port} OK ^-^"
fi
