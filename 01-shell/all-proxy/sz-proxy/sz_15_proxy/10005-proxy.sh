#!/bin/bash
autossh -NfL *:10005:192.168.0.139:9003  -i /root/.ssh/hz_139 -p32200 httpproxy@115.236.98.69
#autossh -NfL *:10005:192.168.1.41:9003  -i /root/.ssh/sh_41 -p32201 httpproxy@101.231.200.238
if [ $? == 0 ]; then
	echo "Start Proxy port 10005 OK!!!"
fi 
