#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${SCRIPT_DIR}

# aws config
. ${SCRIPT_DIR}/aws_credential

deployer_stack_name="lestore-stage-deployer-0"
export GIT_SSL_NO_VERIFY=1
deployer_repo="https://g.pupugao.com/devops/lestore-deployer.git"
deployer_dir="lestore-deployer"

# put ssh keys
mkdir -p keys
ls keys
read -p "请把devops_rsa,prod_rsa,test_rsa的key放在${SCRIPT_DIR}/keys目录后, 并输入y: " key_input
if [ "${key_input}" != "y" ]; then
	echo "请确认key是否放置!"
	exit 1
fi
[ ! -z "$(ls keys)" ] || (echo "keys目录不能为空, 退出!"; exit 1)

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

# get deployer source code
test -x /usr/bin/git || (echo "Please install git, exit script!"; exit 1)
if [ "$(test -d ${deployer_dir} && (cd ${deployer_dir}; git remote -v | sed '1d' | awk '{print $2}'))" != "${deployer_repo}" ]; then
   test -d ${deployer_dir} && mv ${deployer_dir}.bak
   git clone ${deployer_repo} ${deployer_dir}
else
   cd ${deployer_dir}
   git checkout master -q
   git pull -q
fi

# upload deployer source code
cd ${SCRIPT_DIR}
rm -fr ${deployer_dir}/keys
cp -fr keys ${deployer_dir}
tar czf ${deployer_dir}.tar.gz ${deployer_dir}
${SCP} ${deployer_dir}.tar.gz ${deployer_user}@${deployer_ip}:~/
[ $? -ne 0 ] && (echo "${deployer_dir}.tar.gz 文件传输失败, 请检查!"; exit 1)

echo "安装deployer..."
${SSH} -t ${deployer_user}@${deployer_ip} "tar xzf ~/${deployer_dir}.tar.gz -C /tmp; cd /tmp/${deployer_dir}/stages; \
    make install stage=deployer; if [ $? -ne 0 ]; then echo error; else rm -f ~/${deployer_dir}.tar.gz; fi"

echo "生成ssh-agent..."
${SSH} -t ${deployer_user}@${deployer_ip} "make -C ~/deployer/stages _addkey; if [ $? -ne 0 ]; then echo Add ssh key failed!; else echo Add ssh key successifully!; cat ~/ssh-agent.sh;fi"

# upload database and config repo
test -f config_repo.tar.gz && rm -f config_repo.tar.gz
tar zcf config_repo.tar.gz config_repo_tmpl
for f in config_repo.tar.gz azazie.sql.tar.gz grant.sql; do
	test -f $f && (${SCP} $f ${deployer_user}@${deployer_ip}:~/; [ $? -ne 0 ] && (echo "${f}文件传输失败, 请检查!"; exit 1))
done
${SSH} -t ${deployer_user}@${deployer_ip} "test -d ~/config_repo_tmpl && (cd ~/;tar zcf config_repo_tmpl.$(date +%Y%m%d%H%M%S).tar.gz config_repo_tmpl;rm -rf ~/config_repo_tmpl);test -f ~/config_repo.tar.gz && tar xzf ~/config_repo.tar.gz -C ~/ && cd ~/config_repo_tmpl && bash config.sh"

