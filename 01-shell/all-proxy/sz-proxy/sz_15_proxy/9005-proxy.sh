#!/bin/bash
autossh -NfL *:9005:192.168.1.41:9003  -i /root/.ssh/sh_41 -p32201 httpproxy@101.231.200.238
if [ $? == 0 ]; then
	echo "Start Proxy port 9005 OK!!!"
fi 
