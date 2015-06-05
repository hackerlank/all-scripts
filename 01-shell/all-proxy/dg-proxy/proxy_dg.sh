#!/bin/bash
# connect szdgproxy@220.181.28.252
/usr/lib/autossh/autossh -M 20011 -oConnectTimeout=5 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nn  -L 192.168.1.248:9002:127.0.0.1:3128 szdgproxy@220.181.28.252 -p32200
