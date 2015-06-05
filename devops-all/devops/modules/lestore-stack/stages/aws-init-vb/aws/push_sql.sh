#!/bin/bash
# This script should be run in dir(/home/ec2-user) on the deployer machine.
# Push azazie.sql.tar.gz and grant.sql from the deployer machine to SSD
# Login ssd
# Unpack the azazie.sql.tar.gz 
# Import azazie.sql and grant.sql to DB
# 
#echo "This script should be run in dir(/home/ec2-user) on the deployer machine."
echo -e "\033[01;31m"
echo "==> 注意:此脚本需以 ec2-user 用户在 deployer 的 /home/ec2-user 目录下执行。<=="
echo -e "\033[0m"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
# import __DB_HOST__
. /home/ec2-user/config_repo/config.conf
. $SCRIPT_DIR/ssh-agent.sh
ssd_domain=`grep "ssd" /etc/hosts |awk '{print $2}'`
scp -P38022 $SCRIPT_DIR/azazie.sql.tar.gz $ssd_domain:/home/ec2-user
scp -P38022 $SCRIPT_DIR/grant.sql $ssd_domain:/home/ec2-user

# input DB_DOMAIN address
#read -p "Please input db_domain, must be Ture: " DB_DOMAIN
#ssh -p38022 -t $ssd_domain "sudo bash -c \"cd /tmp;tar -zxvf azazie.sql.tar.gz >/dev/null;touch $DB_DOMAIN;\""
# __DB_HOST__ in /home/ec2-user/config_repo/config.conf file.
ssh -p38022 -t $ssd_domain "bash -c \"cd /home/ec2-user;tar -zxvf azazie.sql.tar.gz >/dev/null;mysql -h${__DB_HOST__} -P3306 -uzydbroot -p < azazie.sql;mysql -h${__DB_HOST__} -P3306 -uzydbroot -pzydbpswd < grant.sql;\""
