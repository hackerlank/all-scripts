## jenkins job
## this script use bbcp to transfer file from deployer to 192.168.1.0.3
## written by bcheng 

LOCAL_USER='jenkins'
LOCAL_HOST='192.168.0.3'
LOCAL_PORT='32200'
LOCAL_KEY='/var/jenkins/.ssh/jenkins_id_rsa'

REMOTE_USER='ec2-user'
REMOTE_HOST='23.23.245.121'
REMOTE_PORT='38022'

if [ "$proxy" = "true" ]; then
    PROXYCHAINS='proxychains'
else
    PROXYCHAINS=''
fi

BBCP='/usr/local/bin/bbcp'
SSH='/usr/bin/ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no'
LOG=/tmp/bbcp.$RANDOM
#TIMEOUT=1200
TIMEOUT=600

while [ true ]
do
(${PROXYCHAINS} ${BBCP} -fVP 2 -Z 39000:39010 -z \
    -S "${SSH} -p${REMOTE_PORT} -l %U %H ${BBCP}"  \
    -T "${SSH} -p${LOCAL_PORT} -i ${LOCAL_KEY} -l %U %H ${PROXYCHAINS} ${BBCP}" \
    ${REMOTE_USER}@${REMOTE_HOST}:${SRC}  ${LOCAL_USER}@${LOCAL_HOST}:${DST};echo $? >${LOG}) &
t=0
sleep 5
while [ ! -f ${LOG} ] && [ $t -lt ${TIMEOUT} ]
do
   sleep 10
   t=$((t+10))
   pid=$(ps aux | grep bbcp | grep ${LOCAL_HOST} | grep -v "grep" | head -1 | awk '{print $2}')
   if [ -z "$pid" ]; then
      break
   fi
done

if [ ! -f ${LOG} ]; then
   if [ ! -z "$pid" ]; then
       echo pid=$pid
       kill $pid
   fi
   ${SSH} ${LOCAL_USER}@${LOCAL_HOST} -p ${LOCAL_PORT} -i ${LOCAL_KEY} \
     "pid=\$(ps aux | grep bbcp | grep -v 'grep' | awk '{print \$2}');if [ ! -z \"\$pid\" ]; then kill \$pid; fi"
   sleep 60
else
   r=$(cat ${LOG})
   if [ $r -eq 0 ]; then
       echo "done"
       ${SSH} ${LOCAL_USER}@${LOCAL_HOST} -p ${LOCAL_PORT} -i ${LOCAL_KEY} \
          "/var/job/restorebasedbdatatest.sh 2>&1 >> /var/jenkins/log/restorebasedbdatatest.log"
       rm -fr ${LOG}
       exit 0
   fi
fi
   rm -fr /tmp/bbcp.*
done
