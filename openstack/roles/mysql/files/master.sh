#!/bin/bash
#

mkdir  -p /etc/mysql/conf.d/
service mysqld start
/usr/bin/mysql -e "grant replication slave on *.* to replica@'%' identified by 'bZQTbjpvuPFNex10y9Hfr'"
/usr/bin/mysql -e "grant all  on *.* to dump@'%' identified by 'bZQTbjpvuPFNex10y9Hfr'"
