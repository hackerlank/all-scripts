#!/bin/bash

access_log='/opt/data1/nginxlogs/'
projects=("${count_projects}")
monitor_logs_dir='/var/log/count_image_upload'
if [ ! -d $monitor_logs_dir ]
then
	mkdir -p $monitor_logs_dir
fi

for day in 20130815 20130816 20130817 20130818 20130819 20130820 20130821 20130822
do
	for project in ${projects[@]}
	do
		echo "start script:" $(date +"%y-%m-%d %H:%M:%S")
		echo "###########################################"
		echo "$project tar log"
		allname=`echo $project | awk -F: '{print $1}'`
		projectname=`echo $project | awk -F: '{print $2}'`
		if [ -f ${access_log}/access-${day}.log.tar.gz ]
		then
			echo "-------------------------------------------"
			echo "${access_log}"
			cd $access_log
			tar -xvf access-${day}.log.tar.gz

			echo "-------------------------------------------"
			echo "count image upload log:access-$day-$allname-www.log"
			cat $access_log/access-$day-$allname-www.log|grep -Ev "Googlebot|bingbot"|awk '{if($7~/ticket.php/ && $11~/up.jjshouse.com/) print $6" "$7" "$9" "$11" "$(NF-2)}' > $monitor_logs_dir/image_upload_$day-$allname-www.txt
			rm -rf $access_log/access-$day-$allname-www.log
		else
			echo "warning: ${access_log}/access-${day}.log.tar.gz file not found"
		fi
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
	rm -f image_upload_$allname-tmp.txt sum_image_upload_$allname-www.txt
	logfiles=`find . -path "${monitor_logs_dir}" -prune -o -name "image_upload_*-www.txt" -print | tr $'\n' ' '`
	if [[ -n $logfiles ]]
	then
		sort -m -t " " -k 4 -o  $monitor_logs_dir/sum_image_upload_$allname-www.txt $logfiles
		cat $monitor_logs_dir/sum_image_upload_$allname-www.txt|awk '{print $3" "$4}'|sort -n|uniq -c|sort -rn > $monitor_logs_dir/image_upload_$allname-tmp.txt
	fi
done
