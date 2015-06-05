#! /bin/bash

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dist=~/tmp_config/

echo "此脚本应该在deployer上运行"

mkdir -p ${dist}
rsync -a --progress --delete $__DIR__/* $dist
cd ${dist}
grep "__=" config.conf | grep -v "^#" | while read i; do
    key=$(echo $i | awk -F"=" '{print $1}' )
    value=$(echo $i | awk -F"=" '{print $2}' )
    find . -type f ! -path './config.conf' | xargs -I {} sed -i "s#${key}#${value}#g" {}
done

rsync -a --progress --delete $dist ~/config_repo/

. $__DIR__/config.conf
make -C ~/deployer/stages/ _gender region=$__AWS_REGION__

echo "配置生成结束"
