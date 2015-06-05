#!/bin/bash

# stop ec2 instace
#. /root/.aws/aws_access_secret_key
# export AWS_ACCESS_KEY=
# export AWS_SECRET_KEY=

REGION="us-east-1"
cmd_ec2_stop_instances="ec2-stop-instances"
# ec2 instances id
IDS="i-a12cc54d"
# stop jjshoue cms ec2 instacnes
${cmd_ec2_stop_instances}  --region $REGION $IDS

