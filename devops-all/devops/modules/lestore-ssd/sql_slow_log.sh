#! /bin/bash
source $(dirname $0)/ssd_db.conf;

DB_HOST=${dbhost}
DB_USER=${dbuser}
DB_PASS=${dbpass}

mysqldump --lock-tables=false -h${DB_HOST} -u${DB_USER} -p${DB_PASS} mysql slow_log > /var/log/slow_log.$(date +'%Y%m%d%H%M%S').sql
mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASS} -e "call mysql.rds_rotate_slow_log"
