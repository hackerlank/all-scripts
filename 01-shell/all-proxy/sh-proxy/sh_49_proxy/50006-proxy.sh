#!/bin/bash

proxyIP="54.65.130.253"
proxyName="Tokyo-proxy-2-TYO1_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="50006"
remote_port="3400"

echo "Start Proxy ${proxyName}"

autossh  -M 60006 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p38022 -i /root/.ssh/test_rsa
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
