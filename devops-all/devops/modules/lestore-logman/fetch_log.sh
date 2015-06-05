#!/bin/bash

$(dirname $0)/gender_gen.sh
source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/logman_config.sh

user=ec2-user
port=38022


function sync_log(){
    log_root=/opt/data1/access_log
    host=$1;
    if [ ! -d "$log_root/$host"  ]; then
        mkdir -p "$log_root/$host";
    fi

    echo Sync for $host start at $(date +%F-%H:%M:%S)...
    #rsync -az --timeout=10 --progress --include='access*log' --include='*.tar.gz' --exclude='*' -e 'ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -p38022' $user@$host:/opt/data1/nginxlogs/ /opt/data1/access_log/$host/
    rsync -az --timeout=10 --progress --include='*.tar.gz' --exclude='*' -e "ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -p$port" $user@$host:/opt/data1/nginxlogs/ $log_root/$host/

    echo Sync log for $host done at $(date +%F-%H:%M:%S)
}

function sync_monitor(){
    log_root=/opt/data1/monitor_log
    host=$1;
    if [ ! -d "$log_root/$host"  ]; then
        mkdir -p "$log_root/$host";
    fi

    echo Sync for $host start at $(date +%F-%H:%M:%S)...
    rsync -az --timeout=10 --progress --include='check_uptime.*.log' --exclude='*' -e "ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -p$port" $user@$host:/var/log/monitor/ $log_root/$host/

    mark_1=`date +%Y%m%d --date='1 days ago'`
    mark_2=`date +%Y%m%d --date='2 days ago'`
	if [ -f $log_root/$host/check_uptime.${mark_2}.log ] && [ -f $log_root/$host/check_uptime.${mark_1}.log ] ; then
        cat $log_root/$host/check_uptime.${mark_2}.log | awk -F":" '/^ 09/,/^ 24/ {print $0}' >> $log_root/$host/${mark_1}.log
        cat $log_root/$host/check_uptime.${mark_1}.log | awk -F":" '/^ 00/,/^ 09/ {print $0}' >> $log_root/$host/${mark_1}.log
        echo "OK"
	fi

    echo Sync load for $host done at $(date +%F-%H:%M:%S)
}

echo $1;
case $1 in
        s)
                sync_log $2
                ;;
        a)
                while read vm; do
                        sync_log $vm
                done < <(cat /etc/hosts | grep '#devops' | grep -v 'search' | awk '{print $2}')
                ;;
        m)
                while read vm; do
                        sync_log $vm
                done < <(cat /etc/hosts | grep '#devops' | grep -v 'search' | awk '{print $2}')
                /var/job/merge_log.sh
                #/var/job/clean_log.sh
                ;;
        l)
                while read vm; do
                        sync_monitor $vm
                done < <(cat /etc/hosts | grep '#devops' | grep -v 'search' | awk '{print $2}')
                /var/job/analyze_load.sh
                ;;

esac
