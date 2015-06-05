
#!/bin/bash

hz_backup_host=115.236.98.66
hz_backup_port=32200

hz_wikipass_host=115.236.98.67
hz_wikipass_port=873
extra_passwd=/etc/corpapp/.ht.corpapp.ext.passwd
rsync_pwd=/etc/rsync.pwd

sr_host=__SR_HOST__
sr_port=38022
sr_user=syncer

#S3CMD=/root/s3cmd-1.5.0-alpha1 #/root/s3cmd-1.1.0-beta1/s3cmd
S3CMD=s3cmd
S3CFG=/var/job/.s3cfg
S3TARGET=s3://__S3_IMG__/image/vb

hz_tunnel_host=115.236.98.66
hz_tunnel_port=32200
hz_tunnel_target=192.168.0.4
hz_tunnel_target_port=38080
hz_tunnel_user=syncer

DB_MASTER=__DB_HOST__
DB_NAME=vbridal
DB_USER_JOB=jjs0517job
DB_PASS_JOB=vbridalcommonpass
CDN="http://__CDN_IMG1__/image/vb"
IMG_REPO="/opt/data1/jjsimg/upimg"
