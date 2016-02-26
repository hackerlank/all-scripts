#!bin/bash

echo "nameserver 202.96.209.5" >> /etc/resolv.conf
yum -y install vim
yum -y install net-tools

sed -i 's/DIR\ 01;34/DIR\ 38;5;27/g' /etc/DIR_COLORS
sed -i 's/EXEC\ 01;32/EXEC\ 38;5;34/g' /etc/DIR_COLORS
sed -i '$a colorscheme desert' /etc/vimrc
exec $SHELL

tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl status firewalld.service

rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

setenforce 0
sed -i -E 's/(^SELINUX=)enforcing/\1disabled/'  /etc/selinux/config

yum -y install docker-engine
systemctl enable docker.service
systemctl enable docker.socket

systemctl start docker.service
