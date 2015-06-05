#!/bin/bash

day_sum=40
monitor_logs_dir='/var/log/monitor'
access_log='/opt/data1/access_log'
projects=("${count_projects}")

if [ ! -d $monitor_logs_dir ]
then
	mkdir -p $monitor_logs_dir
fi

while [ $day_sum -ne 1 ]
do
        let day_sum--
        day=`date +%Y%m%d --date="$day_sum days ago"`
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
                        echo "count filter log:access-$day-$projectname-all.log"
                        cat /opt/data1/access-$day-$projectname-all.log|grep -Ev "ajax.php|Googlebot|bingbot" |awk '{print $7}'|grep -E "_p[0-9]{1,}i[0-9]{1,}"|grep -Eo "p[0-9]{1,}i[0-9]{1,}" > $monitor_logs_dir/filter_$day-$projectname-all.txt
			cat $monitor_logs_dir/filter_$day-$projectname-all.txt |sort -r |uniq -c|sort -rn > $monitor_logs_dir/sum_filter_$day-$projectname-all.txt
                        rm -rf /opt/data1/access-$day-$projectname-all.log
                else
                        echo "warning: access-$day-$allname-www.log file not found"
                fi
                cd $access_log
                find . -path "${access_log}" -prune -o -name  access-${day}-*.log | xargs -I {} rm -f {}
                echo "###########################################"
                echo "end script:" $(date +"%y-%m-%d %H:%M:%S")
                echo ""
        done
done


for project in ${projects[@]}
do
        allname=`echo $project | awk -F: '{print $1}'`
        projectname=`echo $project | awk -F: '{print $2}'`
        echo > sum_filter_$projectname-all.txt
        echo > filter_$projectname-tmp.txt
        cd $monitor_logs_dir
        logfiles=`find . -path "${monitor_logs_dir}" -prune -o -name "filter_*-all.txt" -print | tr $'\n' ' '`
	if [[ -n $logfiles ]]
	then
        	sort -m -t " " -k 4 -o  $monitor_logs_dir/sum_filter_$projectname-all.txt $logfiles
        	echo "点击次数  URL" >> $monitor_logs_dir/filter_$projectname-tmp.txt
        	cat $monitor_logs_dir/sum_filter_$projectname-all.txt|sed 's/[ ]*$//g'|grep -v ^$|sort -r |uniq -c|sort -rn|awk '{if($1>=2) print $0}' >> $monitor_logs_dir/filter_$projectname-tmp.txt
	fi

done
