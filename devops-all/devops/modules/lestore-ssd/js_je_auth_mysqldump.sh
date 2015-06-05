#! /bin/bash
source $(dirname $0)/ssd_db.conf;

timenow=$(date +'%Y-%m-%d %T')
dbdir=/opt/data1/dbdata

if [ ! -d $dbdir ]
then
	mkdir -p $dbdir
fi

cd $dbdir
rm js_db_auth*  je_db_auth* -f

js_host="192.168.1.50"
js_port="3306"
js_user="dbuser0114"
js_pwd="dbpswd0114"
js_db="jjshouse"
js_table="sys_access_pca sys_account sys_account_permission sys_permission sys_role sys_user_role ost_staff ost_department ost_groups"


je_host="192.168.1.50"
je_port="3306"
je_user="dbuser0114"
je_pwd="dbpswd0114"
je_db="jenjenhouse"
je_table="sys_access_pca sys_account sys_account_permission sys_permission sys_role sys_user_role ost_staff ost_department ost_groups"

mysqldump_js="/usr/local/mysql/bin/mysqldump -h ${js_host} -P${js_port} -u ${js_user} -p${js_pwd}"
mysqldump_je="/usr/local/mysql/bin/mysqldump -h ${je_host} -P${je_port} -u ${je_user} -p${je_pwd}"
options="--skip-lock-tables --skip-add-locks --add-drop-table --default-character-set=utf8"

#mysqldump js
echo $(date +"%y-%m-%d %H:%M:%S") "start mysqldump database js"
$mysqldump_js $options $js_db $js_table > js_db_auth.sql

if [ $? -eq 0 ]
then
        echo $(date +"%y-%m-%d %H:%M:%S") "mysqldump database js OK"
else
	echo "jjshouse mysqldump db failed at $timenow." | mail -s "jjshouse mysqldump db failed at $timenow." ${auth_mysqldump_email}
fi

echo $(md5sum js_db_auth.sql|awk '{print $1}') > js_db_auth.checksum
tar zcf js_db_auth.sql.tar.gz js_db_auth.sql js_db_auth.checksum


#mysqldump je
echo $(date +"%y-%m-%d %H:%M:%S") "start mysqldump database je"
$mysqldump_je $options $je_db $je_table > je_db_auth.sql

if [ $? -eq 0 ]
then
        echo $(date +"%y-%m-%d %H:%M:%S") "mysqldump database je OK"
else
	echo "jenjenhouse mysqldump db failed at $timenow." | mail -s "jenjenhouse mysqldump db failed at $timenow." ${auth_mysqldump_email}
fi

echo $(md5sum je_db_auth.sql|awk '{print $1}') > je_db_auth.checksum
tar zcf je_db_auth.sql.tar.gz je_db_auth.sql je_db_auth.checksum

#scp -P22 -o UserKnownHostsFile=/dev/null  -o StrictHostKeyChecking=no -o ConnectTimeout=30 js_db_auth.sql.tar.gz je_db_auth.sql.tar.gz jhshi@192.168.1.50:./
#if [ $? -eq 0 ]
#then
#        echo $(date +"%y-%m-%d %H:%M:%S") "scp database aws to hz OK"
#else
#        echo "scp database aws to hz at $timenow." | mail -s "scp database aws to hz at $timenow." jhshi@i9i8.com
#fi
