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

	/usr/bin/rsync -vzrtopg --progress  --delete --exclude "templates/voicedir" --exclude "templates/shipment_print" --exclude "apache2-default" --exclude "templates/caches" --exclude "templates/compiled"    --exclude "templates/compiled/admin/caches" --exclude "admin/filelock" --exclude "admin/testmail" --exclude "program" --exclude "ecshoptest" --exclude "phpmyadmin" --exclude "shop/data/master_config.php" --exclude "shop/data/slave_config.php" --exclude "bbs/config.inc.php" --exclude "data/master_config.php" --exclude "data/slave_config.php" --exclude "shop/RpcApi/ApiConfig.php"  --exclude "http" --exclude "http-back" --exclude "protected/runtime" --exclude "templates/mysql_tool" --exclude "templates/purchase_return"  --exclude "templates/sample_upload" --exclude "templates/temp_eub" /tmp/$name  $to_dir
	
	if [ -f "/tmp/success$name" ];then
                chmod 666 /tmp/success$name
        else
                touch /tmp/success$name
                chmod 666 /tmp/success$name
        fi

	echo "OK" >/tmp/success$name
fi

chown -R www-data.www-data $to_dir/jjshouse_erp
rm -rf $to_dir/jjshouse_erp/templates/caches/*
rm -rf $to_dir/jjshouse_erp/templates/compiled/admin/ztec/*
rm -rf $to_dir/jjshouse_erp/templates/compiled/admin/*.php
#chown -R www-data.www-data /var/www/http/jjshouse_erp
#rm -rf /var/www/http/jjshouse_erp/templates/caches/*
#rm -rf /var/www/http/jjshouse_erp/templates/compiled/admin/ztec/*
#rm -rf /var/www/http/jjshouse_erp/templates/compiled/admin/*.php
