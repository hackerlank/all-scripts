#!/bin/bash

. /root/.aws/aws_accesskey
source /etc/profile.d/aws-apitools-common.sh 
export PATH=$PATH:/opt/aws/bin

Time=`date +%Y%m%d -d "6 day ago"`

infos=(jjshouse-ami-cms jjshouse-ami-osticket)

for info in ${infos[@]}; do
	AMIIDs=`ec2-describe-images | grep "IMAGE" | grep $info | grep $Time | awk '{print $2}'`
	if [ -z $AMIIDs ];then
		echo "Now not images to be deleted !!!"
		exit 0
	fi
	# deregister image
	ec2-deregister $AMIIDs
	echo "Deregister $AMIIDs OK!!!"

	# delete snapshot of  image 
	ec2-describe-snapshots | grep $AMIIDs | awk '{print $2}' | xargs -I {} ec2-delete-snapshot {}
	echo "Delete snapshots of $AMIIDs OK!!!"
done 
