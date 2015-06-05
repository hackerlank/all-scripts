#!/bin/bash
source $(dirname $0)/ssd_db.conf;

export LANG=C

if [[ -f $(dirname $0)/host_name.conf ]]
then
        source $(dirname $0)/host_name.conf
else
        host_name=$(hostname)
fi

#db_host="127.0.0.1"
#db_user="root"
#db_pswd="root"
#db_port="3306"
db_host="${dbhost}"
db_user="${dbuser}"
db_pswd="${dbpass}"
db_port="3306"

sev1_conn_num=250
sev2_conn_num=150

mysql -u${db_user} -p${db_pswd} -h${db_host} -P$db_port -e "show processlist;" > /dev/null

if [ $? -eq 1 ]
then
	printf %b "Level: Sev2 \nDB Host:$db_host \nInfo:can not connect to db. \nHost: $host_name \nDate: $(date +'%Y-%m-%d %T') " |mail -s "[Sev2] DOWN Alert: $db_host can not connect to db." jhshi@i9i8.com hwang@i9i8.com
else
	mysql_connect_num=`mysql -u${db_user} -p${db_pswd} -h${db_host} -P$db_port -e "show processlist;" |wc -l`
	if [ $mysql_connect_num -gt $sev1_conn_num  ]
	then
		printf %b "Level: Sev1 \nDB Host:$db_host \nMysql Connect Number: $mysql_connect_num  \nHost: $host_name \nDate: $(date +'%Y-%m-%d %T') " |mail -s "[Sev1] AWS Alert: $db_host mysql connect number is critical" jhshi@i9i8.com hwang@i9i8.com
	elif [ $mysql_connect_num -gt $sev2_conn_num ]
	then
		printf %b "Level: Sev2 \nDB Host:$db_host \nMysql Connect Number: $mysql_connect_num  \nHost: $host_name \nDate: $(date +'%Y-%m-%d %T') " |mail -s "[Sev2] AWS Alert: $db_host mysql connect number is critical" jhshi@i9i8.com hwang@i9i8.com
	fi
fi
