#! /bin/bash
source $(dirname $0)/ssd_db.conf;

DB_HOST=${dbhost}
DB_USER=${dbuser}
DB_PASS=${dbpass}
BAK_PATH="/opt/data1/dbdata/"
BAK_NAME="${dbname}_lite.sql"
dataname="${BAK_PATH}${BAK_NAME}"

test -d $BAK_PATH || mkdir -p $BAK_PATH

locktables="--lock-tables=false"
echo -e "CREATE DATABASE IF NOT EXISTS ${dbshortname}temp CHARSET UTF8;\n" > ${dataname}
tables=order_info
echo -e "use ${dbshortname}temp;\n" >> ${dataname}
mysqldump -h${DB_HOST} -u${DB_USER} -p${DB_PASS} $locktables ${dbname} $tables --where="order_time > date_sub(now(), interval 20 day)" >> ${dataname}
sleep 10
echo "mysqldump end at $(date +%Y%m%d%H%M%S)"

cd ${BAK_PATH}

# tar zcf ${BAK_NAME}_tmp.tgz ${BAK_NAME}
/usr/local/bin/rar a ${BAK_NAME}_tmp.rar ${BAK_NAME}
/var/job/encode.sh ${BAK_NAME}_tmp.rar ${BAK_NAME}_tmp.encode.rar
rm -rf ${BAK_NAME}.tgz ${BAK_NAME}.rar ${BAK_NAME}_tmp.rar

# mv ${BAK_NAME}_tmp.tgz ${BAK_NAME}.tgz
mv ${BAK_NAME}_tmp.encode.rar ${BAK_NAME}.rar
rm -rf ${dataname}
