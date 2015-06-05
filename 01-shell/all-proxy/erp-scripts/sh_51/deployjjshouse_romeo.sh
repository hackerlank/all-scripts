#!/bin/bash


now=$(date +%Y%m%d%T)
if [[ -z $name ]]
then
    name=${0#*deploy}
fi

to_dir=/var/lib/tomcat6/webapps/$name
#to_dir=/home/lyu/$name

cd /tmp
if [ -f "deploy$name" ];then
	echo $now $name
	cat /tmp/deploy$name
	rm -rf /tmp/deploy$name

	/usr/bin/rsync -vzrtopg --progress --delete --exclude "WEB-INF/datasource.xml" --exclude "WEB-INF/log4j.properties"  /tmp/romeoWeb/ $to_dir

	chown -R tomcat6.tomcat6 /var/lib/tomcat6/webapps/$name
	/etc/init.d/tomcat6 restart
	
	if [ -f "/tmp/success$name" ];then
		chmod 666 /tmp/success$name
	else 
		touch /tmp/success$name
		chmod 666 /tmp/success$name
	fi
	echo "OK" > /tmp/success$name
fi
