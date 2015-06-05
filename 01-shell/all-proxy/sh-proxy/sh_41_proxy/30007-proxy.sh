#!/bin/bash 
# for GC VPS 50.31.240.209
# for GC VPS 54.251.121.152

autossh -M 10010  -oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nnf -L 0.0.0.0:30007:127.0.0.1:3131 httpproxy@50.31.240.209 -p22

#autossh -M 10010  -oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nnf -L 0.0.0.0:30007:127.0.0.1:3131 httpproxy@50.31.240.209 -p22
