#!/bin/bash

#autossh -Nnf  -L 0.0.0.0:10022:192.168.0.149:22 syncer@115.236.98.67 -i /root/.ssh/syncer_rsa -p32200
#autossh -Nnf  -L 0.0.0.0:10022:192.168.0.149:22 syncer@124.160.124.146 -i /root/.ssh/syncer146_rsa -p32200
ssh -p10022 lyu@192.168.1.51

# connect-149.haproxy-1080 port
#autossh -Nnf  -L 0.0.0.0:1080:192.168.0.149:1080 syncer@124.160.124.146 -i /root/.ssh/syncer146_rsa -p32200
