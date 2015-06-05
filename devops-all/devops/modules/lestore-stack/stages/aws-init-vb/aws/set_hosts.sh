#!/bin/bash
# Set prod/ticket/cms machine /etc/hosts files
#echo "This script should be run in dir(/home/ec2-user) on the deployer machine."
echo -e "\033[01;31m"
echo "==> 注意:此脚本需以 ec2-user 用户在 deployer 的 /home/ec2-user 目录下执行。<=="
echo -e "\033[0m"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

. $SCRIPT_DIR/ssh-agent.sh
cms_ip=`grep "cms" /etc/hosts |awk '{print $1}'`
ticket_ip=`grep "osticket" /etc/hosts |awk '{print $1}'`

prod0_domain=`grep "zz-prod-0" /etc/hosts |awk '{print $2}'`
prod2_domain=`grep "zz-prod-2" /etc/hosts |awk '{print $2}'`
ticket_domain=`grep "osticket" /etc/hosts |awk '{print $2}'`
cms_domain=`grep "cms" /etc/hosts |awk '{print $2}'`

# 1. Set two prod machine /etc/hosts
ssh -p38022 -t $prod0_domain "sudo sed -i '1a\\$ticket_ip  t.azazie.com' /etc/hosts;"
ssh -p38022 -t $prod0_domain "sudo sed -i '1a\\$cms_ip  up.azazie.com img.azazie.com' /etc/hosts;"

ssh -p38022 -t $prod2_domain "sudo sed -i '1a\\$ticket_ip  t.azazie.com' /etc/hosts;"
ssh -p38022 -t $prod2_domain "sudo sed -i '1a\\$cms_ip  up.azazie.com img.azazie.com' /etc/hosts;"
# 2. Set ticket machine /etc/hosts
ssh -p38022 -t $ticket_domain "sudo sed -i '1a\\$cms_ip  up.azazie.com img.azazie.com' /etc/hosts;"

# 3. Set cms  machine  /etc/hosts
ssh -p38022 -t $cms_domain "sudo sed -i '1a\\127.0.0.1  up.azazie.com img.azazie.com' /etc/hosts;"
