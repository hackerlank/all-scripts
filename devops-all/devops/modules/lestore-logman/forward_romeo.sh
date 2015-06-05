#!/bin/bash

#CMD="ssh -i /home/ec2-user/.awstools/keys/syncer_id_rsa -p 32200 -f -N -g -L $PORT:$HOST_PORT syncer@115.236.98.66"
#CMD="ssh -p 32200 -f -N -g -L $PORT:$HOST_PORT syncer@124.160.124.146"

forward_romeo_cmd="autossh -M 38890 -f -i /home/ec2-user/.awstools/keys/syncer_id_rsa -p 32200 -f -N -g -L 38888:192.168.0.140:38080 syncer@115.236.98.66"

CMD=${forward_romeo_cmd}
while true
do
    ps -ef | grep "$CMD" | grep -v 'grep' > /dev/null
    if [[ $? == 1 ]]
    then
        echo start $(date +"%Y-%m-%d %T")
        `$CMD`
    fi
    sleep 1
done
