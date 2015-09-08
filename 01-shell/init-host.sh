#!/bin/bash

setenforce 0

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

chkconfig ip6tables off
chkconfig iptables off
chkconfig --list|grep ip

sed -i 's/DIR\ 01;34/DIR\ 38;5;27/g' /etc/DIR_COLORS
sed -i 's/EXEC\ 01;32/EXEC\ 38;5;34/g' /etc/DIR_COLORS
sed -i '$a colorscheme desert' /etc/vimrc

# wget -O git-flow-0.4.1_git201202141310-1.9.noarch.rpm ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/devel:/tools:/scm/openSUSE_Factory/noarch/git-flow-0.4.1_git201202141310-1.9.noarch.rpm
# wget -O  bash-completion-20060301-11.noarch.rpm ftp://ftp.pbone.net/mirror/atrpms.net/el6-x86_64/atrpms/stable/bash-completion-20060301-11.noarch.rpm
