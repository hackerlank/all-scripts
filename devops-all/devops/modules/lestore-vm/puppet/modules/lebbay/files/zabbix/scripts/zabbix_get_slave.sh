#!/bin/bash

source $(dirname $0)/ssd_slave.conf

# dbslavelist=(
# dbuser:dbpass@jjshousedbslave.cmyicoxavsy8.us-east-1.rds.amazonaws.com:3306
# dbuser:dbpass@jsdbslave2.cmyicoxavsy8.us-east-1.rds.amazonaws.com:3306
# dbuser:dbpass@jenjenhouseslave.cwxcj1w8quad.us-east-1.rds.amazonaws.com:3306
# )

length=${#dbslavelist[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
    printf '\n\t\t{'
    printf "\"{#DB_SLAVE_NAME}\":\"$(echo ${dbslavelist[$i]} | awk -F'@' '{print $2}' | cut -d'.' -f 1)\"}"
    if [ $i -lt $[$length-1] ];then
            printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"
