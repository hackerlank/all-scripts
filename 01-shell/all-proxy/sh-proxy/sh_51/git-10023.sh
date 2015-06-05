#!/bin/bash

#autossh -Nnf  -L 0.0.0.0:10023:192.168.0.26:32200 syncer@115.236.98.67 -i /root/.ssh/syncer_rsa -p32200
autossh -Nnf  -L 0.0.0.0:10023:192.168.0.26:32200 syncer@124.160.124.146 -i /root/.ssh/syncer146_rsa -p32200
