#!/bin/bash

#PORT=38888
#HOST_PORT=192.168.0.4:38080
#autossh -M 38890 -f -i /home/ec2-user/.awstools/keys/syncer_id_rsa -p 32200 -f -N -g -L $PORT:$HOST_PORT syncer@115.236.98.66

forward_hz_cmd1="autossh -M 32212 -f -i /home/ec2-user/.awstools/keys/forward_id_rsa -p 32200 -f -N -g -L 32210:127.0.0.1:32200 syncer@115.236.98.66"
forward_hz_cmd2="autossh -M 32222 -f -i /home/ec2-user/.awstools/keys/forward_id_rsa -p 32200 -f -N -g -L 32220:127.0.0.1:873 syncer@115.236.98.67"

${forward_hz_cmd1}
${forward_hz_cmd2}
