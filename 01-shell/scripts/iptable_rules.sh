#!/bin/bash
# 10段机器需要执行此命令进行中转
# vim /etc/sysctl.conf
# 将 net.ipv4.ip_forward = 0 改成：net.ipv4.ip_forward = 1 ;同时syscty -p
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.16.83:80
#iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.16.83:22

iptables -t nat -A POSTROUTING -j MASQUERADE
