ALTER TABLE currency ADD COLUMN `currency_local_symbol` varchar(10) NOT NULL DEFAULT '' COMMENT '本地货币符号缩写';# 14 row(s) affected.


update currency set currency_local_symbol='$' where currency='HKD';# 1 row(s) affected.

update currency set currency_local_symbol='R$' where currency='BRL';# 1 row(s) affected.

update currency set currency_local_symbol='$' where currency='CLP';# MySQL returned an empty result set (i.e. zero rows).

update currency set currency_local_symbol='Kr.' where currency='SEK';# 1 row(s) affected.

update currency set currency_local_symbol='kr.' where currency='DKK';# 1 row(s) affected.

update currency set currency_local_symbol='kr.' where currency='NOK';# 1 row(s) affected.

update currency set currency_local_symbol='p.' where currency='RUB';# 1 row(s) affected.

update currency set currency_local_symbol='$' where currency='USD';# 1 row(s) affected.

update currency set currency_local_symbol='€' where currency='EUR';# 1 row(s) affected.

update currency set currency_local_symbol='£' where currency='GBP';# 1 row(s) affected.

update currency set currency_local_symbol='$' where currency='CAD';# 1 row(s) affected.

update currency set currency_local_symbol='$' where currency='AUD';# 1 row(s) affected.

update currency set currency_local_symbol='₣' where currency='CHF';# 1 row(s) affected.

update currency set currency_local_symbol='$' where currency='NZD';# 1 row(s) affected.

update currency set currency_local_symbol='¥' where currency='CNY';# 1 row(s) affected.