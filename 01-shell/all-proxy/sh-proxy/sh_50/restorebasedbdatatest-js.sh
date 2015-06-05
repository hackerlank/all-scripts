#!/bin/bash

dbhost=localhost
dbuser=dbuser0114
dbpass=dbpswd0114
dbname=jjshouse
#dbname=jjshouse_work
#dbname=jenjenhouse

dbdir=/var/opt/basedbdata/

[ -d $dbdir ] || mkdir -p $dbdir
cd $dbdir

timenow=$(date +'%Y-%m-%d %T')

#rm -f basedbdatatest.sql tmptest.sql
rm -f basedbdatatest.sql 
if [ -f basedbdatatest.sql -o -f tmptest.sql ]; then
	echo "restoring... and exit -- $timenow"
	echo "restoring... and exit -- $timenow" | mail -s "jenjenhouse basedbdatatest restoring at $timenow" yzhang@i9i8.com
	exit 1
fi

tar zxf basedbdatatest.sql.tar.gz

if [ $? -gt 0 ]; then
	echo "jjshouse basedbdatatest restoring: untar failed at $timenow."
	echo "jjshouse basedbdatatest restoring: untar failed at $timenow." | mail -s "jjshouse basedbdatatest restoring: untar failed at $timenow." lyu@i9i8.com
	exit 1
fi

checksum=$(md5sum basedbdatatest.sql|awk '{print $1}')

rst=1
if [ "$checksum" = "$(cat basedbdatatest_checksum)" ]; then
	#echo "use $dbname;" > tmptest.sql
	#cat basedbdatatest.sql >> tmptest.sql
	#mysql -h$dbhost -u$dbuser -p$dbpass < tmptest.sql
	mysql -h$dbhost -u$dbuser -p$dbpass $dbname < basedbdatatest.sql
	if [ $? -eq 0 ]; then
		rst=0
	fi
	#mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;update category_languages set cat_name = replace(cat_name, 'JJsHouse', 'JenJenHouse'),seo_title = replace(seo_title, 'JJsHouse', 'JenJenHouse'),keywords = replace(keywords, 'JJsHouse', 'JenJenHouse'),cat_desc = replace(cat_desc, 'JJsHouse', 'JenJenHouse');update category_languages set cat_name = replace(cat_name, 'jjshouse', 'jenjenhouse'),seo_title = replace(seo_title, 'jjshouse', 'jenjenhouse'),keywords = replace(keywords, 'jjshouse', 'jenjenhouse'),cat_desc = replace(cat_desc, 'jjshouse', 'jenjenhouse');update multilanguage set en = replace(en, 'JJsHouse', 'JenJenHouse'),de = replace(de, 'JJsHouse', 'JenJenHouse'),es = replace(es, 'JJsHouse', 'JenJenHouse'),fr = replace(fr, 'JJsHouse', 'JenJenHouse'),se = replace(se, 'JJsHouse', 'JenJenHouse'),no = replace(no, 'JJsHouse', 'JenJenHouse'),it = replace(it, 'JJsHouse', 'JenJenHouse'),pt = replace(pt, 'JJsHouse', 'JenJenHouse'),da = replace(da, 'JJsHouse', 'JenJenHouse'),fi = replace(fi, 'JJsHouse', 'JenJenHouse'),ru = replace(ru, 'JJsHouse', 'JenJenHouse'),nl = replace(nl, 'JJsHouse', 'JenJenHouse');update multilanguage set en = replace(en, 'jjshouse', 'jenjenhouse'),de = replace(de, 'jjshouse', 'jenjenhouse'),es = replace(es, 'jjshouse', 'jenjenhouse'),fr = replace(fr, 'jjshouse', 'jenjenhouse'),se = replace(se, 'jjshouse', 'jenjenhouse'),no = replace(no, 'jjshouse', 'jenjenhouse'),it = replace(it, 'jjshouse', 'jenjenhouse'),pt = replace(pt, 'jjshouse', 'jenjenhouse'),da = replace(da, 'jjshouse', 'jenjenhouse'),fi = replace(fi, 'jjshouse', 'jenjenhouse'),ru = replace(ru, 'jjshouse', 'jenjenhouse'),nl = replace(nl, 'jjshouse', 'jenjenhouse');-- UPDATE goods SET is_display = -1 WHERE NOT EXISTS (SELECT 1 FROM goods_gallery gg WHERE gg.goods_id = goods.goods_id and (gg.img_type='ps' or gg.img_type='photo') LIMIT 1) AND NOT EXISTS (SELECT 1 FROM category c WHERE c.cat_id=goods.cat_id and (c.cat_id=5 or c.parent_id =5) LIMIT 1)"
	#mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;REPLACE INTO goods_project_config (config_id, img_type, project_name, display_order, cat_id, is_clothes) VALUES (11021, 'old', 'VBridal', 2, '', 0),(11032, 'photo', 'VBridal', 1, '', 0),(11043, 'photo', 'VBridal', 2, '', 1),(11074, 'old', 'VBridal', 1, '', 1);"
	#mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname;update (select * from(SELECT g.goods_id, gpc.img_type, gg.img_url, gpc.display_order FROM goods g left join goods_gallery gg on g.goods_id = gg.goods_id and gg.is_delete = 0 and gg.is_display = 1 and gg.is_default = 1 left join goods_project_config gpc on gg.img_type = gpc.img_type left join category c on c.cat_id = g.cat_id WHERE gpc.is_clothes = if(c.is_accessory = 0, 1, 0) and gpc.project_name = 'VBridal' ORDER BY gpc.display_order ASC ) as xxx group by goods_id) as yyy, goods_project p set p.img_type = yyy.img_type, p.goods_thumb = yyy.img_url where yyy.goods_id = p.goods_id and p.project_name = 'VBridal';"
#	if [ $? -gt 0 ]; then
#		echo "[Sev-1] jjshouse alert JJsHouse->JenJenHouse替换失败！$timenow" | mail -s "[Sev-1] jjshouse alert JJsHouse->JenJenHouse替换失败！$timenow" lyu@i9i8.com
#	fi
fi

if [ $rst -eq 0 ]; then
	rst="OK"
else
	rst="FAILED"
fi

echo "Compleated at $timenow. Result is $rst."

rm -f tmptest.sql basedbdatatest.sql basedbdatatest_checksum
