#! /bin/bash

#---------------------------------------------------
# not used currently
#---------------------------------------------------
source $(dirname $0)/ssd_db.conf;

:<<EOF
By Zandy
2012-03-05
EOF

dbdir=/opt/data1/basedbdata/
trytimes=3

#brand_words
tables="
attribute
attribute_languages
buy_probability
category
category_attribute
category_display_order
category_erp
category_languages
category_relation
currency
currency_rate
fabric_color_gallery
gc_payment_product
goods
goods_attr
goods_attr_languages
goods_category
goods_gallery
goods_languages
goods_project
goods_project_config
goods_project_mapping
goods_size_chart
goods_size_chart_wrap
goods_style_black_white
goods_tag
goods_thumb
goods_thumb_config
goods_info_cache
goods_group
groups
style_group
languages
multilanguage
payment
payment_currency_config
payment_language
region
region_seo
shipping
shipping_method
shipping_method_area
shipping_method_fee
shipping_method_language
shop_config
style
style_languages
translation_map
sys_whitelist
"

[ -d $dbdir ] || mkdir -p $dbdir
cd $dbdir

timenow=$(date +'%Y-%m-%d %T')

mysqldump --skip-add-drop-table --no-create-info --replace -h$dbhost -u$dbuser -p$dbpass $dbname $tables > basedbdata.sql
if [ $? -gt 0 ]; then
	echo "jjshouse mysqldump failed at $timenow."
	echo "jjshouse mysqldump failed at $timenow." | mail -s "jjshouse mysqldump failed at $timenow." yzhang@i9i8.com
	exit 1
fi

echo $(md5sum basedbdata.sql|awk '{print $1}') > basedbdata_checksum
tar zcf basedbdata.sql.tar.gz basedbdata.sql basedbdata_checksum
rm basedbdata.sql basedbdata_checksum -rf

i=0
rst=1
while [ $i -lt $trytimes ]; do
	#jen
	rsync --timeout=10 -z --progress -e "ssh -p32200 -o StrictHostKeyChecking=no" basedbdata.sql.tar.gz syncer@23.21.252.181:$dbdir
	if [ $? -eq 0 ]; then
		rst=0
		break
	fi
	let i=$i+1
done

#i=0
#rst=1
#while [ $i -lt $trytimes ]; do
#	#fe-test
#	rsync --timeout=10 -z --progress -e "ssh -p32200 -o StrictHostKeyChecking=no" basedbdata.sql.tar.gz syncer@184.73.222.221:$dbdir
#	if [ $? -eq 0 ]; then
#		rst=0
#		break
#	fi
#	let i=$i+1
#done

if [ $rst -eq 0 ]; then
	rst="OK"
else
	rst="FAILED"
fi

echo "Compleated at $timenow. Result is $rst."
