#!/bin/bash

if [ $# -ne 1 ];then
	echo "port 50002 checking"
	#curl --socks5-hostname 192.168.24.191:50002 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	curl -x 192.168.24.191:50002 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 9003 checking"
	curl --socks5-hostname 192.168.24.191:9003 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 9004 checking"
	curl --socks5-hostname 192.168.24.191:9004 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
else
	echo "port $1 checking"
	curl --socks5-hostname 192.168.24.191:$1 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
fi
