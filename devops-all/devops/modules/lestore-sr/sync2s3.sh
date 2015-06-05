#! /bin/bash
source $(dirname $0)/sr_rsync.conf

running=$(ps aux|grep 73c294e0b4b83fc458dbc2e96c66e1ea|grep 'sh -c '|grep -v 'grep'|wc -l)
if [ "$running" -gt 1 ]; then
    echo "$(ps aux|grep 73c294e0b4b83fc458dbc2e96c66e1ea|grep 'sh -c '|grep -v 'grep')"
    echo "already running $0 ($running) $(date +'%Y-%m-%d %T')"
    exit 1
fi

s3cmd -c /var/job/img.s3cfg -F --acl-public --add-header="Cache-Control: public, max-age=86400" -r put /mnt/data1/jjsimg/upimg/ ${sync2s3_s3}
