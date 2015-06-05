#!/bin/bash 
#Tokyo-proxy-3-TYO1_54.65.28.127
autossh -M 10005  -oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nnf -L 0.0.0.0:3120:127.0.0.1:3130 httpproxy@54.65.28.127 -p38022
