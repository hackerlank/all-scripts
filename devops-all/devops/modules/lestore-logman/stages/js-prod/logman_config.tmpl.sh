#!/bin/bash

backup_projects="jjshouse:js jenjenhouse:je amormoda2:am dressfirst:df vbridal:vb jennyjoseph:ph mjjshouse:mjs mjenjenhouse:mje";
count_projects="jjshouse:js";

user=ec2-user
key=/home/ec2-user/.awstools/keys/prod_rsa
port=38022

#gender_gen
aws_keys=([0]='');
aws_private_keys=([0]='');
region=us-east-1
