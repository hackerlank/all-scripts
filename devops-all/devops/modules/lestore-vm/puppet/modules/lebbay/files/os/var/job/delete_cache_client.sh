#! /bin/bash

:<<EOF
By Zandy
2012-04-11
delete cache client
EOF

export runmaxtimes=130
export runtimes=0

while :; do

if [ -f /tmp/delete_cache_list ]; then
        cat /tmp/delete_cache_list | while read f; do
                echo "$f"|grep 'templates'
                b=$?
                echo "$f"|grep 'var/tpl'
                c=$?
                echo "$f"|grep 'cache'
                d=$?
                echo "$f"|grep 'ztec'
                e=$?
                echo "$f"|grep 'var/twig'
                t=$?
                if [ $b -eq 0 -o $c -eq 0 -o $d -eq 0 -o $t -eq 0 ]; then
                        if [ ${#f} -gt 20 ]; then
                                dir=/opt/data1/tmp/$RANDOM
                                if [ ! -d $dir ]; then mkdir -p $dir; fi
                                if [ $e -eq 0 ]; then
                                        for i in `find $f -type f`
                                        do
                                                mv -f $i $dir
                                                echo "#mv -f $f $dir"
                                        done
                                else
                                        mv -f $f $dir
                                        echo "#mv -f $f $dir"
                                fi
                        fi
                fi
                #wget xxx
        done

        rm -f /tmp/delete_cache_list

        echo "$0 done at $(date +'%Y-%m-%d %T')"
else
        running=$(ps aux|grep fa8b1f67815b8960c2ecf2b77f4e7d2a|awk '{if($2!='"$$"' && $2!='"$PPID"'){print $0}}'|grep 'sh -c '|grep -v 'grep'|wc -l)
        if [ "$running" -gt 0 ]; then
                echo "$(ps aux|grep fa8b1f67815b8960c2ecf2b77f4e7d2a|awk '{if($2!='\"$$\"' && $2!='\"$PPID\"'){print $0}}'|grep 'sh -c '|grep -v 'grep')"
                echo "already running $0 ($running) current script pid=$$ ppid=$PPID $(date +'%Y-%m-%d %T')"
                exit 1
        else
                echo "start run at $(date +'%Y-%m-%d %T')"
        fi

        dirx=/opt/data1/tmp/*
        for i in `find $dirx -maxdepth 0 -type d 2>/dev/null`
        do
                for n in `find $i/* -maxdepth 0 -type d 2>/dev/null`
                do
                        rm -rf $n
                        echo "#rm -rf $n"
                        sleep 5
                done
                rm -rf $i
        done

        sleep 5

        runtimes=$(( runtimes+1 ))
        if [ $runtimes -gt $runmaxtimes ]; then
                echo "exit normally at $(date +'%Y-%m-%d %T')"
                exit 0
        fi
fi

done
