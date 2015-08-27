#!/bin/bash

proxyIP="54.169.100.247"
proxyName="SG-0-proxy_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="50000"
#remote_port="3400"
remote_port="3128"

echo "Start Proxy  ${proxyName}"

autossh  -M 60000 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p22 -i /tmp/SG-key.pem
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
