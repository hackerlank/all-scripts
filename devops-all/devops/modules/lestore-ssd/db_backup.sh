#!/bin/bash
source $(dirname $0)/ssd_db.conf;

if [ "$1" = 'js' ]; then
    db_host=${js_slave_host}
    db_user=
    db_pwd=
    db_db=${js_slave_db}
elif [ "$1" = 'je' ]; then
    db_host=${je_slave_host}
    db_user=
    db_pwd=
    db_db=${je_slave_db}
else
    echo "Usage: $0 <js|je>"
    exit
fi

mark=$(date +'%Y%m%d-%H%M%S')
target_dir=/opt/data1/dbbackup/
backup_tables="goods_display_order_batch gmail_info"
options="--skip-lock-tables --skip-add-locks --skip-add-drop-table -n -t --replace"

mysqldump -h $db_host -u $db_user -p"$db_pwd" $options --default-character-set=utf8 $db_db $backup_tables | gzip -c > $target_dir/$1.backup.$mark.sql.gz
