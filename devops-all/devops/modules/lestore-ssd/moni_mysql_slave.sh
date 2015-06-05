#!/bin/bash
LANG=C
source $(dirname $0)/ssd_db.conf;

:<<INFO
report mysql slave status.
author: Zandy<yzhang@ouku.com>
created: 2009/04/17
version: $Id: moni_mysql_slave.sh 18500 2009-04-17 09:22:06Z yzhang $
INFO

running=$(ps aux|grep 2889a925cc30fae006c8da748e66ebd4|grep 'sh -c '|grep -v 'grep'|wc -l)
if [ "$running" -gt 1 ]; then
    echo "$(ps aux|grep 2889a925cc30fae006c8da748e66ebd4|grep 'sh -c '|grep -v 'grep')"
    echo "already running $0 ($running) $(date +'%Y-%m-%d %T')"
    exit 1
fi

############## config start ############
DB_HOST=${dbhost}
DB_PORT=${dbport}
DB_USER=${dbsuper}
DB_PASS=${dbsuperpass}
#REPORT_EMAIL='alarm@i9i8.com'
REPORT_EMAIL=${moni_slave_email}
REPORT_MOBILE=${moni_slave_mobile}
############## config   end ############

now=$(date +"%Y-%m-%d %H:%M:%S")
sss=$(/usr/bin/mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS -e "SHOW SLAVE STATUS\G")
#echo "$sss"

Slave_IO_Running=$(echo "$sss"|awk -F':' '/Slave_IO_Running/{print $2}'|sed 's/ //g')
#echo $Slave_IO_Running
Slave_SQL_Running=$(echo "$sss"|awk -F':' '/Slave_SQL_Running/{print $2}'|sed 's/ //g')
#echo $Slave_SQL_Running
Last_Errno=$(echo "$sss"|awk -F':' '/Last_Errno/{print $2}'|sed 's/ //g')
#echo $Last_Errno
Last_Error=$(echo "$sss"|awk -F':' '/Last_Error/{print $2}'|sed 's/ //g')
#echo $Last_Error
Seconds_Behind_Master=$(echo "$sss"|awk -F':' '/Seconds_Behind_Master/{print $2}'|sed 's/ //g')
#echo $Seconds_Behind_Master

Last_SQL_Errno=$(echo "$sss"|awk -F':' '/Last_SQL_Errno/{print $2}'|sed 's/ //g')
Last_SQL_Error=$(echo "$sss"|awk -F':' '/Last_SQL_Error/{print $2}'|sed 's/ //g')
Last_IO_Errno=$(echo "$sss"|awk -F':' '/Last_IO_Errno/{print $2}'|sed 's/ //g')
Last_IO_Error=$(echo "$sss"|awk -F':' '/Last_IO_Error/{print $2}'|sed 's/ //g')

msg=""
subject="[R_R]mysql slave report[$DB_HOST:$DB_PORT]"
message="$sss

"

if [ "$Slave_IO_Running" != 'Yes' ] || [ "$Slave_SQL_Running" != 'Yes' ]; then
	if [ "$Last_Errno" = "0" ]; then
		`/usr/bin/mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS -e "start slave io_thread;start slave sql_thread;"`
	else
		subject="[Sev-2][$DB_HOST:$DB_PORT]Slave is down![$now][$Last_Error]"
		msg+=$subject
	fi

	echo "$Seconds_Behind_Master"|grep -q -i 'null'
	if [ $? -eq 0 ]; then
                subject="[Sev-1][$DB_HOST:$DB_PORT]Slave is not running or can't connect to master![$now]"
		msg+=$subject
        elif [ $Seconds_Behind_Master -gt 600 ]; then
		subject="[Sev-3][$DB_HOST:$DB_PORT]Slave is behind master $Seconds_Behind_Master seconds![$now]"
		msg+=$subject
	fi

	if [ $Last_SQL_Errno -eq 1062 ]; then
		subject="[Sev-2][$DB_HOST:$DB_PORT]Slave error: Duplicate entry![$now]"
		/usr/bin/mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS -e "call mysql.rds_skip_repl_error;"
		msg+="\ndo 'call mysql.rds_skip_repl_error'"
		echo -e "$msg \nthis report from `hostname`\n\n$sss" | mutt -s "$subject" $REPORT_EMAIL
		exit 0
	fi
elif [ $Seconds_Behind_Master -gt 3600 ]; then
	subject="[Sev-2][$DB_HOST:$DB_PORT]Slave is behind master $Seconds_Behind_Master seconds![$now]"
	msg+=$subject
else
	echo
	subject="[R_R][$DB_HOST:$DB_PORT]Slave is ok![$now]"
	message+=$subject
fi

message+="$msg
this report from `hostname`
"

if [ "$msg" != "" ]; then
	echo "$message" | mutt -s "$subject" $REPORT_EMAIL
fi

echo "$message"

if [ $# -ne 0 ] && [ $1 = "-r" ]; then
	echo "$message" | mutt -s "$subject" $REPORT_EMAIL
	echo "The report mail has sent."
fi
