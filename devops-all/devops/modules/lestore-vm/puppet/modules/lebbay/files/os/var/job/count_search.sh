#!/bin/bash

export LANG=en_US.UTF-8

if [[ -f $(dirname $0)/host_name.conf ]]
then
        source $(dirname $0)/host_name.conf
else
        host_name=$(hostname)
fi

log_date=`date +%Y%m%d --date='1 days ago'`

cat /opt/data1/nginxlogs/access-$log_date-je-prod-www.log|grep -Ev "ajax.php|favicon.ico|version|Googlebot|bingbot" |awk '{print $7" "$(NF-2)}' |grep '/search.php?q='|uniq |awk '{print $1}' |sed 's/^.*\?q=//g'|sed 's/&.*$//g'|sed 's/+/ /g'|tr  A-Z  a-z|perl -MURI::Escape -ne 'print uri_unescape($_);' > /var/log/monitor/${host_name}_search_${log_date}.txt
