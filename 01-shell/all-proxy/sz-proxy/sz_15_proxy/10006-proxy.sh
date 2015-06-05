#!/bin/bash
autossh -NfL *:10006:192.168.0.139:9004  -i /root/.ssh/hz_139 -p32200 httpproxy@115.236.98.69
#autossh -NfL *:10006:192.168.1.41:9004  -i /root/.ssh/sh_41 -p32201 httpproxy@101.231.200.238
if [ $? == 0 ]; then
	echo "Start Proxy port 10006 OK!!!"
fi
