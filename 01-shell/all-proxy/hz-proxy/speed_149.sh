#!/bin/bash

proxy_host=192.168.0.149
proxy_port=9003
UPLOAD_URL="https://work.aaasea.com"

urls=(
"ticket#https://t.jjshouse.com/osticket/images/check_speed.jpg#true"
"cms#https://cms.jjshouse.com/resource/images/check_speed.jpg#true"
"editor#https://editor.jjshouse.com/themes/ouku/images/check_speed.jpg#true"
"gmail#https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg#true"
)

CURL="curl -k --connect-timeout 10 -m 30 -w %{time_appconnect}:%{time_total}:%{speed_download} -o /dev/null -ubcheng:cb86005649 -s -L"
CURL_PROXY="curl -k --connect-timeout 10 -m 30 --proxy ${proxy_host}:${proxy_port} -w %{time_appconnect}:%{time_total}:%{speed_download} -o /dev/null -ubcheng:cb86005649 -s -L"
day=$(date +%Y%m%d)

for url in ${urls[@]}; do
        site=$(echo $url | awk -F'#' '{print $1}')
        loc=$(echo $url | awk -F'#' '{print $2}')
        use_proxy=$(echo $url | awk -F'#' '{print $3}')
	time=$(date "+%F %H:%M:%S")
        if $use_proxy; then
                info=$(${CURL_PROXY} ${loc} 2>/dev/null)
                #echo ${CURL_PROXY} ${loc}
        else
                info=$(${CURL} ${loc} 2>/dev/null)
                #echo ${CURL} ${loc} 
        fi
        connect_time=$(echo $info | awk -F':' '{print $1}')
        if [ "${connect_time}" == "0.000" ]; then
                connect_time="35.000"
                response_time="35.000"
                speed="0.000"
        else
                total_time=$(echo $info | awk -F':' '{print $2}')
                response_time=$(echo $total_time-$connect_time| bc | sed -r 's/^(\.[0-9]*)/0\1/')
                speed=$(echo $info | awk -F':' '{print $3}')
        fi
        echo $time $site $connect_time $response_time $speed | tee -a /home/bcheng/log/speed_149.log
done
