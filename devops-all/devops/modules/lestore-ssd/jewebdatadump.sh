#!/bin/bash

source $(dirname $0)/jedatabase.conf


tmpFile="/tmp/dumpout.log"
log="/var/log/dumpout.log"
dataDir="/var/mysqlwebdump"

if [ ! -d "$tmpFile" ]; then
        touch $tmpFile
fi

if [ ! -d "$log" ]; then
        touch $log
fi

if [ ! -d "$dataDir" ]; then
	mkdir -p $dataDir
fi

#clean up tmp file 
echo "" > $tmpFile

for database in ${databases[@]};do

	if [[ $database == 'jjshouse' || $database == 'jenjenhouse' || $database == 'azazie' ]] ; then

		date=$(date +%Y-%m-%d_%T)
		
		echo "" >> $tmpFile

		if [ ! -d "$dataDir/$database" ]; then
				mkdir -p $dataDir/$database
		fi
		
		rm -rf $dataDir/$database/*
		
		echo "$date $database dump out starting"
		echo "$date $database dump out starting" >> $tmpFile
		
		SLAVE_OPTIONS=" -h${host}  -u${user} -p${passwd} -P${port}"
		

		
		for table_name in $tables;do
			
			echo "use $database" > $dataDir/$database/$table_name.sql
			
			times=0
			
			mysqldump $SLAVE_OPTIONS --add-drop-table $database $table_name >> $dataDir/$database/$table_name.sql
			return_code=$?
			
			while [[ $return_code != 0 && $times < 3 ]]
			do
				mysqldump $SLAVE_OPTIONS --add-drop-table $database $table_name >> $dataDir/$database/$table_name.sql
				return_code=$?
			
				let "times++"
				echo "$(date +'%Y%m%d %T') retry to dump $table_name $times times."
			done

			if [[ $times == 3 ]]
			then
				echo "$date $database $table_name dump out error ...." >> $tmpFile
			fi
		done
		
		date=$(date +%Y-%m-%d_%T)
		echo "$date $database dump out end" >> $tmpFile
		echo "$date $database dump out end"
		
		echo $(date +%Y-%m-%d) >  $dataDir/$database/flag
	
	else 
		date=$(date +%Y-%m-%d_%T)

		if [ ! -d "$dataDir/$database" ]; then
				mkdir -p $dataDir/$database
		fi
		
		rm -rf $dataDir/$database/*
		
		echo "$date $database dump out starting"
		echo "$date $database dump out starting" >> $tmpFile
		
		SLAVE_OPTIONS=" -h${host}  -u${user} -p${passwd} -P${port}"
		
		table_list=`mysql $SLAVE_OPTIONS  -e "use $database;show tables"`
		
		for table_name in $table_list;do
		
			if [ "$table_name" != "Tables_in_$database" ];then 

				#echo  mysqldump $SLAVE_OPTIONS --add-drop-table $database $table_name
				echo "use $database" > $dataDir/$database/$table_name.sql
				times=0
			
				mysqldump $SLAVE_OPTIONS --add-drop-table $database $table_name >> $dataDir/$database/$table_name.sql
				return_code=$?
			
				while [[ $return_code != 0 && $times < 3 ]]
				do
					mysqldump $SLAVE_OPTIONS --add-drop-table $database $table_name >> $dataDir/$database/$table_name.sql
					return_code=$?
				
					let "times++"
					echo "$(date +'%Y%m%d %T') retry to dump $table_name $times times."
				done

				if [[ $times == 3 ]]
				then
					echo "$date $database $table_name dump out error ...." >> $tmpFile
				fi
				date=$(date +%Y-%m-%d_%T)
			fi
		done
		
		echo "$date $database dump out end" >> $tmpFile
		echo "$date $database dump out end"
		
		echo $(date +%Y-%m-%d) >  $dataDir/$database/flag
	fi	
	
done
	
cat $tmpFile >> $log

mail -s "报表数据导出日志" $mailTo < $tmpFile
