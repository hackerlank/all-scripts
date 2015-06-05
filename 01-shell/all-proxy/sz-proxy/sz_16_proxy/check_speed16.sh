#!/bin/bash

locate="suzhou16"
proxy_host=192.168.1.16
proxy_port=9005
UPLOAD_URL="https://work.digi800.com"

urls=(
"ticket#http://t.jjshouse.com/osticket/images/check_speed.jpg#true"
"cms#https://cms.jjshouse.com/resource/images/check_speed.jpg#true"
"editor#https://editor.jjshouse.com/themes/ouku/images/check_speed.jpg#true"
"gmail#https://ssl.gstatic.com/ui/v1/icons/mail/themes/pebbles/bg4_1920x1200.jpg#true"
"erp#https://ecadmin.digi800.com/admin/images/check_speed.jpg#false"
"mps#https://work.digi800.com/resource/images/admin/check_speed.jpg#false"
)

CURL="curl -k --connect-timeout 10 -m 30 -w %{time_appconnect}:%{time_total}:%{speed_download} -o /dev/null -uhttpproxy:090401 -s -L"
#CURL_PROXY="curl -k --connect-timeout 10 -m 30 --proxy ${proxy_host}:${proxy_port} -w %{time_appconnect}:%{time_total}:%{speed_download} -o /dev/null -uhttpproxy:090401 -s -L"
CURL_PROXY="curl -k --connect-timeout 10 -m 30 --socks5-hostname ${proxy_host}:${proxy_port} -w %{time_appconnect}:%{time_total}:%{speed_download} -o /dev/null -uhttpproxy:090401 -s -L"
CURL_UPLOAD="curl -k --connect-timeout 10 -m 30 -o /dev/null -uhttpproxy:090401"
day=$(date +%Y%m%d)
LOG="/var/log/proxy/check_speed_${day}.log"

for url in ${urls[@]}; do
        site=$(echo $url | awk -F'#' '{print $1}')
        loc=$(echo $url | awk -F'#' '{print $2}')
        use_proxy=$(echo $url | awk -F'#' '{print $3}')
        sleep $(echo $RANDOM%15 | bc)
        time=$(date "+%F %H:%M:%S")
        rand=$(date "+%s")
        if $use_proxy; then
                info=$(${CURL_PROXY} ${loc}?${rand} 2>/dev/null)
                r=$?
                #echo ${CURL_PROXY} ${loc}
        else
                info=$(${CURL} ${loc}?${rand} 2>/dev/null)
                r=$?
                #echo ${CURL} ${loc} 
        fi
        connect_time=$(echo $info | awk -F':' '{print $1}')
        if [ $r -ne 0 ]; then
                connect_time="2.500"
                response_time="7.000"
                speed="0.000"
                connect_flag="F"
        else
                total_time=$(echo $info | awk -F':' '{print $2}')
                response_time=$(echo $total_time-$connect_time| bc | sed -r 's/^(\.[0-9]*)/0\1/')
                speed=$(echo $info | awk -F':' '{print $3}')
                connect_flag="S"
        fi
        ${CURL_UPLOAD} "${UPLOAD_URL}/index.php?q=sysRespRecord/index/passCode/sysResponseRecord/sysType/${site}/sysLocation/${locate}/connectTime/${connect_time}/connectFlag/${connect_flag}/responseTime/${response_time}/optTime/$(echo $time | sed -r 's/\s+/%20/')" 2>/dev/null
        echo $locate $time $site $connect_time $response_time $speed
done

