#!/bin/bash

###
# Mutual exclusive execution
###
chushu=$1
yushu=$2

source $(dirname $0)/ssh-agent.sh
source $(dirname $0)/sr_thumb.conf
source $(dirname $0)/common_func.sh

label="73b9118abe628e3410c5724b88f70afd_${chushu}_${yushu}"
running=$(ps aux|grep $label|grep -v 'grep'|wc -l)
if [ "$running" -gt 2 ]; then
        echo "$(ps aux|grep $label|grep 'bash '|grep -v 'grep')"
        echo "already running $0  $label($running) $(date +'%Y-%m-%d %T')"
        exit 1
fi

###
# Global configuration
###
WATERMARK_PATH='/var/job/watermarks'
SRC_PATH='/opt/data1/jjsimg'
DEST_PATH='/mnt/data1/jjsimg/imgup'
LOG_PATH='/mnt/data1/jjsimg/imggen'
TMP_PATH='/mnt/data1/jjsimg/tmp'
MATERIAL_PATH='/var/job/materials'
#fetch_host=syncer@ec2-54-236-79-188.compute-1.amazonaws.com
#fetch_port=38022

mysql_ro="mysql --skip-column-names --default-character-set=utf8 -h$dbhost_ro -u$dbuser -p$dbpass $dbname"
mysql="mysql --skip-column-names --default-character-set=utf8 -h$dbhost -u$dbuser -p$dbpass $dbname"
#fetch from js-cms: ec2-50-16-230-173.compute-1.amazonaws.com
#fetch_port=32200


mkdir -p ${TMP_PATH}
logname=img_$(date +%F_%H)
mkdir -p $LOG_PATH
upimglog="$LOG_PATH/${logname}.log"
updir=up_$(date +%F)
upimgdir="$DEST_PATH/${updir}"
mkdir -p ${upimgdir}

function mark_gallery_not_found(){
	goods_id=$1
	thumb_name=$2
	cat <<SQL_END | $mysql
UPDATE goods_thumb SET has_done = -1 WHERE goods_id = '$goods_id' AND thumb_name = '$thumb_name' AND has_done = 0 LIMIT 1
SQL_END
}

function process_banner(){
    row=$1

    goods_id=$(echo "$row"|awk -F"\t" '{print $1}')
    echo $goods_id|grep -E '^[0-9]+$' > /dev/null
    if [ $? -eq 0 ]; then
        img_url=$(echo "$row"|awk -F"\t" '{print $2}')
        img_original=$(echo "$row"|awk -F"\t" '{print $3}')
        img_type=$(echo "$row"|awk -F"\t" '{print $4}')
        img_id=$(echo "$row"|awk -F"\t" '{print $5}')

		# process normal image
		if [ "$img_type" != 'banner' ]; then
			gallery="$SRC_PATH/$img_original"
			if [ -z "$gallery1" ]; then
				# mark galleries to be built
				check_and_fetch $gallery
				test -f	$gallery && gallery1=$gallery
			elif [ -z "$gallery2" ]; then
				# check size
				size1=$(identify "$gallery1" | head -n 1 | awk '{print $3}')
				size2=$(identify "$gallery"  | head -n 1 | awk '{print $3}')
				if [ "$size1" = "$size2" ]; then 
					# mark galleries to be built
					check_and_fetch $gallery
					test -f	$gallery && gallery2=$gallery
				fi
			fi
		# process banner
		elif [ -n "$gallery1" ]; then
			# merge galleries into one banner
			echo "Merging $goods_id ...";

			# prepare materials
			size=$(identify "$gallery1" | head -n 1 | awk '{print $3}')
            x=$(echo $size|awk -F "x" '{print $1}')
            y=$(echo $size|awk -F "x" '{print $2}')

			# create banner image
			temp_file=${TMP_PATH}/tmp_${chushu}_${yushu}.png
			touch $temp_file

			# build image according to gallery number and size
			if [ -n "$gallery2" ]; then
				# two galleries
				if [ "$x" -eq "$y" ]; then
					background=${MATERIAL_PATH}/accessory_banner_bg.png
					img_comp1=557x557+0+35
					img_comp2=557x557+602+35
				else 
					background=${MATERIAL_PATH}/dress_banner_bg.png
					img_comp1=458x628+94+0
					img_comp2=458x628+647+0
				fi
				convert -size 1200x628 xc:gray $temp_file
				composite -geometry 1200x628+0+0  $background $temp_file $temp_file
				composite -geometry $img_comp1    $gallery1 $temp_file $temp_file
				composite -geometry $img_comp2    $gallery2 $temp_file $temp_file
			else
				# one gallery
				convert -size 1200x628 xc:white $temp_file
				if [ "$x" -eq "$y" ]; then
					composite -geometry 556x556+322+35  $gallery1 $temp_file $temp_file
				else
					composite -geometry 458x628+371+0   $gallery1 $temp_file $temp_file
				fi
			fi

			# move banner to destination
			dest_file_name=`md5sum ${temp_file} | cut -d' ' -f1`
			dest_last_4=${dest_file_name: -4:2}
			dest_last_2=${dest_file_name: -2:2}
			dest_file=${upimgdir}/$thumb_name/$dest_last_4/$dest_last_2/${dest_file_name}.jpg
			dest_dir=${dest_file%/*}
			banner_img_url=$dest_last_4/$dest_last_2/${dest_file_name}.jpg
			test -d "$dest_dir" || (mkdir -p "$dest_dir"; chown -R www-data.www-data $dest_dir)
			mv $temp_file $dest_file
            chown www-data.www-data $dest_file

			# clean marked galleries.
			gallery1=''
			gallery2=''

			# update database records
            cat <<SQL_END | $mysql
UPDATE goods_gallery SET img_url = '$banner_img_url' WHERE img_id = '$img_id' LIMIT 1
SQL_END
            cat <<SQL_END | $mysql
UPDATE goods_thumb SET has_done = 1 WHERE goods_id = '$goods_id' AND thumb_name = '$thumb_name' AND has_done = 0 LIMIT 1
SQL_END

			# add log records
			echo $dest_file >> $upimglog
		else
			# alert
			echo "ALERT: no galleries.";
			echo $row
			# clean marked galleries.
            mark_gallery_not_found $goods_id $thumb_name
			gallery1=''
			gallery2=''
		fi
    else
        echo "ERROR: parsing goods_id from row"
        echo $row
    fi
}

function process_facebook_banner(){
    limit=$1
    thread_count=$2
    thread_no=$3
	cat <<SQL_END  | $mysql_ro | while read row; do
SELECT gg.goods_id, gg.img_url, gg.img_original, gg.img_type, gg.img_id 
FROM goods_gallery gg
WHERE gg.is_display = 1 and gg.is_delete = 0
AND gg.goods_id in ( SELECT * FROM
(
SELECT goods_id
FROM goods_thumb
WHERE has_done = 0
AND thumb_name = '$thumb_name'
AND goods_thumb_id % $thread_count = $thread_no
LIMIT $limit
) as T)
ORDER BY gg.goods_id, FIELD(gg.img_type, 'photo', 'old', 'ps', 'design', 'sample', 'no', 'banner'), gg.sequence
SQL_END
        if [ "$iii" = "" ]; then
                iii=0
        fi
        (( iii++ ))
        echo -n "[$iii] "
		process_banner "$row"
    done;
}

function process_facebook_banner_by_goodsids(){
	goodsIds=$1
	cat <<SQL_END  | $mysql_ro | while read row; do
SELECT gg.goods_id, gg.img_url, gg.img_original, gg.img_type, gg.img_id 
FROM goods_gallery gg
WHERE gg.is_display = 1 and gg.is_delete = 0
AND gg.goods_id in ($goodsIds)
ORDER BY gg.goods_id, FIELD(gg.img_type, 'photo', 'old', 'ps', 'design', 'sample', 'no', 'banner'), gg.sequence
SQL_END
        if [ "$iii" = "" ]; then
                iii=0
        fi
        (( iii++ ))
        echo -n "[$iii] "
		process_banner "$row"
    done;
}

gallery1=''
gallery2=''
thumb_name='l1200'
process_facebook_banner 500 $chushu $yushu

