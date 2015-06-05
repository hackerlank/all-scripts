#!/bin/bash -x

source $(dirname $0)/ssd_db.conf

BAK_PATH="/opt/data1/db_history"
#BAK_PATH="."

function dump(){
host=$1
host_w=$2
user=$3
pass=$4
db=$5
time=$6

mysql="mysql --skip-column-names --default-character-set=utf8 -u ${user} -p${pass} ${db}"
tables="goods_display_order_batch"
if [ "all" != "$time" ]; then
    batch=$(cat <<-SQL_END |
    select batch from goods_display_order_batch where batch like '${time}%' limit 1
SQL_END
        $mysql -h ${host})
        where="batch='$batch'"
        mysqldump="mysqldump -h $host -u $user -p$pass --skip-lock-tables --skip-add-locks --skip-add-drop-table \
            -n -t --default-character-set=utf8 --where=${where} $db $tables"
    else
        batch=$(date +%Y-%m-%d)-all
        mysqldump="mysqldump -h $host -u $user -p$pass --skip-lock-tables --skip-add-locks --skip-add-drop-table \
            -n -t --default-character-set=utf8 $db $tables"
    fi

    if [ -n "$batch" ]; then
        $mysqldump | gzip -c > $BAK_PATH/${db}.db_backup.${batch}.sql.gz
        rs=$?
        if [ $rs -eq 0 ]; then
            echo 'Success'
            if [ "all" != "$time" ]; then
                cat <<-SQL_END |
                delete from goods_display_order_batch where ${where}
SQL_END
                $mysql -h ${host_w}
            else
                cat <<-SQL_END |
                delete from goods_display_order_batch
SQL_END
                $mysql -h ${host_w}
            fi
        else
            echo 'Dump Failed'
        fi
    fi
}

d=$1
if [ -z "$d" ]; then
    #d=$(date --date '-7days' +%Y%m%d)
    d=all
fi

dump $dbhost $dbhostw $dbuser $dbpass $dbname $d
