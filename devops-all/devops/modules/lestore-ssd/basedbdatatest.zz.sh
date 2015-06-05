#! /bin/bash
source $(dirname $0)/ssd_db.conf;

:<<EOF
By Zandy
2012-03-05
EOF

locktables="--lock-tables=false"

dbdir=/opt/data1/basedbdata/
#filename=${dbshortname}_basedbdatatest
filename=basedbdatatest
trytimes=3

tables="
admin_user
attribute
attribute_languages
attribute_review
brand_words
buy_probability
category
category_attribute
category_display_order
category_erp
category_languages
category_relation
cms_article
cms_article_content
cms_category
cms_editor_link
cms_editor_link_class
cms_page
currency
currency_rate
project_currency
dress_length
fabric_color_gallery
gc_payment_product
goods
goods_attr
goods_attr_languages
goods_category
goods_craft_zz
goods_display_order_recommendation
goods_extension
goods_for_rent
goods_gallery
goods_languages
goods_list_item
goods_name_prefix
goods_project
goods_project_config
goods_project_mapping
goods_sidebar_recommandation
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
newsletters
ost_api_key
ost_category
ost_config
ost_department
ost_email_template
ost_groups
ost_help_topic
ost_kb_premade
ost_question_email_template
ost_question_type
ost_staff
ost_ticket_priority
ost_timezone
payment
payment_config
payment_currency_config
payment_language
product_tags
product_tags_description_template
product_tags_info
product_tags_project_mapping
product_tags_relevance
product_tags_words
product_tags_word_mapping
region
region_seo
region_tax
shipping
shipping_method
shipping_method_area
shipping_method_fee
shipping_method_language
shop_config
style
style_gallery
style_languages
sys_access_pca
sys_account
sys_department
sys_permission
sys_role
sys_user_role
sys_whitelist
tmp_c_attr_goods
tmp_c_attr_goods_filter
tmp_c_goods_no
tmp_c_goods_no_filter
translation_map
weekly_deal
keyword_url
feature
feature_config
img_attr
one_row
unfamiliar_color
goods_girl_names
"

[ -d $dbdir ] || mkdir -p $dbdir
cd $dbdir

timenow=$(date +'%Y-%m-%d %T')

create_tables=$(mysql -h$dbhost -u$dbuser -p$dbpass $dbname -e "show tables from ${dbname}"|awk '!/Tables_in_/ && !/^newsletter_send_email/ && !/^payment_config_bak/ && !/^brand_words_bak/ && !/^sys_whitelist_bak/ && !/.*_editing/ && !/newsletter_filter_.*/')

mysqldump $locktables --add-drop-table --no-data -h$dbhost -u$dbuser -p$dbpass $dbname $create_tables > ${filename}.sql
if [ $? -gt 0 ]; then
	echo "${dbname} mysqldump ${filename} failed at $timenow."
	echo "${dbname} mysqldump ${filename} failed at $timenow." | mail -s "${dbname} mysqldump ${filename} failed at $timenow." ${basedbtest_email}
	exit 1
fi
#mysqldump --skip-add-drop-table --no-create-info --replace -h$dbhost -u$dbuser -p$dbpass $dbname $tables >> ${filename}.sql
mysqldump $locktables --skip-add-drop-table --no-create-info --replace -h$dbhost -u$dbuser -p$dbpass $dbname $tables >> ${filename}.sql
if [ $? -gt 0 ]; then
	echo "${dbname} mysqldump ${filename} failed at $timenow. 2"
	echo "${dbname} mysqldump ${filename} failed at $timenow. 2" | mail -s "${dbname} mysqldump ${filename} failed at $timenow. 2" ${basedbtest_email}
	exit 1
fi

cat <<SQL_END >> ${filename}.sql
UPDATE admin_user SET password = md5('lb123456');
UPDATE ost_staff SET passwd = md5('lb123456');
UPDATE sys_account SET acct_pswd = md5('lb123456');
UPDATE sys_account SET acct_disable = 0 where acct_alias in ('yzhang', 'mxu2');
INSERT INTO sys_whitelist (whitelist_id, ip, info, type) VALUES (NULL, '127.0.0.1', 'local dev env', '');
delete from feature_config where feature_id != 2 and project = 'JenJenHouse';

insert into feature_config(feature_id, project, name, config, active, is_delete)
select feature_id, 'JenJenHouse', name, config, active, is_delete from feature_config where feature_id not in (1, 2, 27) and project = 'JJsHouse';

ALTER TABLE users AUTO_INCREMENT = 1;
INSERT IGNORE INTO users(userId, user_name, password, email, track_id, reg_recommender, reg_site_name, user_realname, user_mobile, zipcode, user_address, reg_source, reg_province)
VALUES(md5('00000000'), 'firstman', md5('firstman'), 'firstman@tetx.com', '', '$site', '$site', 'firstman', '1234567', '111222', '', 0, 0);
SQL_END


echo $(md5sum ${filename}.sql|awk '{print $1}') > ${filename}_checksum
tar zcf ${filename}.sql.tar.gz ${filename}.sql ${filename}_checksum

rm ${filename}.sql ${filename}_checksum -rf

#i=0
#rst=1
#while [ $i -lt $trytimes ]; do
#	#rsync --timeout=10 -z --progress -e "ssh -p32200 -o StrictHostKeyChecking=no" ${filename}.sql.tar.gz syncer@23.21.252.181:$dbdir
#	#fe-test
#	rsync --timeout=10 -z --progress -e "ssh -p32200 -o StrictHostKeyChecking=no" ${filename}.sql.tar.gz syncer@${fe_host}:$dbdir
#	if [ $? -eq 0 ]; then
#		rst=0
#		break
#	fi
#	let i=$i+1
#done
#
#if [ $rst -eq 0 ]; then
#	rst="OK"
#else
#	rst="FAILED"
#fi
#
#echo "Compleated at $timenow. Result is $rst for fe-test."

i=0
rst=1
while [ $i -lt $trytimes ]; do
	#hwangtest
	#rsync --timeout=10 -z --progress -e "ssh -o StrictHostKeyChecking=no -i /root/.ssh/hwangtest.id" ${filename}.sql.tar.gz ec2-user@ec2-174-129-51-197.compute-1.amazonaws.com:~/rsync_root/testdb
	rsync --timeout=10 -z --progress -e "ssh -o StrictHostKeyChecking=no -i /home/ec2-user/.awstools/keys/test_rsa -p38022" ${filename}.sql.tar.gz ec2-user@${repo_host}:~/rsync_root/testdb/$dbname/
	if [ $? -eq 0 ]; then
		rst=0
		break
	fi
	let i=$i+1
done

if [ $rst -eq 0 ]; then
	rst="OK"
else
	rst="FAILED"
fi

echo "Compleated at $timenow. Result is $rst for hwangtest."
