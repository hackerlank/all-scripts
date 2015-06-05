#!/bin/bash

mail_list_name=$1
mark=$2
title=$3
body=$4

if [ "$mail_list_name" = "test" ]; then
    mark='Sev-T';
else
    if [ -f $(dirname $0)/stage ]; then
        source $(dirname $0)/stage
    fi

    if [ "$stage" == "pre" ]; then
        mark=$(echo $mark | sed -r 's,Sev-,Sev-P-,')
    fi
fi

warn_mail_list="yzhang@i9i8.com lyu@i9i8.com"
code_5xx_mail_list="alarm@i9i8.com" 
test_mail_list="hwang@i9i8.com yzhang@i9i8.com bwzhang@i9i8.com lyu@i9i8.com"
prod_mail_list="alarm@i9i8.com"
debug_mail_list="hwang@i9i8.com yzhang@i9i8.com bwzhang@i9i8.com lyu@i9i8.com"
pre_mail_list="hwang@i9i8.com yzhang@i9i8.com bwzhang@i9i8.com lyu@i9i8.com"

if [[ -f $(dirname $0)/host_name.conf ]]
then
        source $(dirname $0)/host_name.conf
else
        host_name=$(hostname)
fi
publicdns=$(curl http://169.254.169.254/latest/meta-data/public-hostname);

fullbody="[TIME]:`date +'%Y-%m-%d %H:%M:%S'`\n[FROM]: $host_name@$publicdns `hostname`\n\n$body"
echo -e "Sending alert:\n$fullbody"

eval "export mail_list=\$$(echo $mail_list_name)_mail_list"
echo -e "$fullbody" | mail -s "[$mark] $title @$host_name" $mail_list
