#!/bin/bash

source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/logman_config.sh

if [[ -z $1 ]]
then
         days=`date +%Y%m%d --date='1 days ago'`
else
         days=$@
fi

oldlog='/opt/data1/access_log'
newlog='/opt/data1/merge_log'

projects=("${backup_projects}")

for day in $days
do
        for project in ${projects[@]}
        do
                echo "start script:" $(date +"%y-%m-%d %H:%M:%S")
                echo "###########################################"
                echo "$project merge log"
                allname=`echo $project | awk -F: '{print $1}'`
                projectname=`echo $project | awk -F: '{print $2}'`
                mkdir -p $newlog/$projectname
                for nodedir in `find $oldlog/$projectname-prod-* -type d`
                do
                        nodename=`echo $nodedir | awk -F'/' '{print $5}'`
                        if [ -f ${nodedir}/access-${day}-$allname.log.tar.gz ]
                        then
                                echo "-------------------------------------------"
                                echo "${nodedir}"
                                cd $nodedir
                                tar -xvf access-${day}-$allname.log.tar.gz
                                #cp -rf ${nodedir}/access-${day}-$allname.log.tar.gz $newlog/$projectname/access-$day-$allname-$nodename.log.tar.gz
                                #rm -f $newlog/$projectname/access-$day-$allname-$nodename.log.tar.gz
                                ln -s ${nodedir}/access-${day}-$allname.log.tar.gz $newlog/$projectname/access-$day-$allname-$nodename.log.tar.gz
                                md5sum $newlog/$projectname/access-$day-$allname-$nodename.log.tar.gz >> $newlog/$projectname/access_logs.md5
                        fi
                done
                cd $oldlog
                logfiles=`find . -path "${oldlog}" -prune -o -name  access-$day-$allname-www.log -print | tr $'\n' ' '`
                if [[ -n $logfiles ]]
                then
                        echo "-------------------------------------------"
                        echo "sort log:$newlog/$projectname/access-$day-$projectname-all.log"
                        sort -m -t " " -k 4 -o  $newlog/$projectname/access-$day-$projectname-all.log $logfiles
                        echo "tar log:$newlog/$projectname/access-$day-$projectname-all.log.tar.gz"
                        cd $newlog/$projectname
                        /usr/local/bin/rar a access-$day-$projectname-all.log.rar access-$day-$projectname-all.log
                        tar -czf access-$day-$projectname-all.log.tar.gz access-$day-$projectname-all.log.rar
                        md5sum $newlog/$projectname/access-$day-$projectname-all.log.tar.gz >> $newlog/$projectname/access_logs.md5
                        rm -rf access-$day-$projectname-all.log
                else
                        echo "warning: access-$day-$allname-www.log file not found"
                fi
                cd $oldlog
                find . -path "${oldlog}" -prune -o -name  access-$day-*.log | xargs -I {} rm -f {}
                echo "###########################################"
                echo "end script:" $(date +"%y-%m-%d %H:%M:%S")
                echo ""
        done
done
