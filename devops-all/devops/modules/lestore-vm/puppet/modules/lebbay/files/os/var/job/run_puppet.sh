#! /bin/bash

ROOT=/home/ec2-user
#sudo
ls ${ROOT}/puppet/manifests/*.pp | xargs -I {} puppet apply $* --verbose --color=false --modulepath $ROOT/puppet/modules:/usr/share/puppet/modules {}
