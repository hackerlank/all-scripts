#!/bin/bash

#!!!! s3cmd with mime fix for symlink
source $(dirname $0)/sr_rsync.conf

running=$(ps aux|grep $2|grep 'sh -c '|grep -v 'grep'|wc -l)
echo checking $2
echo running = $running
if [ "$running" -gt 5 ]; then
    echo "$(ps aux|grep $2|grep 'sh -c '|grep -v 'grep')"
    echo "already running $0 ($running) $(date +'%Y-%m-%d %T')"
    exit 1
fi

touch /mnt/data1/jjsimg/imggen/img_$(date +%Y-%m-%d_%H).log

log_num=$(find /mnt/data1/jjsimg/imggen/ -maxdepth 1 -type f -name 'img_*.log' | sort | wc -l )
if [ $log_num -le 1 ];  then
        echo 'Waiting for job...'
        exit
fi

for l in $(find /mnt/data1/jjsimg/imggen/ -maxdepth 1 -type f -name 'img_*.log' | sort | head -n 1); do
        if [ -n "$l" ]; then
                mark=$(date +'%M_%S')_${RANDOM}
                mv -v $l $l.${mark}.doing
                echo "Sync $l.${mark} at $(date +'%Y-%m-%d %T')..."
                #mkdir -vp $l.links
                i=0
                while read line; do
                        echo Uploading $i : $line ...
                        #lnk=$(echo -n $line | sed -r 's/img_[^\/]*\///' | sed -r "s,/mnt/data1/jjsimg/(upimg|imggen),$l.links,")
                        #mkdir -vp $(dirname $lnk)
                        #if [ ! -e "$lnk" ]; then
                        #       ln -vs $line $lnk
                        #fi
                        rel=$(echo -n $line | sed -r 's,/img_[^/]*/,,' | sed -r 's,/mnt/data1/jjsimg/(imgup/up_|upimg|imggen)[^/]*/,,')
                        s3cmd -v -c /var/job/img.s3cfg -F --cf-invalidate --acl-public --add-header="Cache-Control: public, max-age=1209600" $1 $line ${sync2s3_s3}${rel} #>> $l.output
                        ((i++))
                done < $l.${mark}.doing
                #s3cmd -d -c /home/hwang/img.s3cfg -F --acl-public --add-header="Cache-Control: public, max-age=1209600" -r $1 $l.links/ s3://jjshouseimg/upimg/
                #rs=$?
                #rm -fr $l.links
                #if [ $rs -eq 0 ]; then
                        mv ${l}.${mark}.doing ${l}.${mark}_done
                        echo "Sync $l.${mark} done at $(date +'%Y-%m-%d %T')."
                #fi
        fi
done;

find /mnt/data1/jjsimg/imggen/ -maxdepth 1 -mtime +3 -type f -name 'img_*_done' -exec rm -f {} \;
