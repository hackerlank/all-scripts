create database if not exists `domain_wp` character set utf8;
grant all privileges on `domain_wp`.* to "adminwp"@"%" identified by "wordpress2015";
flush privileges;
