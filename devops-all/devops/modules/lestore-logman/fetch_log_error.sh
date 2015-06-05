#!/bin/bash -x

export SSH_AUTH_SOCK;
export SSH_AGENT_PID;
echo Agent pid ${SSH_AGENT_PID};

log_root=/opt/data1/error_log/

function sync_log(){
    host=$1;
    if [ ! -d "$log_root/$host"  ]; then
        mkdir -p "$log_root/$host/app";
        mkdir -p "$log_root/$host/php";
        mkdir -p "$log_root/$host/nginx";
    fi

    echo Sync for $host start at $(date +%F-%H:%M:%S)...
    d=$(date +%Y%m%d)
    ssh_cmd='ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -p38022'
    app_folder=$($ssh_cmd $user@$host 'ls -d /opt/data1/*_cache')
    rsync -a --timeout=10 --progress --include="shopping.${d}*.log" --include="sql.${d}*.log" --include="eshop_exception_handler.${d}*.log" --include="eshop_error_handler_rsf.${d}*.log" --exclude='*' -e "$ssh_cmd"  $user@$host:$app_folder/compiled/ /opt/data1/error_log/$host/app
    rsync -a --timeout=10 --progress --include='www-error.log*' --include='error.log*' --include='www-slow.log*' --exclude='*' -e "$ssh_cmd" $user@$host:/var/log/php-fpm/ /opt/data1/error_log/$host/php
    rsync -a --timeout=10 --progress --include='error*.log' --exclude='*' -e "$ssh_cmd" $user@$host:/opt/data1/nginxlogs/ /opt/data1/error_log/$host/nginx/

    echo Sync for $host done at $(date +%F-%H:%M:%S)
}

echo $1;
case $1 in
	s)
		sync_log $2
		;;
	a)
        vms=$(cat /etc/hosts | grep '#devops' | grep -v 'search' | awk '{print $2}')
		for vm in $vms; do
            sync_log $vm
		done
		;;
	*)
		if [ -n "$1" ]; then
			sync_log $1
		fi
		;;
esac
