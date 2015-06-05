#!/bin/bash

backup_projects="azazie:zz";
count_projects="azazie:zz";
#backup_projects="jjshouse:js jenjenhouse:je amormoda2:am dressfirst:df vbridal:vb jennyjoseph:ph mjjshouse:mjs mjenjenhouse:mje";
#count_projects="jjshouse:js";

user=ec2-user
key=/home/ec2-user/.awstools/keys/prod_rsa
port=38022

#gender_gen
aws_keys=([0]='');
aws_private_keys=([0]='');
region=us-east-1

# not used currently
#forward_hz_cmd1="autossh -M 32212 -f -i /home/ec2-user/.awstools/keys/forward_id_rsa -p 32200 -f -N -g -L 32210:127.0.0.1:32200 syncer@115.236.98.66"
#forward_hz_cmd2="autossh -M 32222 -f -i /home/ec2-user/.awstools/keys/forward_id_rsa -p 32200 -f -N -g -L 32220:127.0.0.1:873 syncer@115.236.98.67"

#forward_romeo_cmd="autossh -M 38890 -f -i /home/ec2-user/.awstools/keys/syncer_id_rsa -p 32200 -f -N -g -L 38888:192.168.0.4:38080 syncer@115.236.98.66"
