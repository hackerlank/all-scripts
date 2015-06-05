#!/bin/bash
source $(dirname $0)/ssd_db.conf;

mysql="mysql --skip-column-names --default-character-set=utf8 -h ${dbhost} -P${dbport} -u ${dbuser} -p${dbpass} ${dbname}"

locktables="--lock-tables=false"
tables="
category
category_languages
"

target_dir=/opt/data1/dbdata
target='testdb.sql'
cd $target_dir

mysqldump $locktables --skip-add-drop-table --no-create-info --replace -h$dbhost -u$dbuser -p$dbpass $dbname $tables >> $target

echo $(md5sum $target|awk '{print $1}') > ${target}_checksum
tar zcf ${target}.tar.gz $target ${target}_checksum
