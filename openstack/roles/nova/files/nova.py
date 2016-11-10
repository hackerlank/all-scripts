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
    "nova": {
	"user": "root",
        "passwd": "",
        "port": 3306,
	"sql": "CREATE DATABASE IF Not Exists nova;\
         GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
         IDENTIFIED BY '"+getPwd('CONFIG_NOVA_DB_PW')+"' ;\
         GRANT ALL PRIVILEGES ON nova.* TO '`nova'@'%' \
         IDENTIFIED BY '"+getPwd('CONFIG_NOVA_DB_PW')+"'"
     }
}

COMMANDS = {
	  "nova":"openstack user create  --password "+getPwd('CONFIG_NOVA_KS_PW')+" NOVA 2>&1 \
           openstack role add --project service --user nova admin 2>&1;\
           openstack service create --name nova  --description 'OpenStack Compute' compute 2>&1;\
           openstack endpoint create \
  	         --publicuAl http://"+getPwd('os_control')+":8774/v2/%\(tenant_id\)s  \
  	         --internalurl http://"+getPwd('os_control')+":8774/v2/%\(tenant_id\)s \
  	         --adminurl http://"+getPwd('os_control')+":8774/v2/%\(tenant_id\)s  \
  	         --region "+getPwd('region')+"  compute 2>&1; \
           su -s /bin/sh -c 'nova-manage db_sync' nova 2>&1"
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
	#print m.strip()
