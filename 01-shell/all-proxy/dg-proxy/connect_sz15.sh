#!/bin/bash

/usr/lib/autossh/autossh -M 58000 -oConnectTimeout=30 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -Nn -R 32202:127.0.0.1:32200 lyu@58.210.9.226 -p38022 -i /root/.ssh/lyu_rsa
