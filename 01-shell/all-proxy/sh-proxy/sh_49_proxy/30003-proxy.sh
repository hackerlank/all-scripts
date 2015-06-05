#!/bin/bash

proxyIP="52.74.28.15"
proxyName="SG-proxy-3-SG4_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="30003"
remote_port="3128"

echo "Start Proxy  ${proxyName}"

autossh  -M 40003 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p38022 -i /root/.ssh/test_rsa
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
