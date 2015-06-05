#!/bin/bash

oldlog='/opt/data1/access_log'
newlog='/opt/data1/merge_log'

projects=("jjshouse:js jenjenhouse:je amormoda2:am dressfirst:df vbridal:vb jennyjoseph:ph mjjshouse:mjs mjenjenhouse:mje")

for project in ${projects[@]}
do
    echo "start script:" $(date +"%y-%m-%d %H:%M:%S")
    echo "###########################################" 
    echo "$project clean log"

    projectname=`echo $project | awk -F: '{print $2}'`	

    if [ -f $newlog/$projectname/synced_logs.md5 ]; then
        mv $newlog/$projectname/synced_logs.md5 $newlog/$projectname/synced_logs.md5.doing

        join <(awk '{print $2}' $newlog/$projectname/synced_logs.md5.doing | sort) \
            <(find $newlog/$projectname/*.tar.gz -mtime +10 | sort) | xargs -I {} sudo rm -f {}

        comm -23 <(sort -k 2 $newlog/$projectname/access_logs.md5) <(sort -k 2 $newlog/$projectname/synced_logs.md5.doing) > $newlog/$projectname/access_logs.md5.cleaned
        mv -f $newlog/$projectname/access_logs.md5.cleaned $newlog/$projectname/access_logs.md5

        rm -f $newlog/$projectname/synced_logs.md5.doing
    fi

    echo "###########################################"
    echo "stop script:" $(date +"%y-%m-%d %H:%M:%S")
done

