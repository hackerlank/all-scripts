truncate tmp_c_attr_goods_filter_jjshouse;
insert into tmp_c_attr_goods_filter_jjshouse
select * from tmp_c_attr_goods_filter where project_name  = 'JJsHouse' and is_delete = 0 and is_show = 1;

truncate tmp_c_attr_goods_filter_jenjenhouse;
insert into tmp_c_attr_goods_filter_jenjenhouse
select * from tmp_c_attr_goods_filter where project_name  = 'JJsHouse' and is_delete = 0 and is_show = 1;
update tmp_c_attr_goods_filter_jenjenhouse set project_name = 'JenJenHouse';

truncate tmp_c_attr_goods_filter_dressfirst;
insert into tmp_c_attr_goods_filter_dressfirst
select * from tmp_c_attr_goods_filter where project_name  = 'JJsHouse' and is_delete = 0 and is_show = 1;
update tmp_c_attr_goods_filter_dressfirst set project_name = 'DressFirst';

truncate tmp_c_attr_goods_filter_jennyjoseph;
insert into tmp_c_attr_goods_filter_jennyjoseph
select * from tmp_c_attr_goods_filter where project_name  = 'JJsHouse' and is_delete = 0 and is_show = 1;
update tmp_c_attr_goods_filter_jennyjoseph set project_name = 'JennyJoseph';

truncate tmp_c_attr_goods_filter_amormoda;
insert into tmp_c_attr_goods_filter_amormoda
select * from tmp_c_attr_goods_filter where project_name  = 'JJsHouse' and is_delete = 0 and is_show = 1;
update tmp_c_attr_goods_filter_amormoda set project_name = 'AmorModa';

truncate tmp_c_attr_goods_filter_vbridal;
insert into tmp_c_attr_goods_filter_vbridal
select * from tmp_c_attr_goods_filter where project_name  = 'JJsHouse' and is_delete = 0 and is_show = 1;
update tmp_c_attr_goods_filter_vbridal set project_name = 'Vbridal';
