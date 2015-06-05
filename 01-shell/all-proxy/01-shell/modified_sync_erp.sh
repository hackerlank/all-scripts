#!/bin/bash

# modifid cms test env 
cron_file="/var/spool/cron/www-data"

line=`grep  -rn 'syncer/syncMore/diffday/30'  ${cron_file} |awk -F":" '{print $1}'`
sed -i ''${line}'s:*/5:*/1:g' ${cron_file}
