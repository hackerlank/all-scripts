#!/bin/bash
prices_host="192.168.0.3"
prices_port="33306"
prices_user=""
prices_pwd=""
prices_db=""

aws_host="192.168.0.2"
aws_port="12001"
aws_user="syncer"
aws_key="/root/.ssh/id_rsa"

mail_list="bcheng@i9i8.com hwang@i9i8.com"

#hzc0n20
sql_dir="/opt/db_sync/"
if [ ! -d "$sql_dir" ]; then mkdir -p ${sql_dir}; fi
dbdir=/opt/data1/dbdata
log="/var/log/import_prices.log"

mysql_import="mysql --default-character-set=utf8 -h ${prices_host} -P${prices_port} -u${prices_user} -p${prices_pwd}"

#enter workspace sql_dir
cd ${sql_dir}

start_time="$(date +"%y-%m-%d %H:%M:%S")"
echo $start_time "start import prices"
echo "###########################################"
scp -P${aws_port} -i${aws_key} -o UserKnownHostsFile=/dev/null  -o StrictHostKeyChecking=no -o ConnectTimeout=30 ${aws_user}@${aws_host}:${dbdir}/prices.sql.tar.gz .
if [ $? -ne 0 ];then
        echo "$(date +"%y-%m-%d %H:%M:%S") prices.sql.tar.gz download error" | mail -s "prices sql download error" ${mail_list}
        exit 1
fi
tar xzf prices.sql.tar.gz
if [ "$(cat prices.sql.checksum)" != "$(md5sum prices.sql|awk '{print $1}')" ]; then
        echo "$(date +"%y-%m-%d %H:%M:%S") prices.sql md5 check error!" | tee -a $log | mail -s "prices.sql md5 check failed" ${mail_list}
else
        ${mysql_import} ${prices_db} < prices.sql
        if [ $? -eq 0 ]
        then
                echo "$(date +"%y-%m-%d %H:%M:%S") mysqlimport database prices OK" | tee -a $log
        else
                        exit 1
        fi
fi
echo "###########################################"
end_time="$(date +"%y-%m-%d %H:%M:%S")"
echo $end_time "end import prices"
