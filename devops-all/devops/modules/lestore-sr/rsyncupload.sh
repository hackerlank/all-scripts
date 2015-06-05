#! /bin/bash
source $(dirname $0)/sr_rsync.conf

running=$(ps aux|grep e9573fbb5840585c1e3b2fe4b354d61b|grep 'sh -c '|grep -v 'grep'|wc -l)
if [ "$running" -gt 1 ]; then
    echo "$(ps aux|grep e9573fbb5840585c1e3b2fe4b354d61b|grep 'sh -c '|grep -v 'grep')"
    echo "already running $0 ($running) $(date +'%Y-%m-%d %T')"
    exit 1
fi

if [ -f "$(dirname $0)/ssh-agent.sh" ]; then
    source $(dirname $0)/ssh-agent.sh
fi

rsync -az -K --progress -e "ssh -p${rsync_upload_port}" ${rsync_upload_user}@${rsync_upload_host}:/opt/data1/jjsimg/upload/ /opt/data1/jjsimg/upload/
