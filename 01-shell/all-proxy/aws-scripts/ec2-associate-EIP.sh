#!/bin/bash 
# start ec2 instace
#. /root/.aws/aws_access_secret_key
# export AWS_ACCESS_KEY=
# export AWS_SECRET_KEY=

REGION="us-east-1"
cmd_ec2_associate_address="ec2-associate-address"
cmd_ec2_describe_instance_status="ec2-describe-instance-status"
# ec2 instances id
IDS="i-a12cc54d"
EIP="xxx.xxx.xxx.xxx"

status=`${cmd_ec2_describe_instance_status} --region ${REGION} $IDS|grep $IDS|awk '{print $6}'`
echo $status
if [ $status = "ok" ];then
	${cmd_ec2_associate_address} --region $REGION $EIP -i $IDS
else
	echo "Please wait, ec2 instance is running..."
fi
