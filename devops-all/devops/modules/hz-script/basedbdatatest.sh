#/bin/bash
LOCAL_USER='root'
LOCAL_HOST='192.168.1.50'
LOCAL_PORT='22'
LOCAL_KEY='test_rsa'

REMOTE_USER='ec2-user'
REMOTE_HOST='23.23.245.121'
REMOTE_PORT='38022'

SRC="/home/ec2-user/rsync_root/testdb/basedbdatatest.sql.tar.gz"
DST="/var/opt/basedbdata/basedbdatatest.sql.tar.gz"
BBCP='/usr/local/bin/bbcp'
SSH='/usr/bin/ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no'

mkdir -p /var/opt/basedbdata

${BBCP} -fVP 2 -Z 39000:39010 -z -S "${SSH} -i ${LOCAL_KEY} -p ${REMOTE_PORT} -l %U %H ${BBCP}" -T "${BBCP}" ${REMOTE_USER}@${REMOTE_HOST}:${SRC} ${DST}
