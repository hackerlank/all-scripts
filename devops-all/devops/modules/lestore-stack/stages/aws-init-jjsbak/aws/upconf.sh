#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${SCRIPT_DIR}

# aws config
. ${SCRIPT_DIR}/aws_credential

deployer_stack_name="lestore-stage-deployer-0"
export GIT_SSL_NO_VERIFY=1
deployer_repo="https://g.pupugao.com/devops/lestore-deployer.git"
deployer_dir="lestore-deployer"

# query deployer stack
deployer_ip_query=$(aws ec2 describe-instances --region $region --output text \
    --filters "Name=tag-key,Values=aws:cloudformation:stack-name"  \
    --filters "Name=tag-value,Values=${deployer_stack_name}" | grep -E "^INSTANCE" | awk '{print $15}' | head -1)
[ -z "${deployer_ip}" ] || (echo "未查询到deployer, 请在cloudformation检查deployer是否创建成功!"; exit 1)

# get parameters
read -p "输入deployer的ip或域名[${deployer_ip_query}]: " deployer_ip
read -p "输入deployer的key[${SCRIPT_DIR}/keys/devops_rsa]: " deployer_key
read -p "输入deployer的user[ec2-user]: " deployer_user
read -p "输入deployer的port[38022]: " deployer_port
deployer_ip="${deployer_ip:-${deployer_ip_query}}"
deployer_port="${deployer_port:-38022}"
deployer_user="${deployer_user:-ec2-user}"
deployer_key="${deployer_key:-${SCRIPT_DIR}/keys/devops_rsa}"
[ ! -z "${deployer_ip}" ] || (echo "deployer ip不能为空, 退出!"; exit 1)
[ ! -z "${deployer_key}" ] || (echo "deployer key不能为空, 退出!"; exit 1)
test -f ${deployer_key} && chmod 600 ${deployer_key}

# ssh config
SSH="ssh -oConnectTimeout=15 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -p${deployer_port} -i${deployer_key}"
SCP="scp -oConnectTimeout=15 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -P${deployer_port} -i${deployer_key}"

# upload database and config repo
test -f config_repo.tar.gz && rm -f config_repo.tar.gz
tar zcf config_repo.tar.gz config_repo_tmpl
for f in config_repo.tar.gz; do
	test -f $f && (${SCP} $f ${deployer_user}@${deployer_ip}:~/; [ $? -ne 0 ] && (echo "${f}文件传输失败, 请检查!"; exit 1))
done
${SSH} -t ${deployer_user}@${deployer_ip} "test -d ~/config_repo_tmpl && (cd ~/;tar zcf config_repo_tmpl.$(date +%Y%m%d%H%M%S).tar.gz config_repo_tmpl;rm -rf ~/config_repo_tmpl);test -f ~/config_repo.tar.gz && tar xzf ~/config_repo.tar.gz -C ~/ && cd ~/config_repo_tmpl && bash config.sh"

