#!/bin/bash
#
#
DATE="`date +%Y%m%d%H%M%S`"
# change bonding options 
if [ -f "/etc/sysconfig/network-scripts/ifcfg-bond1" ];then
    cp /etc/sysconfig/network-scripts/ifcfg-bond1 /root/ifcfg-bond1-bak-${DATE}
    sed -i '/BONDING_OPTS/d' /etc/sysconfig/network-scripts/ifcfg-bond1
    sed -i '$aBONDING_OPTS="mode=4 miimon=100 lacp_rate=1 xmit_hash_policy=2"' /etc/sysconfig/network-scripts/ifcfg-bond1
fi

if [ -f "/etc/sysconfig/network-scripts/ifcfg-bond0" ];then
    cp /etc/sysconfig/network-scripts/ifcfg-bond0 /root/ifcfg-bond0-bak-${DATE}
    sed -i '/BONDING_OPTS/d' /etc/sysconfig/network-scripts/ifcfg-bond0
    sed -i '$aBONDING_OPTS="mode=4 miimon=100 lacp_rate=1 xmit_hash_policy=2"' /etc/sysconfig/network-scripts/ifcfg-bond0
fi

if [ -f "/etc/sysconfig/network-scripts/ifcfg-bond0" ];then
    cp /etc/sysconfig/network-scripts/ifcfg-bond0 /root/ifcfg-bond0-bak-${DATE}
    sed -i '/MTU/d' /etc/sysconfig/network-scripts/ifcfg-bond0
    sed -i '$aMTU="9000"' /etc/sysconfig/network-scripts/ifcfg-bond0
fi

if [ -f "/etc/sysconfig/network-scripts/ifcfg-bond0.1502" ];then
    cp /etc/sysconfig/network-scripts/ifcfg-bond0.1502 /root/ifcfg-bond0.1502-bak-${DATE}
    sed -i '/MTU/d' /etc/sysconfig/network-scripts/ifcfg-bond0.1502
    sed -i '$aMTU="9000"' /etc/sysconfig/network-scripts/ifcfg-bond0.1502
fi
# change some system config 
grep -q 'NOZEROCONF=yes' /etc/sysconfig/network || echo "NOZEROCONF=yes" >>/etc/sysconfig/network
grep -q 'HISTTIMEFORMAT' /root/.bash_profile || sed -i '$aexport HISTTIMEFORMAT="`whoami` %F %T : "' /root/.bash_profile 
sed -i 's/.*SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/.*SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# clean /etc/yum.repos.d/ 
yum clean all
for f in /etc/yum.repos.d/*.repo;
do
    mv ${f} ${f}.${DATE}
done

# config DNS
for ip in 1.2.4.8 114.114.114.114 8.8.8.8;
do
    echo "nameserver $ip"
done >/etc/resolv.conf 

# Load nf_conntrack.ko at boot
if [ -d "/etc/modules-load.d/" ];then
    cat >/etc/modules-load.d/netfilter.conf<<EOF
# Load nf_conntrack.ko at boot
nf_conntrack
EOF
fi

# enable sysctl
chmod +x /etc/rc.d/rc.local
grep "sysctl -p" /etc/rc.d/rc.local || echo "sysctl -p" >>//etc/rc.d/rc.local

# ensure /root/.ssh/ is exsit
mkdir -p /root/.ssh/

# config ssh client

