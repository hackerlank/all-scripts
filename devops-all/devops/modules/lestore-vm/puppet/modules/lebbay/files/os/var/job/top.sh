#! /bin/bash

echo "now: $(date +'%Y-%m-%d %H:%M:%S')" >> /var/log/top.$(date +%Y%m%d).log
top -b1 -n1 >> /var/log/top.$(date +%Y%m%d).log
ps aux >> /var/log/top.$(date +%Y%m%d).log
#iotop -bn 1 >> /var/log/top.$(date +%Y%m%d).log
vmstat 1 10 >> /var/log/top.$(date +%Y%m%d).log
echo -e "now: $(date +'%Y-%m-%d %H:%M:%S')" >> /var/log/monitor/netstat.$(date +%Y%m%d).log
echo "Number of connections:" >> /var/log/monitor/netstat.$(date +%Y%m%d).log
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' >> /var/log/monitor/netstat.$(date +%Y%m%d).log
for name in php-fpm nginx
do
        num=`netstat -antlp|grep ESTABLISHED |grep $name|wc -l`
        echo "$name $num" >> /var/log/monitor/netstat.$(date +%Y%m%d).log
done