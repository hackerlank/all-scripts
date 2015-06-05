#!/bin/bash

region=__AWS_REGION__

backup_projects="vbridal:vb";
count_projects="vbridal:vb";

user=ec2-user
key=/home/ec2-user/.awstools/keys/prod_rsa
port=38022

# not used currently
#forward_hz_cmd1="autossh -M 32212 -f -i /home/ec2-user/.awstools/keys/forward_id_rsa -p 32200 -f -N -g -L 32210:127.0.0.1:32200 syncer@115.236.98.66"
#forward_hz_cmd2="autossh -M 32222 -f -i /home/ec2-user/.awstools/keys/forward_id_rsa -p 32200 -f -N -g -L 32220:127.0.0.1:873 syncer@115.236.98.67"

#forward_romeo_cmd="autossh -M 38890 -f -i /home/ec2-user/.awstools/keys/syncer_id_rsa -p 32200 -f -N -g -L 38888:192.168.0.4:38080 syncer@115.236.98.66"

#gender_gen
aws_keys=([0]='__AWS_DEPLOYER_ACCESS_KEY__');
aws_private_keys=([0]='__AWS_DEPLOYER_SECRET_KEY__');

