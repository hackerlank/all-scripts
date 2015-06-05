#!/bin/bash


now=$(date +%Y%m%d%T)
if [[ -z $name ]]
then
    name=${0#*deploy}
fi

to_dir=/var/www/http
#to_dir=/home/lyu

cd /tmp
if [ -f "deploy$name" ];then
	echo $now $name
	cat /tmp/deploy$name
	rm -rf /tmp/deploy$name

	/usr/bin/rsync -vzrtopg --progress  --delete --exclude "data/master_config.php" --exclude="templates_c" /tmp/$name $to_dir 

	if [ -f "/tmp/success$name" ];then
                chmod 666 /tmp/success$name
        else
                touch /tmp/success$name
                chmod 666 /tmp/success$name
        fi

        echo "OK" >/tmp/success$name
fi
chown -R www-data.www-data $to_dir/$name
