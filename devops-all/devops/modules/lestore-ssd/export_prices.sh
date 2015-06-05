#!/bin/bash
source $(dirname $0)/ssd_db.conf;

mysql="mysql --skip-column-names --default-character-set=utf8 -h ${dbhost} -P${dbport} -u ${dbuser} -p${dbpass} ${dbname}"

target_dir=/opt/data1/dbdata
target='prices.sql'
cd $target_dir

echo >$target

cat <<END >> $target
TRUNCATE accessories_sale_price;
END

cat <<SQL_END  | $mysql >> $target
SELECT
CONCAT('INSERT INTO accessories_sale_price(external_goods_id,external_cat_id,sales_price,party_id,party_name) VALUES (',
CONCAT_WS(',', g.goods_id , g.cat_id , gp.shop_price ,
case when gp.project_name  = 'JJsHouse' then 65545
when gp.project_name  = 'AmorModa' then 65570
when gp.project_name  = 'JenJenHouse' then 65564
when gp.project_name  = 'JennyJoseph' then 65567
when gp.project_name  = 'DressDepot' then 65578
when gp.project_name  = 'DressFirst' then 65579
when gp.project_name  = 'VBridal' then 65580
else 0
end),
',\'',gp.project_name,'\''
');') as exported
FROM goods g
JOIN category c on g.cat_id = c.cat_id
JOIN goods_project gp on g.goods_id = gp.goods_id
WHERE g.is_delete = 0 and g.is_on_sale = 1 and g.is_display = 1
and gp.project_name in ('JJsHouse','AmorModa','JenJenHouse','JennyJoseph','DressDepot','DressFirst','VBridal')
and c.parent_id in (89,132,133,114,129,5)
and c.cat_id not in (13,15,33);
SQL_END

cat <<PREARE_SQL >> $target
TRUNCATE ecshop.accessories_sale_price_detail;

insert into ecshop.accessories_sale_price_detail(external_goods_id,product_id,party_id)
select asp.external_goods_id,eg.product_id,asp.party_id from ecshop.accessories_sale_price asp
left join ecshop.ecs_goods eg on asp.external_goods_id = eg.external_goods_id
and asp.party_id = eg.goods_party_id;

delete from ecshop.accessories_sale_price_detail where product_id = '';

update ecshop.accessories_sale_price asp
SET asp.sales_price_rmb = asp.sales_price *
(select cc.CURRENCY_CONVERSION_RATE
FROM romeo.currency_conversion cc
WHERE cc.CANCELLATION_FLAG = 'N'
AND cc.TO_CURRENCY_CODE = 'RMB'
ORDER BY CREATED_STAMP DESC
LIMIT 1);
PREARE_SQL

echo $(md5sum $target|awk '{print $1}') > $target.checksum
tar zcf $target.tar.gz $target $target.checksum
