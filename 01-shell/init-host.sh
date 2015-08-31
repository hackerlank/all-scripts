#!/bin/bash

setenforce 0

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

chkconfig ip6tables off
chkconfig iptables off
chkconfig --list|grep ip

sed -i 's/DIR\ 01;34/DIR\ 38;5;27/g' /etc/DIR_COLORS
sed -i 's/EXEC\ 01;32/EXEC\ 38;5;34/g' /etc/DIR_COLORS
sed -i '$a colorscheme desert' /etc/vimrc
