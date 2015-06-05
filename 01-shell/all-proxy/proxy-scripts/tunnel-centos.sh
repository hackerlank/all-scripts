#!/bin/bash

AUTOSSH="autossh -oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

source $(dirname $0)/hosts-centos

host_len=${#hosts[@]}
log_len=$(echo 5*${host_len}|bc)
#URL="https://ssl.gstatic.com/ui/v1/icons/mail/themes/phantasea/bg_morning_1680x1050.jpg"
URL="http://www.jjshouse.com/themes/fashion/images/css_sprite_2.png?${RANDOM}"
CURL="curl -s -k --connect-timeout 10 -m 30 -w %{time_total} -o /dev/null"
DAY=$(date +%Y%m%d)
logdir=/var/log/proxy
log=${logdir}/speed.${DAY}.log
haproxy_sock=/tmp/haproxy
backend_server="proxy_backend"
backend_test_server="proxy_backend_google"

test -d $logdir || mkdir -p $logdir
## kill all autossh sessions
if [ "$1" == "killall" ]; then
        for l in ${hosts[@]}; do
                host_ip=`echo $l | awk -F ':' '{print $3}'`
                host_port=`echo $l | awk -F ':' '{print $4}'`
                host_user=`echo $l | awk -F ':' '{print $2}'`
                proxy_port=`echo $l | awk -F ':' '{print $5}'`
                pid=$(ps -elf | grep -E "autossh|ssh"| grep "$host_ip" | grep -E "${proxy_port}" | grep -v "grep" | awk '{print $4}'| xargs)
                if [ -n "$pid" ]; then
                        kill $pid
                fi
        done
        exit 0
fi

## kill specified autossh session with ip address
if [ "$1" == "kill" ]; then
	if [ -z "$2" ]; then
		echo  "Need an ip to kill"
		exit 1
	fi
	flag=0
        for l in ${hosts[@]}; do
                host_ip=`echo $l | awk -F ':' '{print $3}'`
                host_port=`echo $l | awk -F ':' '{print $4}'`
                host_user=`echo $l | awk -F ':' '{print $2}'`
                proxy_port=`echo $l | awk -F ':' '{print $5}'`
		if [ "$2" == "${host_ip}" ]; then
                	pid=$(ps -elf | grep -E "autossh|ssh"| grep "$host_ip" | grep -E "${proxy_port}" | grep -v "grep" | awk '{print $4}'| xargs)
                	if [ -n "$pid" ]; then
				echo "kill ${host_ip}:${proxy_port}"
                        	kill $pid
				flag=1
                	fi
		fi
        done
	if [ $flag -eq 0 ]; then
		echo "${host_ip} not found"
		exit 1
	fi
        exit 0
fi

for l in ${hosts[@]}; do
	prefix=`echo $l | awk -F ':' '{print $1}'`
	host_ip=`echo $l | awk -F ':' '{print $3}'`
	host_port=`echo $l | awk -F ':' '{print $4}'`
	host_user=`echo $l | awk -F ':' '{print $2}'`
	proxy_port=`echo $l | awk -F ':' '{print $5}'`
	monitor_port=`echo $l | awk -F ':' '{print $6}'`
	#echo $host_ip:${proxy_port}
	#${AUTOSSH} -Nnf -D ${proxy_port} ${host_user}@${host_ip} -p${host_port}
	pid=$(ps -elf | grep -E "autossh|ssh"| grep "$host_ip" | grep "${proxy_port}" | grep -v "grep" | awk '{print $4}'| xargs)
	if [ -z "$pid" ]; then
		echo "disable server ${backend_server}/${prefix}_${host_ip}" | socat stdio ${haproxy_sock} >/dev/null 2>&1
		echo "disable server ${backend_test_server}/${prefix}_${host_ip}" | socat stdio ${haproxy_sock} >/dev/null 2>&1
		${AUTOSSH} -M ${monitor_port} -Nnf -D ${proxy_port} ${host_user}@${host_ip} -p${host_port}
		sleep 5
	fi
	time=$(${CURL} --socks5-hostname 127.0.0.1:${proxy_port} -L ${URL})
	r=$?
	printf "%-45s%10s\n" ${prefix}_${host_ip} ${time} >> ${log}
	average_time=$(tail -${log_len} ${log} | grep ${host_ip} | grep -v "0.000" | awk 'BEGIN{total=0;i=0;}{total=total+$2;i++}END{if(i!=0){print total/i;}else{print total;}}')
	printf "%-45s%10s%10s\n" ${prefix}_${host_ip} ${time} ${average_time}
	#echo $average_time
	if [ $(echo $average_time | awk '{if($1>5){print 1;}else{print 0}}') -eq 1 ] || [ $r -ne 0 ]; then
		echo "disable server ${backend_server}/${prefix}_${host_ip}" | socat stdio ${haproxy_sock} >/dev/null 2>&1
		echo "disable server ${backend_test_server}/${prefix}_${host_ip}" | socat stdio ${haproxy_sock} >/dev/null 2>&1
	else
		echo "enable server ${backend_server}/${prefix}_${host_ip}" | socat stdio ${haproxy_sock} >/dev/null 2>&1
		echo "enable server ${backend_test_server}/${prefix}_${host_ip}" | socat stdio ${haproxy_sock} >/dev/null 2>&1
	fi
done
printf "\nShow proxy status\n"
proxy_servers=$(echo "show stat" | socat stdio ${haproxy_sock} | grep "${backend_server}")
for l in ${hosts[@]}; do
	prefix=`echo $l | awk -F ':' '{print $1}'`
	host_ip=`echo $l | awk -F ':' '{print $3}'`
	status=$(echo $proxy_servers | tr ' ' '\n' | grep ${host_ip} | grep "MAINT")
	if [ -n "${status}" ]; then
		show_status="down"	
	else
		show_status="up"	
	fi
	printf "%-45s%10s%10s%5s\n" ${prefix}_${host_ip} ${show_status}
done
