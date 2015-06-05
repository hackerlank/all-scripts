#!/bin/bash

source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/logman_config.sh
source /etc/profile.d/aws-apitools-common.sh
ec2di=/opt/aws/bin/ec2-describe-instances
#export EC2_HOME=/opt/aws
#export JAVA_HOME=/usr/lib/jvm/jre

SED="sed -r"

function generate(){
    ${ec2di} -O "$1" -W "$2" --show-empty-fields --region $region --filter 'instance-state-name=running' > instances
    <instances grep '^TAG'| grep 'aws:cloudformation:stack-name'| grep 'lestore-stage-' | grep -v 'deployer' | awk '{print $3}' > instances.id
    <instances.id xargs -I {} bash -c "< instances grep '^TAG'| grep '{}\sName' | awk '{print \$3,\$5}' | ${SED} 's/lestore-stage-//'" | sort -k 1 > instances.name
    <instances.id xargs -I {} bash -c "< instances grep '^INSTANCE'| grep '{}' | awk '{print \$2,\$18}'" | sort -k 1 > instances.ip
    join instances.ip instances.name | awk '{print $2"\t\t"$3"\t#devops"}' | sort -k 2 >> managed.hosts
    <instances.name awk '{print $2}' | ${SED} 's/\-/,/g' | paste instances.name - | awk '{print $2"\t\t"$3}' | sort -k 1 >> managed.genders
    rm -f instances*
}


for i in ${!aws_keys[@]}; do
    generate ${aws_keys[$i]} ${aws_private_keys[$i]}
done

${SED} -i '/#devops/d' /etc/hosts
cat managed.hosts >> /etc/hosts
mv managed.* /home/ec2-user/.awstools/
