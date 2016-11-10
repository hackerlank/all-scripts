#!/bin/bash
#
master_ip=$1
mkdir  -p /etc/mysql/conf.d/
service mysqld start
if [ -n "${master_ip}" ];then
    /usr/bin/mysql -e "slave stop"
    /usr/bin/mysqldump --opt --add-drop-database --all-databases --master-data=1 -h ${master_ip} -u dump -pbZQTbjpvuPFNex10y9Hfr |mysql
    /usr/bin/mysql -e "slave start"
else
    exit 2
fi
