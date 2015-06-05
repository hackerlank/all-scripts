#!/bin/bash

target=$1
source $(dirname $0)/ssd_db.conf;

timenow=$(date +'%Y-%m-%d %T')
dbdir=/opt/data1/dbdata

if [ ! -d $dbdir ]
then
	mkdir -p $dbdir
fi

cd $dbdir
rm *_db_auth* -f

tables="sys_access_pca sys_account sys_account_permission sys_permission sys_role sys_user_role ost_staff ost_department ost_groups"

mysqldump_cmd="mysqldump -h${dbhost} -P${dbport} -u ${dbuser} -p${dbpass}"
options="--skip-lock-tables --skip-add-locks --add-drop-table --default-character-set=utf8"

#mysqldump
echo $(date +"%y-%m-%d %H:%M:%S") "start mysqldump database $target"
$mysqldump_cmd $options $dbname $tables > ${target}_db_auth.sql

if [ $? -eq 0 ]
then
        echo $(date +"%y-%m-%d %H:%M:%S") "mysqldump database $target OK"
else
	echo "$target mysqldump db failed at $timenow." | mail -s "$target mysqldump db failed at $timenow." ${auth_mysqldump_email}
fi

echo $(md5sum ${target}_db_auth.sql|awk '{print $1}') > ${target}_db_auth.checksum
tar zcf ${target}_db_auth.sql.tar.gz ${target}_db_auth.sql ${target}_db_auth.checksum
