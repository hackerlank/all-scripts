#!/bin/bash

# return mysql salve meta data to zabbix server.
# 2014-07-16

source $(dirname $0)/ssd_slave.conf

# dbslavelist=(
# dbuser:dbpass@jjshousedbslave.cmyicoxavsy8.us-east-1.rds.amazonaws.com:3306
# dbuser:dbpass@jsdbslave2.cmyicoxavsy8.us-east-1.rds.amazonaws.com:3306
# dbuser:dbpass@jenjenhouseslave.cwxcj1w8quad.us-east-1.rds.amazonaws.com:3306
# )

if [ -z "$1" ]; then
	echo "help: $0 slave_name [slave_io_running|slave_sql_running|last_errno|last_error|seconds_behind_master]"
	exit 1
fi

for slave in ${dbslavelist[@]}; do
	if [ -n "$(echo $slave | grep $1 )" ]; then
		DB_HOST=$(echo $slave | awk -F'@' '{print $2}' | cut -d':' -f 1)
		DB_PORT=$(echo $slave | awk -F'@' '{print $2}' | cut -d':' -f 2) 
		DB_USER=$(echo $slave | awk -F'@' '{print $1}' | cut -d':' -f 1)
		DB_PASS=$(echo $slave | awk -F'@' '{print $1}' | cut -d':' -f 2)
	fi
done

if [ -z "$DB_HOST" ]; then
	echo "Can not find slave $1"
	exit 1
fi

slave_info=$(/usr/bin/mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS -e "SHOW SLAVE STATUS\G")
if [ -n "$2" ]; then
	query=$(echo $2 | tr '[A-Z]' '[a-z]')
fi

case $query in
	slave_io_running )
		io_r=$(echo "$slave_info"|awk -F':' '/Slave_IO_Running:/{print $2}'|sed 's/ //g')
		if [ "$io_r" == "Yes" ]; then
			echo "Yes"
		else
			echo "No"
		fi
		;;
	slave_sql_running )
		sql_r=$(echo "$slave_info"|awk -F':' '/Slave_SQL_Running:/{print $2}'|sed 's/ //g')
		if [ "$sql_r" == "Yes" ]; then
			echo "Yes"
		else
			echo "No"
		fi
		;;
	last_errno )
		errno_r=$(echo "$slave_info"|awk -F':' '/Last_Errno:/{print $2}'|sed 's/ //g')
		echo "$errno_r"
		;;
	last_error )
		error_r=$(echo "$slave_info"|awk -F':' '/Last_Error:/{print $2}'|sed 's/ //g')
		if [ -z "$error_r" ]; then
			echo "-1"
		else
			echo "$error_r"
		fi
		;;
	seconds_behind_master )
		seconds_r=$(echo "$slave_info"|awk -F':' '/Seconds_Behind_Master:/{print $2}'|sed 's/ //g')
		echo "$seconds_r"
		;;
	alive|ping )
		is_live=$(/usr/bin/mysqladmin -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS ping | grep -c alive)
		if [ "$is_live" -gt 0 ]; then
			echo "Yes"
		else
			echo "No"
		fi
		;;
	* )
		echo "help: $0 slave_name [slave_io_running|slave_sql_running|last_errno|last_error|seconds_behind_master|alive]"
	;;
esac
