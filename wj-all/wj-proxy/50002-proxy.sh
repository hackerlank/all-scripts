#!/bin/bash

proxyIP="52.76.6.27"
proxyName="SG-0-proxy_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="50002"
remote_port="3128"

echo "Start Proxy  ${proxyName}"

autossh  -M 60002 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p58022 -i /root/.ssh/sg_proxy.pem
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
