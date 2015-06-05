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

   	/usr/bin/rsync -vzrtopg --progress  --delete --exclude "var" --exclude "htm/userfiles" --exclude "etc/config.supplierpowers.php" --exclude "etc/config.site.php" --exclude "etc/config.db.php" /tmp/$name  $to_dir

	if [ -f "/tmp/success$name" ];then
                chmod 666 /tmp/success$name
        else
                touch /tmp/success$name
                chmod 666 /tmp/success$name
        fi

        echo "OK" >/tmp/success$name

fi

# clear templcate cache
chown -R www-data.www-data $to_dir/mps
rm -rf $to_dir/mps/var/tpl/ztec/*
#chown -R www-data.www-data /var/www/http/mps
#rm -rf /var/www/http/mps/var/tpl/ztec/*
