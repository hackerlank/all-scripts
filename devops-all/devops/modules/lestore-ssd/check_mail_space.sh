#!/bin/bash
source $(dirname $0)/ssd_db.conf;

alarm_mail="${check_mail_space_email}"

cd $(dirname $0)

for line in `cat mail_pswd.conf`
do
	cmd=`echo $line|awk -F":" '{print $1}'`
	mail_user=`echo $line|awk -F":" '{print $2}'`
	mail_paswd=`echo $line|awk -F":" '{print $3}'`
	/usr/bin/python $cmd $mail_user $mail_paswd $alarm_mail
done
