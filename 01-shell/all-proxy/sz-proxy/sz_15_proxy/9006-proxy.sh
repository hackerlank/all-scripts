#!/bin/bash
autossh -NfL *:9006:192.168.1.41:9004  -i /root/.ssh/sh_41 -p32201 httpproxy@101.231.200.238
if [ $? == 0 ]; then
	echo "Start Proxy port 9006 OK!!!"
fi
