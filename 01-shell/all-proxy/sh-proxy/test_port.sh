#!/bin/bash

if [ $# -ne 1 ];then
	echo "port 9003 checking"
	curl --socks5-hostname 192.168.1.41:9003 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 9004 checking"
	curl --socks5-hostname 192.168.1.41:9004 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
else
	echo "port $1 checking"
	curl --socks5-hostname 192.168.1.15:$1 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
fi
