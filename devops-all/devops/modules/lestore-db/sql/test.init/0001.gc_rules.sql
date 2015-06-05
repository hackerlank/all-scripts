insert into payment_config 
select 'DressFirst', language_code, country_code, currency_code, REPLACE(payment_list,'jjshouse','dressfirst'), gc_product_ids, ctime, enabled from payment_config where project_name = 'JJsHouse';

insert into payment_config 
select 'JenJenHouse', language_code, country_code, currency_code, REPLACE(payment_list,'jjshouse','jenjenhouse'), gc_product_ids, ctime, enabled from payment_config where project_name = 'JJsHouse';

insert into payment_config 
select 'JennyJoseph', language_code, country_code, currency_code, REPLACE(payment_list,'jjshouse','jennyjoseph'), gc_product_ids, ctime, enabled from payment_config where project_name = 'JJsHouse';

insert into payment_config 
select 'AmorModa', language_code, country_code, currency_code, REPLACE(payment_list,'jjshouse','amormoda'), gc_product_ids, ctime, enabled from payment_config where project_name = 'JJsHouse';
