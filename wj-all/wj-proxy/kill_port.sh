#!/bin/bash

# eg: kill_port.sh 50002
if [ $# -ne 1 ];then
	echo "Usage: $0 port"
fi

ps -ef|grep -E "autossh|ssh" | grep $1 |grep -v grep |awk '{print $2}' |xargs -I {} kill -9 {}

if [ $? = 0 ];then
	echo "Port $1 Killed!!!"
fi
