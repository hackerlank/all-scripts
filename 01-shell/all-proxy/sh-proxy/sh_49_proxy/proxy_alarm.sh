#!/bin/bash

name="ShangHai-1.49"
#检测haproxy的后台服务组
backend_servers=(
        "proxy_backend"
        "proxy_backend_google"
)
#down掉的机器大于info%记录日志
info=0.1
#down掉的机器大于warning%发邮件（Serv2）
warning=0.4
#存活机器少于error台发邮件（Sev-1）
error=10
#需要被检测是否可用的代理机器和端口
host_ip="127.0.0.1"
ports=(
	"9003"
	"9004"
)
#haproxy socket位置
haproxy_socket="/tmp/haproxy"
#报警收件人邮箱
#mailTo="xhfan@i9i8.com,cmwu@i9i8.com,lyu@i9i8.com"
mailTo="xhfan@i9i8.com,jytian@i9i8.com,lyu@i9i8.com"
#日志目录
log="/var/log/proxy_alarm.log"
#日期格式
date=$(date '+%Y-%m-%d %H:%M:%S')

if [ ! -f log ] ; then
	touch $log
fi
#检查端口是否可以
for port in ${ports[@]} ; do
echo $prot	
	total=3
	while [ $total -ge 1 ] ; do
		total=`expr $total - 1`
		r=$(date +%s)
		sleep_time=$(echo "$r%15" | bc)
 		curl --socks5-hostname $host_ip:$port www.google.com -o /dev/null
		if [ $? -eq 0 ] ; then
			break
		fi
		sleep $sleep_time
	done
	if [ $total -le 0 ] ; then
		title="Sev-1: $name proxyport $port down"
                content="代理端口$port在$date时已经不能连接,请尽快修复"
		echo "$date $port down" >> $log
                `echo $content | mail -s "$title" $mailTo`
                continue	
	fi
done

#检查haproxy后端服务组
for backend_server in ${backend_servers[@]}; do
	backend=`echo "$backend_server,"`
	isExist=$(echo "show stat" | socat stdio $haproxy_socket | grep $backend | wc -l)
	#后端服务组不存在
	if [ $isExist -eq 0 ] ;then
		continue
	fi
	allServer=$(echo "$isExist-1" | bc)
	isDisabled=$(echo "show stat" | socat stdio $haproxy_socket  | grep $backend | grep "MAINT" | wc -l)
	disabled_Percent=$(echo "scale=2;$isDisabled/$allServer" | bc)
	isEnabled=$(echo "$allServer-$isDisabled" | bc)
	if [ $isEnabled -lt $error ]; then
		title="Sev-1: $name proxy amount less than $error"
		content="后端服务组$backend_server 共$allServer机器，在$date时down掉$isDisabled台,代理后台可用机器小于$error台,请尽快解决"	
		`echo $content | mail -s "$title" $mailTo`
		continue
	fi
	if [ $(echo "$disabled_Percent>$info"|bc) -eq 1 ] && [ $(echo "$disabled_Percent<$warning"|bc) -eq 1  ]; then
		echo "$date all: $allServer disabled: $isDisabled  enabled: $isEnabled" >> $log
	fi
	if [ $(echo "$disabled_Percent>$warning" | bc) -eq 1  ]; then
		per=$(echo "(1 - $warning) * 100" | bc)
		title="Sev-2: $name enableld proxy less than $per%"
        	content="服务组$backend_server, 共$allServer机器，在$date时down掉$isDisabled台,代理后台可用机器小于$per %,请检查网络"
		echo "$date all: $allServer disabled: $isDisabled  enabled: $isEnabled" >> $log
		`echo $content | mail -s "$title" $mailTo`
        	continue
	fi
done
