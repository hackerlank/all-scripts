#!/bin/bash
source $(dirname $0)/ssd_db.conf;

start_time="$1"
if [ -z "$start_time" ]; then
    start_time="$(date -d '-2hour' +'%Y-%m-%d %H:00:00')"
fi
stop_time="$2"
current_time=$(date -d '-10min' +'%Y-%m-%d %H:%M:%S')

echo JS - JE DB Sync from $start_time to $stop_time

js=" -h $js_slave_host -u $js_slave_user -p$js_slave_pwd --default-character-set=utf8 jjshouse"
jsw=" -h $js_slave_hostw -u $js_slave_user -p$js_slave_pwd --default-character-set=utf8 jjshouse"

je=" -h $je_slave_host -u $je_slave_user -p$je_slave_pwd --default-character-set=utf8 jenjenhouse"

BAK_PATH="/opt/data1/table_sync"
snapshot=js_table_sync-$(date +'%Y%m%d-%H%M%S').sql
options="--skip-lock-tables --skip-add-locks --skip-add-drop-table -n -t --replace"
where="last_update_time > '$start_time'"

if [ -n "$stop_time" ]; then
    where="$where AND last_update_time < '$stop_time'"
fi

tables=$(mysql $js -e "select table_name from sync_db_table" | sed -r 's,table_name,,')

mysqldump $options --where="$where" $js $tables | gzip -c > $BAK_PATH/$snapshot.gz

gunzip -c $BAK_PATH/$snapshot.gz > $BAK_PATH/$snapshot

mysql $je < $BAK_PATH/$snapshot


rm_tables='
feature
feature_config
';

cat <<SSS | awk 'NF' | sed -E 's,(.+),DELETE from \1 where _rm = 1;,' | mysql $je
$rm_tables
SSS

cat <<-SSS | awk 'NF' | sed -E "s,(.+),DELETE from \1 where _rm = 1 AND last_update_time < '$current_time';," | mysql $jsw
$rm_tables
SSS


rm -f $BAK_PATH/$snapshot
