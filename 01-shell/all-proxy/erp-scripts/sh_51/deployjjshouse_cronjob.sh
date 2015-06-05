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

        /usr/bin/rsync -vzrtopg --progress --delete --exclude "apache2-default" --exclude "templates/caches" --exclude "templates/compiled" --exclude "admin/includes/init.php" --exclude "admin/config.vars.php" --exclude "admin/function.php" --exclude "data/master_config.php" --exclude "data/slave_config.php"  /tmp/$name $to_dir

        if [ -f "/tmp/success$name" ];then
                chmod 666 /tmp/success$name
        else
                touch /tmp/success$name
                chmod 666 /tmp/success$name
        fi
        echo "OK" >/tmp/success$name
fi
