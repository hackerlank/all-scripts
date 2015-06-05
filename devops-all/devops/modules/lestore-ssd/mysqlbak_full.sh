#! /bin/bash
source $(dirname $0)/ssd_db.conf;

#source /var/job/db.config.sh
DB_HOST=${dbhost}
DB_USER=${dbuser}
DB_PASS=${dbpass}
BAK_PATH="/opt/data1/dbdata/"
BAK_NAME="${dbname}_full_$(date +%Y%m%d%H%M).sql"
dataname="${BAK_PATH}${BAK_NAME}"

locktables="--lock-tables=false"
#locktables="--skip-lock-tables"
if [ $(date +%H%M) = "0200" ]; then
	locktables=""
fi

echo "mysqldump start at $(date +%Y%m%d%H%M%S)"
echo -e "CREATE DATABASE IF NOT EXISTS ${dbname} CHARSET UTF8;\n" > ${dataname}

tables=$(mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASS} -e "show tables from ${dbname}"|awk '!/Tables_in_/ && !/^product_tags_test$/ && !/^goods_languages$/  && !/^goods_languages$/ && !/^shopping_cart$/ && !/^goods_display_order_batch$/ && !/^goods_thumb$/ && !/^goods_history$/ && !/^ops_log$/ && !/^gmail_info$/ && !/^newsletter_send_email/')

echo -e "use ${dbname};\n" >> ${dataname}
mysqldump -h${DB_HOST} -u${DB_USER} -p${DB_PASS} $locktables ${dbname} $tables >> ${dataname}
sleep 10
for _db in $(mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASS} -e "show databases where \`Database\` in ('jjsblog','faucetland');"); do
    echo -e "CREATE DATABASE IF NOT EXISTS $_db CHARSET UTF8;\n" >> ${dataname}
    mysqldump -h${DB_HOST} -u${DB_USER} -p${DB_PASS} $locktables --databases $_db >> ${dataname}
    sleep 10
done
echo "mysqldump end at $(date +%Y%m%d%H%M%S)"

cd ${BAK_PATH}

echo $(md5sum ${BAK_NAME}|awk '{print $1}') > ${BAK_NAME}_checksum
tar zcf ${BAK_NAME}.tar.gz ${BAK_NAME} ${BAK_NAME}_checksum

if [ "$1" == "gz" ]; then
	echo $dataname
	exit 0
elif [ "$1" == "s3" ]; then
	s3cmd=s3cmd
	$s3cmd -c /var/job/ssd.s3cfg put ${BAK_NAME}.tar.gz ${back_s3} --bucket-location=US
	#clearup S3, keep fo 7 days
	$s3cmd -c /var/job/ssd.s3cfg ls ${back_s3} -p -r|sort -k1,2 -r|awk 'BEGIN{i=0}{i++;if(i>672){print $4}}'|xargs -I{} $s3cmd -c /var/job/ssd.s3cfg del {}
fi

rm -f $dataname ${BAK_NAME}_checksum

cd ${BAK_PATH}
find ${BAK_PATH} -maxdepth 1 -type f -mtime +0 | xargs -I {} rm -f {};

echo ${BAK_NAME}.tar.gz > ${dbshortname}_mysqlbak_full_ok
echo "mysqlbak end at $(date +%Y%m%d%H%M%S)"
