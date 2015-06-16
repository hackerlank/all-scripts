#!/bin/bash


yum erase git -y

rpm -ivh /tmp/epel-release-6-5.noarch.rpm

sed -i 's/DIR\ 01;34/DIR\ 38;5;27/g' /etc/DIR_COLORS
sed -i 's/EXEC\ 01;32/EXEC\ 38;5;34/g' /etc/DIR_COLORS
sed -i '$a colorscheme desert' /etc/vimrc
sed -i '$a unset SSH_ASKPASS' /etc/bashrc
# 修改/etc/yum.repos.d/epel.repo

#yum install -y haproxy
#yum install -y autossh
#yum install -y socat


yum install -y expat-devel
yum install -y subversion-perl
yum install -y perl-YAML

if [ $? -eq 0 ];then
	rpm -ivh /tmp/git-1.8.3.4-1.1.x86_64.rpm /tmp/perl-Git-1.8.3.4-1.1.x86_64.rpm
	export  GIT_SSL_NO_VERIFY=1
fi
