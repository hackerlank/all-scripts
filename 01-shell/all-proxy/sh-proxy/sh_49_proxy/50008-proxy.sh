#!/bin/bash

proxyIP="54.65.83.89"
proxyName="Tokyo-proxy-1-TYO3_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="50008"
remote_port="3400"

echo "Start ${proxyName}"

autossh  -M 60008 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p38022 -i /root/.ssh/test_rsa
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
