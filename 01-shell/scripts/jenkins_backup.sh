#!/bin/bash

date_time=`date +%Y%m%d`

src_dir="/opt/tomcat-jenkins/webapps"
des_dir="/opt/backup_jenkins"

jenkins_logs="/opt/tomcat-jenkins/logs"

cd $src_dir
tar -zcf ${des_dir}/jenkins_${date_time}.tar.gz ./jenkins

find ${des_dir}/*.tar.gz -mtime +5 2>/dev/null | xargs -I {} rm -rf {}

find ${jenkins_logs}/*.log -mtime +5 2>/dev/null | xargs -I {} rm -rf {}
find ${jenkins_logs}/*.txt -mtime +5 2>/dev/null | xargs -I {} rm -rf {}
