#!/bin/bash
source $(dirname $0)/ssd_db.conf;

start_time="$1"
end_time="$2"
if [ -z "$start_time" ]; then
    start_time="$(date -d '-2hour' +'%Y-%m-%d %H:00:00')"
fi

if [ -z "$end_time" ]; then
    end_time="$(date +'%Y-%m-%d %H:00:00')"
fi

echo JS - JE DB Sync from $start_time to $end_time

BAK_PATH="/opt/data1/table_sync"
snapshot=js_table_sync-$(date +'%Y%m%d-%H%M%S').sql
options="--skip-lock-tables --skip-add-locks --skip-add-drop-table -n -t --replace"
where="last_update_time >= '$start_time' AND last_update_time < '$end_time'"

tables=$(mysql -h $js_slave_host -u $js_slave_user -p"$js_slave_pwd" --default-character-set=utf8 jjshouse -e "select table_name from sync_db_table" | sed -r 's,table_name,,')

(for t in tables; do echo "DELETE from $t WHERE $where;"; done;
mysqldump -h $js_slave_host -u $js_slave_user -p"$js_slave_pwd" $options --where="$where" --default-character-set=utf8 jjshouse $tables )| gzip -c > $BAK_PATH/$snapshot.gz

gunzip -c $BAK_PATH/$snapshot.gz > $BAK_PATH/$snapshot

mysql -h $je_slave_host -u $je_slave_user -p"$je_slave_pwd" --default-character-set=utf8 jenjenhouse < $BAK_PATH/$snapshot

rm -f $BAK_PATH/$snapshot
