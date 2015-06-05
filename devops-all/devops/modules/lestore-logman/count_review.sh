#!/bin/bash

day_sum=26
access_log='/opt/data1/access_log'
projects=("${count_projects}")
monitor_logs_dir='/var/log/count_review'
if [ ! -d $monitor_logs_dir ]
then
	mkdir -p $monitor_logs_dir
fi

#while [ $day_sum -ne 1 ]
for day in 20130815 20130816 20130817 20130818 20130819 20130820 20130821 20130822
do
	#let day_sum--
	#day=`date +%Y%m%d --date="$day_sum days ago"`
	for project in ${projects[@]}
	do
		echo "start script:" $(date +"%y-%m-%d %H:%M:%S")
		echo "###########################################"
		echo "$project merge log"
		allname=`echo $project | awk -F: '{print $1}'`
		projectname=`echo $project | awk -F: '{print $2}'`
		for nodedir in `find $access_log/$projectname-prod-* -type d`
		do
			nodename=`echo $nodedir | awk -F'/' '{print $5}'`
			if [ -f ${nodedir}/access-${day}.log.tar.gz ]
			then
				echo "-------------------------------------------"
				echo "${nodedir}"
				cd $nodedir
				tar -xvf access-${day}.log.tar.gz
			else
				echo "warning: ${nodedir}/access-${day}.log.tar.gz file not found"
                        fi
		done
		cd $access_log
		logfiles=`find . -path "${access_log}" -prune -o -name  access-$day-$allname-www.log -print | tr $'\n' ' '`
		if [[ -n $logfiles ]]
		then
			echo "-------------------------------------------"
			echo "merge log:$monitor_logs_dir/access-$day-$projectname-all.log"
			sort -m -t " " -k 4 -o  /opt/data1/access-$day-$projectname-all.log $logfiles

			cd $monitor_logs_dir
			echo "count review log:access-$day-$projectname-all.log"
			cat /opt/data1/access-$day-$projectname-all.log|grep -Ev "Googlebot|bingbot" |awk '{if($7~/act=review/ && $11!~/"-"/ || $7=="/ajax.php?act=add_goods_comment")print $6" "$7" "$9" "$11" "$(NF-2)}'> $monitor_logs_dir/review_$day-$projectname-all.txt
			rm -rf /opt/data1/access-$day-$projectname-all.log
		else
			echo "warning: access-$day-$allname-www.log file not found"
		fi
		cd $access_log
		find . -path "${access_log}" -prune -o -name  access-$day-*.log | xargs -I {} rm -f {}
        	echo "###########################################"
		echo "end script:" $(date +"%y-%m-%d %H:%M:%S")
		echo ""
	done
done

for project in ${projects[@]}
do
	allname=`echo $project | awk -F: '{print $1}'`
	projectname=`echo $project | awk -F: '{print $2}'`
        cd $monitor_logs_dir
	rm -f add_review_$projectname-tmp.txt access_review_$projectname-tmp.txt sum_review_$projectname-all.txt
	logfiles=`find . -path "${monitor_logs_dir}" -prune -o -name "review_*-all.txt" -print | tr $'\n' ' '`
	if [[ -n $logfiles ]]
	then
		sort -m -t " " -k 4 -o  $monitor_logs_dir/sum_review_$projectname-all.txt $logfiles
		cat $monitor_logs_dir/sum_review_$projectname-all.txt|grep "/ajax.php?act=add_goods_comment"|awk '{if($1~/"POST/)print $3" "$2}'|sort -n|uniq -c|sort -rn > $monitor_logs_dir/add_review_$projectname-tmp.txt
		cat $monitor_logs_dir/sum_review_$projectname-all.txt|grep -v "/ajax.php?act=add_goods_comment"|awk '{print $3" "$2}' > $monitor_logs_dir/access_review_$projectname-tmp.txt
	fi
done
