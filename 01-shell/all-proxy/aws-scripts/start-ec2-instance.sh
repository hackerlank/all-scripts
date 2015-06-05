#!/bin/bash

# start ec2 instace
#. /root/.aws/aws_access_secret_key
# export AWS_ACCESS_KEY=
# export AWS_SECRET_KEY=

REGION="us-east-1"
cmd_ec2_start_instances="ec2-start-instances"
# ec2 instances id
IDS="i-a12cc54d"
# start jjshoue cms ec2 instacnes
${cmd_ec2_start_instances}  --region $REGION $IDS

