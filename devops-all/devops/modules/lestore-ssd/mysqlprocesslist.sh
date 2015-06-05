#! /bin/bash
source $(dirname $0)/ssd_db.conf;

DB_HOST=${dbhost}
DB_USER=${dbuser}
DB_PASS=${dbpass}

echo "log time $(date +'%Y-%m-%d %T')"
mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASS} -e "show full processlist"
