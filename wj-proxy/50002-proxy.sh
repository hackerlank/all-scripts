#!/bin/bash

#proxyIP="54.169.155.70"
proxyIP="54.169.100.247"
proxyName="SG-proxy-2-SG2_${proxyIP}"
ssh_ops="-oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

local_port="50002"
#remote_port="6082"
remote_port="3128"

echo "Start Proxy  ${proxyName}"

#autossh  -M 60002 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p22 -i /root/.ssh/test_rsa
autossh  -M 60002 ${ssh_ops} -Nnf -L 0.0.0.0:${local_port}:127.0.0.1:${remote_port} ec2-user@${proxyIP} -p22 -i /home/ec2-user/.ssh/id_rsa
if [ $? = 0 ];then
	echo "Start port ${local_port} to ${proxyName}:${remote_port} OK ^-^"
fi
