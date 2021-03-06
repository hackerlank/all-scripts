#!/bin/bash

filelist=(
"/etc/haproxy/haproxy.cfg"
"/root/proxy-scripts/"
"/etc/logrotate.d/haproxy"
)

haproxy_conf="/etc/haproxy/haproxy.cfg"
test -f ${haproxy_conf} && md5_old=$(md5sum ${haproxy_conf} | awk '{print $1}')

for f in ${filelist[@]}; do
	rsync  -vzrtopg --progress -e "ssh -i /root/.ssh/sh_41 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" root@192.168.1.41:${f} ${f}
done

test -f ${haproxy_conf} && md5_new=$(md5sum ${haproxy_conf} | awk '{print $1}')
if [ "${md5_old}" != "${md5_new}" ]; then
		service haproxy reload
fi

