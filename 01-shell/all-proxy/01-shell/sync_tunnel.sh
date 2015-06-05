#!/bin/bash

curl -s -o /dev/null http://127.0.0.1:38080/jjshouse_romeo/JjshouseService?wsdl
if [ $? -ne 0 ]; then
	echo "restart sync tunnel!"
	ps -elf | grep -E 'autossh|ssh' | grep '38080' | grep -v 'grep' | awk '{print $4}' | xargs -I {} kill -9 {}
	autossh -M20090 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nnf -L 127.0.0.1:38080:127.0.0.1:8080 httpproxy@101.231.200.238 -p38022
else
	echo "sync tunnel is ok!"
fi
