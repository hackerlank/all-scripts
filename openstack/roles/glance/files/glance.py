#!/usr/bin/python
# -*- conding= utf-8 -*-

import MySQLdb
import yaml
import os
import commands

def getPwd(type):
	file = open('/root/openstack/openstack-ceph.yml')
	Passwd = yaml.load(file)
	return Passwd[0]['vars']['%s' % type]

def  keystone_admin():
        OS_TOKEN=getPwd('CONFIG_KEYSTONE_ADMIN_TOKEN')
        OS_URL="http://%s:3535//v2.0" %getPwd('os_control')
        return [OS_TOKEN,OS_URL ]



CONFIG = {
    "glance": {
	"user": "root",
        "passwd": "",
        "port": 3306,
	"sql": "CREATE DATABASE IF Not Exists glance;\
         GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
         IDENTIFIED BY '"+getPwd('CONFIG_GLANCE_DB_PW')+"' ;\
         GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
         IDENTIFIED BY '"+getPwd('CONFIG_GLANCE_DB_PW')+"'"
     }
}

COMMANDS = {
	  "glance":"openstack user create  --password "+getPwd('CONFIG_GLANCE_KS_PW')+" glance 2>&1 \
           openstack role add --project service --user glance admin 2>&1;\
           openstack endpoint create \
  	      --publicuAl http://"+getPwd('os_control')+":9292 \
  	      --internalurl http://"+getPwd('os_control')+":9292  \
  	      --adminurl http://"+getPwd('os_control')+":9292 \
  	      --region "+getPwd('region')+"  image 2>&1; \
           su -s /bin/sh -c 'glance-manage db_sync' glance 2>&1"
}


for i in CONFIG:
    db = MySQLdb.connect(host='',user=CONFIG[i]["user"],passwd=CONFIG[i]['passwd'],port=CONFIG[i]['port'])
    cursor=db.cursor()
    commit=db.commit()
    close=db.close
    for j in CONFIG[i]["sql"].split(';'):
       cursor.execute(j)
    print j
#    commit
#    close
for k in COMMANDS:
    auth =commands.getoutput('cat /etc/profile|grep OS_TOKEN ')
    if auth.strip()=='':
    	os_info =keystone_admin()
    	os.environ['OS_URL']=os_info[1]
    	os.environ['OS_TOKEN']=os_info[0]
   	os.system("echo export OS_URL=$OS_URL >>/etc/profile")
    	os.system("echo export OS_TOKEN=$OS_TOKEN >>/etc/profile")
    	os.system("source /etc/profile")
    for m in COMMANDS[k].split(';'):
#	exec(m)
	print m
#	os.system("m")
#	print m.strip()
