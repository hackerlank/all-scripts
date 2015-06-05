#!/bin/bash

yestoday=$(date +%Y%m%d --date='1 days ago')
monitor_logs_dir="/opt/data1/monitor_logs_backup"
if [ ! -d $monitor_logs_dir ]
then
	mkdir -p $monitor_logs_dir
fi
cd $monitor_logs_dir
tar zcf xhprof_${yestoday}.tar.gz /opt/data1/xhprof
rm -rf /opt/data1/xhprof/*
find $monitor_logs_dir/*.tar.gz -mtime +15 2>/dev/null | xargs -I {} rm -f {}