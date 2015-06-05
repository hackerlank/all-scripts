#!/bin/bash

if [ $# -ne 1 ];then
	echo "port 9003 checking"
	curl --socks5-hostname 192.168.1.15:9003 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 9004 checking"
	curl --socks5-hostname 192.168.1.15:9004 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 9005 checking"
	curl --socks5-hostname 192.168.1.15:9005 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 9006 checking"
	curl --socks5-hostname 192.168.1.15:9006 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 10005 checking"
	curl --socks5-hostname 192.168.1.15:10005 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
	echo "port 10006 checking"
	curl --socks5-hostname 192.168.1.15:10006 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
else
	echo "port $1 checking"
	curl --socks5-hostname 192.168.1.15:$1 "https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg" -o /dev/null
fi
