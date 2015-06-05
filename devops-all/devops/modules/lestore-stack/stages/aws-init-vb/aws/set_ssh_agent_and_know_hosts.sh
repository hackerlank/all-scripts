#!/bin/bash

echo -e "\033[01;35m"
echo "==> 此脚本需以 ec2-user 用户在 deployer 的 /home/ec2-user 目录下执行。<=="
echo -e "\033[0m"
echo -e "\033[01;34m"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${SCRIPT_DIR}

# {{{ install pip
is_aws=$(cat /etc/issue|grep 'Amazon Linux'|wc -l)
is_centos=$(cat /etc/issue|grep -i 'CentOS'|wc -l)
if [ "$is_aws" -gt 0 ] || [ "$is_centos" -gt 0 ]; then
	sudo yum install python-pip -y
	sudo pip install awscli
elif [ "$(cat /etc/issue|grep 'Ubuntu|Debian')" -eq 0 ]; then
	sudo apt-get install python-pip -y
	sudo pip install awscli
else
	echo "==> 要运行此脚本必须要有 aws 命令 <==";
fi
# }}}

# aws config
#. ${SCRIPT_DIR}/aws_credential
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep '"region' | awk -F '"' '{print $4}')
#region=eu-west-1

sr_stack_name="lestore-stage-sr-prod-0"
cms_stack_name="lestore-stage-cms-prod-0"
logman_stack_name="lestore-stage-logman-prod-0"

# query sr stack
sr_domain_query=$(aws ec2 describe-instances --region $region --output text \
    --filters "Name=tag-key,Values=aws:cloudformation:stack-name"  \
    --filters "Name=tag-value,Values=${sr_stack_name}" | grep -E "^INSTANCE" | awk '{print $15}' | grep amazonaws)
[ -z "${sr_domain_query}" ] && (echo "未查询到sr, 请在cloudformation检查sr是否创建成功!"; exit 1)
# query cms stack
cms_domain_query=$(aws ec2 describe-instances --region $region --output text \
    --filters "Name=tag-key,Values=aws:cloudformation:stack-name"  \
    --filters "Name=tag-value,Values=${cms_stack_name}" | grep -E "^INSTANCE" | awk '{print $15}' | grep amazonaws)
[ -z "${cms_domain_query}" ] && (echo "未查询到cms, 请在cloudformation检查cms是否创建成功!"; exit 1)
# query logman stack
logman_domain_query=$(aws ec2 describe-instances --region $region --output text \
    --filters "Name=tag-key,Values=aws:cloudformation:stack-name"  \
    --filters "Name=tag-value,Values=${logman_stack_name}" | grep -E "^INSTANCE" | awk '{print $15}' | grep amazonaws)
[ -z "${logman_domain_query}" ] && (echo "未查询到logman, 请在cloudformation检查logman是否创建成功!"; exit 1)

# get parameters
read -p "输入sr的域名[${sr_domain_query}]: " sr_domain
read -p "输入cms的域名[${cms_domain_query}]: " cms_domain
read -p "输入logman的域名[${logman_domain_query}]: " logman_domain
sr_domain="${sr_domain:-${sr_domain_query}}"
cms_domain="${cms_domain:-${cms_domain_query}}"
logman_domain="${logman_domain:-${logman_domain_query}}"
ssh_port="38022"
ssh_user="ec2-user"
ssh_pkey="${SCRIPT_DIR}/.awstools/keys/devops_rsa"
[ ! -z "${sr_domain}" ] || (echo "sr 域名不能为空, 退出!"; exit 1)
[ ! -z "${cms_domain}" ] || (echo "cms 域名不能为空, 退出!"; exit 1)
[ ! -z "${logman_domain}" ] || (echo "logman 域名不能为空, 退出!"; exit 1)

# ssh config
SSH="ssh -oConnectTimeout=15 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -p${ssh_port} -i${ssh_pkey}"

# run ssh-agent & add known_hosts
# for sr
#${SSH} -t ${ssh_user}@${sr_domain} "sudo sh -c \"cd /var/job;killall ssh-agent;ssh-agent > /var/job/ssh-agent.sh;. /var/job/ssh-agent.sh;ssh-add /root/.ssh/aws.cms;touch /root/.ssh/known_hosts;ssh-keygen -f /root/.ssh/known_hosts -H -F $cms_domain;if [ $? -ne 0 ]; then echo 'xxx';ssh-keyscan -p 38022 -t rsa,dsa,ecdsa $cms_domain 2>/dev/null >> /root/.ssh/known_hosts; else echo 'yyy'; fi\""
${SSH} -t ${ssh_user}@${sr_domain} "sudo sh -c \"killall ssh-agent;ssh-agent > /var/job/ssh-agent.sh;chmod 700 /var/job/ssh-agent.sh;. /var/job/ssh-agent.sh;ssh-add /root/.ssh/aws.cms;ssh-keyscan -p 38022 -t rsa,dsa,ecdsa $cms_domain 2>/dev/null > /root/.ssh/known_hosts;\""

# for cms
${SSH} -t ${ssh_user}@${cms_domain} "sudo sh -c \"killall ssh-agent;ssh-agent > /var/job/ssh-agent.sh;chmod 700 /var/job/ssh-agent.sh;. /var/job/ssh-agent.sh;ssh-add /root/.ssh/aws.cms;ssh-add /var/www/http/zzcms-prod/stages/zzcms-prod/id_rsa;ssh-keyscan -p 38022 -t rsa,dsa,ecdsa $sr_domain 2>/dev/null > /root/.ssh/known_hosts;ssh-keyscan -p 32200 -t rsa,dsa,ecdsa 115.236.98.66 2>/dev/null >> /root/.ssh/known_hosts;ssh-keyscan -p 32200 -t rsa,dsa,ecdsa 115.236.98.67 2>/dev/null >> /root/.ssh/known_hosts;\""

# for logman
${SSH} -t ${ssh_user}@${logman_domain} "sudo sh -c \"killall ssh-agent;ssh-agent > /var/job/ssh-agent.sh;chmod 700 /var/job/ssh-agent.sh;. /var/job/ssh-agent.sh;ssh-add /home/ec2-user/.awstools/keys/prod_rsa;\""

echo -e "\033[0m"
echo -e "\033[01;35m"
echo "==> 运行完毕，请检查 <=="
echo -e "\033[0m"


