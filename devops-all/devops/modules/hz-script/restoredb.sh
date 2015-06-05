#!/bin/bash
echo "$(date +"%Y%m%d %T") restore db start"
#source_file=`ssh syncer@192.168.0.2 -p12001 "ls -ltr /var/opt/dbdata/ | grep tar | tail -n 1" | awk '{print $9}'`
source_file=`ssh -i /root/.ssh/id_syncer syncer@192.168.0.2 -p12001 "cat /var/opt/dbdata/js_mysqlbak_ok"`
back_dir="/var/backup/mysql/js/"
version_file="jsdb_version"


cd $back_dir
touch $version_file
version=`cat $version_file`

if [[ $version == $source_file ]]
then
    exit 0
fi

try_times=1
file_md5=''
right_md5='aaa'

while [[ $file_md5 != $right_md5 && $try_times -le 1 ]]
do
echo "$(date +"%Y%m%d %T") download file $source_file: ${try_times}"
scp -i /root/.ssh/id_syncer -P12001 syncer@192.168.0.2:/var/opt/dbdata/${source_file} $back_dir

echo "tar ${source_file}"
tar xzf ${source_file}

#sql_file=`ls -ltr | grep -vE 'tar|checksum' | grep "sql" |tail -n 1 | awk '{print $NF}'`
sql_file=`echo $source_file | cut -d"." -f1,2`

echo "md5 $sql_file"
file_md5=`md5sum $sql_file | awk '{print $1}'`
right_md5=`cat js_checksum`
try_times=$((try_times+1))
done

echo $file_md5, $right_md5
if [[ $file_md5 == $right_md5 ]]
then
ls -lh
sed -i 's/USING BTREE//' $sql_file
mysql xxx < $sql_file
rm -rf $sql_file $source_file checksum
echo $source_file > $version_file
else
echo error checksum $0 | mail -s "[Sev-1] restore db error" "ychen@leqee.com"
echo error checksum $0 | mail -s "[Sev-1] restore db error" "alarm@i9i8.com"
fi

echo "$(date +"%Y%m%d %T") restore db end"
exit
