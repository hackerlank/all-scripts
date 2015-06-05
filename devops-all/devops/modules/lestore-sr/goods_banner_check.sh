#!/bin/bash

source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/sr_thumb.conf
mysql_ro="mysql --skip-column-names --default-character-set=utf8 -h$dbhost_ro -u$dbuser -p$dbpass $dbname"
mysql="mysql --skip-column-names --default-character-set=utf8 -h$dbhost -u$dbuser -p$dbpass $dbname"

goods_gallery_not_found=$(cat <<SQL_END | $mysql_ro
SELECT goods_id
	from goods_thumb
	where has_done = -1
SQL_END)

if [ -n "$goods_gallery_not_found" ]; then
	full="goods galleries that not fetched: <br> $goods_gallery_not_found"
	/var/job/alert.sh 'debug' 'Sev-2' 'Goods Gallery Not Found' $full
fi
