#!/bin/bash

# return mysql salve meta data to zabbix server.
# 2014-07-16

source $(dirname $0)/ssd_dbconfig.conf

# dbhostlist=(
# dbuser:dbpass@jjshousedb.cmyicoxavsy8.us-east-1.rds.amazonaws.com:3306
# dbuser:dbpass@jenjenhouse.cwxcj1w8quad.us-east-1.rds.amazonaws.com:3306
# )

if [ "$1" == "list_db_host" ]; then
	length=${#dbhostlist[@]}
	printf "{\n"
	printf  '\t'"\"data\":["
	for ((i=0;i<$length;i++))
	do
	    printf '\n\t\t{'
	    printf "\"{#DB_HOST_NAME}\":\"$(echo ${dbhostlist[$i]} | awk -F'@' '{print $2}' | cut -d'.' -f 1)\"}"
	    if [ $i -lt $[$length-1] ];then
	            printf ','
	    fi
	done
	printf  "\n\t]\n"
	printf "}\n"
	exit 0

elif [ -z "$2" ]; then
	echo "usage: $0 host_name [Com_begin|Bytes_received|Bytes_sent|Com_commit|Com_delete|Com_insert|Questions|Com_rollback|Com_select|Slow_queries|Com_update|Uptime|Connections|alive|version]"
	exit 1
fi

for host in ${dbhostlist[@]}; do
	if [ -n "$(echo $host|grep $1 )" ]; then
		DB_HOST=$(echo $host|awk -F'@' '{print $2}'|cut -d':' -f 1)
		DB_PORT=$(echo $host|awk -F'@' '{print $2}'|cut -d':' -f 2)
		DB_USER=$(echo $host|awk -F'@' '{print $1}'|cut -d':' -f 1)
		DB_PASS=$(echo $host|awk -F'@' '{print $1}'|cut -d':' -f 2)
	fi
done

if [ -z "$DB_HOST" ]; then
	echo "Can not find host $1"
	exit 1
fi

mysql_query="/usr/bin/mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS -N"

case $2 in
	Com_begin|Bytes_received|Bytes_sent|Com_commit|Com_delete|Com_insert|Questions|Com_rollback|Com_select|Slow_queries|Com_update|Uptime|Connections )
		echo "show global status where Variable_name='$2';"|$mysql_query|awk '{print $2}'
		;;
	alive|ping )
		is_live=$(/usr/bin/mysqladmin -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS ping|grep -c alive)
		if [ "$is_live" -gt 0 ]; then
			echo "Yes"
		else
			echo "No"
		fi
		;;
	version )
		#/usr/bin/mysql -V
		version=$(/usr/bin/mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS -N -e "status;"|grep "Server version"|awk -F':' '{print $2}')
		echo $version
		;;
	* )
		echo "usage: $0 host_name [Com_begin|Bytes_received|Bytes_sent|Com_commit|Com_delete|Com_insert|Questions|Com_rollback|Com_select|Slow_queries|Com_update|Uptime|Connections|alive|version]"
	;;
esac
