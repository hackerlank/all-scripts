#!/usr/bin/python
## -*- conding= utf-8 -*-

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
    "keystone": {
	"user": "root",
        "passwd": "",
	"host": "+getPwd('os_mysql')+",
        "port": 3306,
	"sql": "CREATE DATABASE IF Not Exists keystone;\
         GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
         IDENTIFIED BY '"+getPwd('CONFIG_KEYSTONE_DB_PW')+"' ;\
         GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
         IDENTIFIED BY '"+getPwd('CONFIG_KEYSTONE_DB_PW')+"'"
     }
}

COMMANDS = {
	  "nova":"su -s /bin/sh -c 'keystone-manage db_sync' keystone \
	   openstack service create  \
	  --name keystone --description 'OpenStack Identity' identity 2>&1; \
	  openstack endpoint create \
  	  --publicuAl http://"+getPwd('os_control')+":5000/v2.0 \
  	  --internalurl http://"+getPwd('os_control')+":5000/v2.0 \
  	  --adminurl http://"+getPwd('os_control')+":35357/v2.0 \
  	  --region "+getPwd('region')+"  identity 2>&1; \
	  openstack project create --description 'Admin Project' admin 2>&1; \
	  openstack user create --name=admin --pass="+getPwd('CONFIG_KEYSTONE_ADMIN_TOKEN')+" 2>&1 \
	  openstack role create admin 2>&11;\
	  openstack role add --project admin --user admin admin 2>&11;\
	  openstack project create --description 'Service Project' service 2>&1"
}


for i in CONFIG:
    host_os=getPwd('os_mysql')
#    db = MySQLdb.connect(host=host_os,user=CONFIG[i]["user"],passwd=CONFIG[i]['passwd'],port=CONFIG[i]['port'])
    db = MySQLdb.connect(host='',user=CONFIG[i]["user"],passwd=CONFIG[i]['passwd'],port=CONFIG[i]['port'])
    cursor=db.cursor()
    commit=db.commit()
    close=db.close
    for j in CONFIG[i]["sql"].split(';'):
       cursor.execute(j)
    print j
#print db
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
	#print m.strip()
