#! /bin/bash

:<<EOF
By Zandy
EOF

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $__DIR__/../aws_credential

__AWS_REGION__=$region

search_suffix=":38080/jjssearch"

echo -e "\033[01;32m"
echo -e "\033[01;36m==> 此脚本只应该在ubuntu14.04虚拟机上运行，而不是在aws上运行。\033[0m"
echo -e "\033[01;32m"
echo -e "==> 开始自动生成配置文件，当前运行的 region 是 \033[01;36m$__AWS_REGION__\033[0m"
echo -e "\033[01;32m"

# {{{ rds
aws rds describe-db-instances --region $__AWS_REGION__ > db_instances
__db_host_0__=$(jq .DBInstances[0].Endpoint.Address db_instances | sed 's/"//g')
__db_host_1__=$(jq .DBInstances[1].Endpoint.Address db_instances | sed 's/"//g')
is_slave=$(jq .DBInstances[1].StatusInfos[0].StatusType db_instances | sed 's/"//g')
if [ "$is_slave" == "read replication" ]; then
	__DB_HOST__=$__db_host_0__
	__DB_SLAVE_HOST__=$__db_host_1__
else
	__DB_HOST__=$__db_host_1__
	__DB_SLAVE_HOST__=$__db_host_0__
fi
# }}}
# {{{ elc
aws elasticache describe-cache-clusters --region $__AWS_REGION__ > cache_clusters
__cache_host_0__=$(jq '.CacheClusters[0].ConfigurationEndpoint.Address' cache_clusters | sed 's/"//g')
__cache_host_1__=$(jq '.CacheClusters[1].ConfigurationEndpoint.Address' cache_clusters | sed 's/"//g')
echo "$__cache_host_0__" | grep -q "v5"
if [ $? -eq 0 ]; then
	__CACHE_HOST__=$__cache_host_1__
	__MC_DYNAMIC__=$__cache_host_0__
else
	__CACHE_HOST__=$__cache_host_0__
	__MC_DYNAMIC__=$__cache_host_1__
fi
__MC_CLUSTER_NODE1__=$(echo $__MC_DYNAMIC__ | sed 's/.cfg./.0001./')
__MC_CLUSTER_NODE2__=$(echo $__MC_DYNAMIC__ | sed 's/.cfg./.0002./')
# }}}
# {{{ host
__SEARCH_MAIN__=$(aws ec2 describe-instances --region $__AWS_REGION__ --output text \
	--filters "Name=tag-key,Values=aws:cloudformation:stack-name" \
	--filters "Name=tag-value,Values=lestore-stage-vbridal-search-prod-0" | grep -E "^INSTANCE" | awk '{print $15}'|grep amazonaws)
__SEARCH_MAIN__="$__SEARCH_MAIN__$search_suffix"
__SEARCH_BACK__=$(aws ec2 describe-instances --region $__AWS_REGION__ --output text \
	--filters "Name=tag-key,Values=aws:cloudformation:stack-name" \
	--filters "Name=tag-value,Values=lestore-stage-vbridal-search-prod-2" | grep -E "^INSTANCE" | awk '{print $15}'|grep amazonaws)
__SEARCH_BACK__="$__SEARCH_BACK__$search_suffix"
__SR_HOST__=$(aws ec2 describe-instances --region $__AWS_REGION__ --output text \
	--filters "Name=tag-key,Values=lestore:stack-name" \
	--filters "Name=tag-value,Values=lestore-stage-sr-prod-0" | grep -E "^INSTANCE" | awk '{print $15}'|grep amazonaws)
__CMS_HOST__=$(aws ec2 describe-instances --region $__AWS_REGION__ --output text \
	--filters "Name=tag-key,Values=aws:cloudformation:stack-name" \
	--filters "Name=tag-value,Values=lestore-stage-cms-prod-0" | grep -E "^INSTANCE" | awk '{print $15}'|grep amazonaws)
# }}}

param_keys="__AWS_REGION__
__DB_HOST__
__DB_SLAVE_HOST__
__CACHE_HOST__
__MC_DYNAMIC__
__MC_CLUSTER_NODE1__
__MC_CLUSTER_NODE2__
__SEARCH_MAIN__
__SEARCH_BACK__
__SR_HOST__
__CMS_HOST__"


config_conf=$(cat $__DIR__/config.auto.conf $__DIR__/config.manual.conf)

for param in $(echo "$param_keys"); do
	param_value=$(eval echo \$$param)
	compare_r=$(echo $param_value|sed "s~$search_suffix$~~")
	if [ "$compare_r" == "" ]; then
		echo "==> $param 是空值，脚本需要重新跑一遍"
		echo -e "\033[0m"
		exit 1
	fi
	config_conf=$(echo "$config_conf" | sed "s~^$param=.*$~$param=$param_value~")
done

echo "$config_conf" > $__DIR__/config.conf

echo "==> 配置文件 config.conf 生成完成"
echo "==> 请检查 config.conf 内容，是否有明显问题，比如有空值什么的"
echo -e "\033[0m"

