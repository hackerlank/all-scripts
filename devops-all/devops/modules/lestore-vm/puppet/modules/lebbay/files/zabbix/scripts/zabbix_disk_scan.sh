#!/bin/bash
#diskstats different with iostat
#diskarray=(`cat /proc/diskstats |grep -E "\bsd[abcdefghijklmnopqrstuvwxyz][0-9]*\b|\bxvd[abcdefghijklmnopqrstuvwxyz][0-9]*\b"|awk '{print $3}'|sort|uniq 2>/dev/null`)
#need command "iostat"
type "iostat" >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "iostat: not found"
	exit 1
fi
diskarray=(`iostat -d 1 1|iostat -d 1 1|grep -E "^sd[abcdefghijklmnopqrstuvwxyz][0-9]*|^xvd[abcdefghijklmnopqrstuvwxyz][0-9]*"|awk '{print $1}'|sort|uniq 2>/dev/null`)
length=${#diskarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
        printf '\n\t\t{'
        printf "\"{#DISK_NAME}\":\"${diskarray[$i]}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
