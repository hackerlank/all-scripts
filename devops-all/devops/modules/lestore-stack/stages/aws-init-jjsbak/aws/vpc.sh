#! /bin/bash
:<<EOF
error usage: bash vpc.sh
right usage: bash /fullpath/vpc.sh
EOF

set -u -x

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# aws config
. ${__DIR__}/aws_credential

mkdir -p ${__DIR__}/keys

# owner
#owner=770498700961
owner=974727782203
# for vpc
#vpc_tag_name=testvpc
vpc_tag_name=defaultvpc
#region=eu-west-1
CIDR=172.31.0.0/16
# for iam
#script_path=file:// + fullpath
script_path="file://${__DIR__}/"
username1=jjshouse_vm_cms
username1_policy_name1=jjs-up-cf
username1_policy_name2=jjs-up-ec2
username1_policy_name3=jjs-up-rds
username1_policy_name4=jjs-up-s3
username2=jjshouse_vm_normal
username2_policy_name1=jjshouse_vm-send-email
# for security group
sg_lestore_production=lestore-production
sg_lestore_devops_deployer=lestore-devops-deployer
sg_lestore_devops_monitor=lestore-devops-monitor
sg_jjscachesg=jjscachesg
sg_jjsdbsg=jjsdbsg
sg_jjselbsg=jjselbsg
# for elastic load balance
elb_pre=js-pre
elb_prod=js-prod
elb_availability_zones=${region}b
# for sns
sns_topic_name=jjsalarm
sns_email=yzhang@i9i8.com
# for ec
cache_session_id=zysession
cache_session_num_nodes=1
cache_session_node_type=cache.m1.small
cache_v5_id=zy-v5
cache_v5_num_nodes=2
cache_v5_node_type=cache.m1.large
# for rds
# rds parameter group
dbmysqlpg=jjsdbpg
# rds parameter
db_instance_identifier=zydb
dbuser=zydbroot
dbpswd=zydbpswd
#dbname=azazie
dbname=jjshouse
db_instance_class=db.m1.large
rds_stack_name=lestore-stage-rds-0
# for deployer stack
deployer_stack_name=lestore-stage-deployer-0
# for s3
bucket_name_img=zyimg
bucket_name_dbbak=zydbbak
# for cloudfront
cloudfront_stack_name=lestore-stage-cloudfront-0


# create vpc
vpcs=$(aws ec2 describe-vpcs --region=$region --output text)
is_exists=$(echo "$vpcs"|awk '{if ($1=="VPCS" && $5=="True" && $6=="available"){print $0}}'|wc -l)
if [ $is_exists -ge 1 ]; then
	#vpc=$(aws ec2 create-vpc --region=$region --output text --cidr-block $CIDR)
	vpc_id=$(echo $vpc|awk '{print $7}')
	vpc_tag_rst=$(aws ec2 create-tags --region=$region --output text --resources $vpc_id --tags Key=Name,Value=$vpc_tag_name)
	if [ "$vpc_tag_rst" != "true" ]; then
		echo "create vpc tag failed. vpc id is $vpc_id"
		exit 1
	fi
	aws ec2 describe-vpcs --region=$region --output text
else
	tag_line=$(echo "$vpcs"|awk '{if ($1=="TAGS" && $2=="Name" && $3=="'"$vpc_tag_name"'"){print NR}}')
	if [ "$tag_line" != "" ]; then
		vpc_line=$(( $tag_line - 1 ))
		vpc_id=$(echo "$vpcs"|awk '{if (NR == "'"$vpc_line"'"){print $7}}')
	fi
fi

if [ "$vpc_id" == "" ]; then
	echo "vpc id not found."
	exit 1
fi

# create iam
## for cms->s3
aws iam get-user --user-name $username1
if [ $? -ne 0 ]; then
	aws iam create-user --user-name $username1
	if [ $? -ne 0 ]; then
		echo "execute 'aws iam create-user --user-name $username1' failed. "
		exit 1
	fi
fi
aws iam get-user-policy --user-name $username1 --policy-name $username1_policy_name1
if [ $? -ne 0 ]; then aws iam put-user-policy --user-name $username1 --policy-name $username1_policy_name1 --policy-document $script_path$username1_policy_name1.json ; fi
aws iam get-user-policy --user-name $username1 --policy-name $username1_policy_name2
if [ $? -ne 0 ]; then aws iam put-user-policy --user-name $username1 --policy-name $username1_policy_name2 --policy-document $script_path$username1_policy_name2.json ; fi
aws iam get-user-policy --user-name $username1 --policy-name $username1_policy_name3
if [ $? -ne 0 ]; then aws iam put-user-policy --user-name $username1 --policy-name $username1_policy_name3 --policy-document $script_path$username1_policy_name3.json ; fi
aws iam get-user-policy --user-name $username1 --policy-name $username1_policy_name4
if [ $? -ne 0 ]; then aws iam put-user-policy --user-name $username1 --policy-name $username1_policy_name4 --policy-document $script_path$username1_policy_name4.json ; fi

## for ses
aws iam get-user --user-name $username2
if [ $? -ne 0 ]; then
	aws iam create-user --user-name $username2
	if [ $? -ne 0 ]; then
		echo "execute 'aws iam create-user --user-name $username2' failed. "
		exit 1
	fi
fi
aws iam get-user-policy --user-name $username2 --policy-name $username2_policy_name1
if [ $? -ne 0 ]; then aws iam put-user-policy --user-name $username2 --policy-name $username2_policy_name1 --policy-document $script_path$username2_policy_name1.json ; fi

# create security groups (ec2, rds, lb, ecc)
sg_lestore_production_id=$(aws ec2 create-security-group --region=$region --output text --group-name $sg_lestore_production --description "created by script" --vpc-id $vpc_id|awk '{print $1}'|head -1)
sg_lestore_devops_deployer_id=$(aws ec2 create-security-group --region=$region --output text --group-name $sg_lestore_devops_deployer --description "created by script" --vpc-id $vpc_id|awk '{print $1}'|head -1)
sg_lestore_devops_monitor_id=$(aws ec2 create-security-group --region=$region --output text --group-name $sg_lestore_devops_monitor --description "created by script" --vpc-id $vpc_id|awk '{print $1}'|head -1)
sg_jjscachesg_id=$(aws ec2 create-security-group --region=$region --output text --group-name $sg_jjscachesg --description "created by script" --vpc-id $vpc_id|awk '{print $1}'|head -1)
sg_jjsdbsg_id=$(aws ec2 create-security-group --region=$region --output text --group-name $sg_jjsdbsg --description "created by script" --vpc-id $vpc_id|awk '{print $1}'|head -1)
sg_jjselbsg_id=$(aws ec2 create-security-group --region=$region --output text --group-name $sg_jjselbsg --description "created by script" --vpc-id $vpc_id|awk '{print $1}'|head -1)
# check
sg_list=$(aws ec2 describe-security-groups --region $region --output text --filters Name=vpc-id,Values=$vpc_id)
if [ -z $sg_lestore_production_id ]; then
	sg_lestore_production_id=$(echo "$sg_list"|grep 'SECURITYGROUPS'|awk -F "\t" '{if($4=="'$sg_lestore_production'"){print $3}}')
fi
if [ -z $sg_lestore_devops_deployer_id ]; then
	sg_lestore_devops_deployer_id=$(echo "$sg_list"|grep 'SECURITYGROUPS'|awk -F "\t" '{if($4=="'$sg_lestore_devops_deployer'"){print $3}}')
fi
if [ -z $sg_lestore_devops_monitor_id ]; then
	sg_lestore_devops_monitor_id=$(echo "$sg_list"|grep 'SECURITYGROUPS'|awk -F "\t" '{if($4=="'$sg_lestore_devops_monitor'"){print $3}}')
fi
if [ -z $sg_jjscachesg_id ]; then
	sg_jjscachesg_id=$(echo "$sg_list"|grep 'SECURITYGROUPS'|awk -F "\t" '{if($4=="'$sg_jjscachesg'"){print $3}}')
fi
if [ -z $sg_jjsdbsg_id ]; then
	sg_jjsdbsg_id=$(echo "$sg_list"|grep 'SECURITYGROUPS'|awk -F "\t" '{if($4=="'$sg_jjsdbsg'"){print $3}}')
fi
if [ -z $sg_jjselbsg_id ]; then
	sg_jjselbsg_id=$(echo "$sg_list"|grep 'SECURITYGROUPS'|awk -F "\t" '{if($4=="'$sg_jjselbsg'"){print $3}}')
fi
#aws ec2 authorize-security-group-ingress --region $region --group-id sg-64a06c01 --protocol tcp --port 22 --cidr 203.0.113.0/24
#aws ec2 authorize-security-group-ingress --region $region --group-id sg-64a06c01 --protocol tcp --port 22 --source-group sg-67a06c02
# lestore-production
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_production_id --protocol tcp --port 80 --source-group $sg_jjselbsg_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_production_id --protocol tcp --port 443 --source-group $sg_jjselbsg_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_production_id --protocol tcp --port 38022 --source-group $sg_lestore_devops_deployer_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_production_id --protocol tcp --port "39000 - 39010" --source-group $sg_lestore_devops_deployer_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_production_id --protocol tcp --port 38888 --source-group $sg_lestore_devops_deployer_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_production_id --protocol tcp --port "1 - 65535" --source-group $sg_lestore_production_id
# lestore-devops-deployer
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_devops_deployer_id --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_devops_deployer_id --protocol tcp --port 38022 --cidr 115.236.98.93/32
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_devops_deployer_id --protocol tcp --port 38022 --cidr 101.231.200.238/32
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_devops_deployer_id --protocol tcp --port 38022 --source-group $sg_lestore_production_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_devops_deployer_id --protocol tcp --port "39000 - 39010" --source-group $sg_lestore_production_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_lestore_devops_deployer_id --protocol tcp --port "39000 - 39010" --cidr 101.231.200.238/32
# jjselbsg
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_jjselbsg_id --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_jjselbsg_id --protocol tcp --port 443 --cidr 0.0.0.0/0
# jjsdbsg
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_jjsdbsg_id --protocol tcp --port 3306 --source-group $sg_lestore_production_id
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_jjsdbsg_id --protocol tcp --port 3306 --source-group $sg_lestore_devops_deployer_id
# jjscachesg
aws ec2 authorize-security-group-ingress --region $region --group-id $sg_jjscachesg_id --protocol tcp --port 11211 --source-group $sg_lestore_production_id
# lestore-devops-monitor


# create key pairs
keypairs=$(aws ec2 describe-key-pairs --output text --region $region)
kp_devops_rsa=$(echo "$keypairs"|awk '{if($3=="devops_rsa"){print "exists"}}')
if [ "$kp_devops_rsa" != "exists" ]; then
	aws ec2 create-key-pair --region=$region --output text --key-name devops_rsa | awk -F "\t" 'BEGIN{RS="|||"}{print $2}' > ${__DIR__}/keys/devops_rsa
fi
# check prod_rsa
if [ ! -f ${__DIR__}/keys/devops_rsa ] || [ ! -s ${__DIR__}/keys/devops_rsa ]; then
	echo "==> ${__DIR__}/keys/devops_rsa is not exists or is empty."
	exit 1
fi
kp_prod_rsa=$(echo "$keypairs"|awk '{if($3=="prod_rsa"){print "exists"}}')
if [ "$kp_prod_rsa" != "exists" ]; then
	aws ec2 create-key-pair --region=$region --output text --key-name prod_rsa | awk -F "\t" 'BEGIN{RS="|||"}{print $2}' > ${__DIR__}/keys/prod_rsa
fi
# check prod_rsa
if [ ! -f ${__DIR__}/keys/prod_rsa ] || [ ! -s ${__DIR__}/keys/prod_rsa ]; then
	echo "==> ${__DIR__}/keys/prod_rsa is not exists or is empty."
	exit 1
fi
#kp_test_rsa=$(echo "$keypairs"|awk '{if($3=="test_rsa"){print "exists"}}')
#if [ "$kp_test_rsa" != "exists" ]; then
#	aws ec2 create-key-pair --region=$region --output text --key-name test_rsa | awk -F "\t" 'BEGIN{RS="|||"}{print $2}' > ${script_path}test_rsa
#fi

# create lb
elb_pre_id=$(aws elb create-load-balancer --region $region --output text --load-balancer-name $elb_pre \
	--listeners Protocol=http,LoadBalancerPort=80,InstanceProtocol=http,InstancePort=80 \
	--security-group $sg_jjselbsg_id --availability-zones $elb_availability_zones)
aws elb configure-health-check --load-balancer-name $elb_pre --region $region --health-check Target=HTTP:80/version,Interval=30,Timeout=5,UnhealthyThreshold=2,HealthyThreshold=10
elb_prod_id=$(aws elb create-load-balancer --region $region --output text --load-balancer-name $elb_prod \
	--listeners Protocol=http,LoadBalancerPort=80,InstanceProtocol=http,InstancePort=80 \
	--security-group $sg_jjselbsg_id --availability-zones $elb_availability_zones)
aws elb configure-health-check --load-balancer-name $elb_prod --region $region --health-check Target=HTTP:80/version,Interval=30,Timeout=5,UnhealthyThreshold=2,HealthyThreshold=10

# create sns
aws sns create-topic --region $region --output text --name $sns_topic_name
aws sns subscribe --region $region --output text --topic-arn "arn:aws:sns:$region:$owner:$sns_topic_name" --protocol email --notification-endpoint $sns_email
# 完了会收到一封邮件，需要点击里面一个链接激活

# create ses


# create ec
aws elasticache create-cache-cluster --region $region --cache-cluster-id $cache_session_id --num-cache-nodes $cache_session_num_nodes \
	--cache-node-type $cache_session_node_type --engine memcached --cache-parameter-group-name default.memcached1.4 \
	--security-group-ids $sg_jjscachesg_id
aws elasticache create-cache-cluster --region $region --cache-cluster-id $cache_v5_id --num-cache-nodes $cache_v5_num_nodes \
	--cache-node-type $cache_v5_node_type --engine memcached --cache-parameter-group-name default.memcached1.4 \
	--security-group-ids $sg_jjscachesg_id

# create rds parameter group
aws rds describe-db-parameter-groups --db-parameter-group-name $dbmysqlpg --region $region
if [ $? -ne 0 ]; then
	aws rds create-db-parameter-group --region $region --db-parameter-group-family "mysql5.1" --description "create by script" --db-parameter-group-name $dbmysqlpg
fi
# create rds master
#aws rds create-db-instance --region $region --db-name $dbname --db-instance-identifier $db_instance_identifier --allocated-storage 100 \
#	--db-instance-class $db_instance_class --engine MySQL --engine-version 5.1.73 --auto-minor-version-upgrade \
#	--master-username $dbuser --master-user-password $dbpswd \
#	--vpc-security-group-ids $sg_jjsdbsg_id --multi-az --db-parameter-group-name $dbmysqlpg
# create rds slave
###aws rds create-db-instance-read-replica --region $region --db-instance-identifier ${db_instance_identifier}slave --source-db-instance-identifier $db_instance_identifier \
###	--db-instance-class $db_instance_class --engine MySQL --auto-minor-version-upgrade
aws cloudformation create-stack --region $region --stack-name $rds_stack_name --template-body ${script_path}rds.json --capabilities CAPABILITY_IAM \
	--parameters ParameterKey=VpcId,ParameterValue=$vpc_id,UsePreviousValue=true ParameterKey=DBName,ParameterValue=$dbname,UsePreviousValue=true ParameterKey=DBUser,ParameterValue=$dbuser,UsePreviousValue=true ParameterKey=DBPassword,ParameterValue=$dbpswd,UsePreviousValue=true ParameterKey=InstanceType,ParameterValue=$db_instance_class,UsePreviousValue=true ParameterKey=ProductionAccessSG,ParameterValue=$sg_jjsdbsg_id,UsePreviousValue=true

# create deployer stack
aws cloudformation create-stack --region $region --stack-name $deployer_stack_name --template-body ${script_path}../../deployer/awscf.stack.json --capabilities CAPABILITY_IAM --parameters ParameterKey=StackShortName,ParameterValue=$deployer_stack_name,UsePreviousValue=true

# s3
aws s3 mb s3://$bucket_name_img --region $region
aws s3 mb s3://$bucket_name_dbbak --region $region

# cloud front
aws cloudformation create-stack --region $region --stack-name $cloudfront_stack_name \
	--template-body ${script_path}cloudfront.json --capabilities CAPABILITY_IAM \
	--parameters ParameterKey=LoadBalancer,ParameterValue=$elb_prod_id,UsePreviousValue=true ParameterKey=S3Bucket,ParameterValue=${bucket_name_img}.s3.amazonaws.com,UsePreviousValue=true


