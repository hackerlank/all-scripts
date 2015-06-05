#!/bin/bash

source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/logman_config.sh
#统计每个小时同个IP超过1000访问的
day=`date +%Y%m%d --date='1 days ago'`
access_log='/opt/data1/access_log'
projects=("${count_projects}")
monitor_logs_dir='/var/log/monitor'
if [ ! -d $monitor_logs_dir ]
then
	mkdir -p $monitor_logs_dir
fi

for project in ${projects[@]}
do
        allname=`echo $project | awk -F: '{print $1}'`
        projectname=`echo $project | awk -F: '{print $2}'`
	echo > /var/log/monitor/ip_$day-$allname-all.txt
	echo "start script:" $(date +"%y-%m-%d %H:%M:%S") |tee -a  /var/log/monitor/ip_$day-$allname-all.txt
	echo "###########################################" |tee -a  /var/log/monitor/ip_$day-$allname-all.txt
	echo "$project $day" |tee -a  /var/log/monitor/ip_$day-$allname-all.txt
	for nodedir in `find $access_log/$projectname-prod-* -type d`
	do
		nodename=`echo $nodedir | awk -F'/' '{print $5}'`
		if [ -f ${nodedir}/access-${day}.log.tar.gz ]
		then
			echo "---------------------------------------------------" |tee -a  /var/log/monitor/ip_$day-$allname-all.txt
			echo "${nodedir}" |tee -a  /var/log/monitor/ip_$day-$allname-all.txt
			cd $nodedir
			tar -xvf access-${day}.log.tar.gz
			echo -e "time   quantity        ip                                         http_user_agent"  |tee -a  /var/log/monitor/ip_$day-$allname-all.txt
			cat access-$day-$allname-www.log |awk -F'"|:' '{if(NF==14)print $2,$9,$10,$11,$14;if(NF==13)print $2,$9,$10,$13}'|awk '{str="";for(i=1;i<=NF-2;i++){str=str" "$i;}print str}'|awk '{a[$1]++} END {print $0;for(i in a) print i,a[i],"total"}{print $0}'|sort|uniq -c|awk '{if($1>=1000) print $0}{if(NF==4 && $NF=="total") print $3,$2}'|sort -n -k2 -k1|awk '{str="";for(i=1;i<=NF;i++){if(i!=2 && i!=1 && i!=NF) str=str" "$i} if(NF==2)print $2"\t"$1"\ttotal";if(NF!=2) print $2"\t"$1"\t"$NF"\t"str}'|tee -a  /var/log/monitor/ip_$day-$allname-all.txt
		fi
	done
	cd $access_log
	find . -path "${access_log}" -prune -o -name  access-${day}-*.log | xargs -I {} rm -f {}
       	echo "###########################################" |tee -a /var/log/monitor/ip_$day-$allname-all.txt
	echo "end script:" $(date +"%y-%m-%d %H:%M:%S") |tee -a /var/log/monitor/ip_$day-$allname-all.txt
	echo ""
	mail -s "[R_R] $allname ip count $day" hwang@i9i8.com bcheng@i9i8.com < /var/log/monitor/ip_$day-$allname-all.txt
done
