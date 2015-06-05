<?php
define('IN_ECS', true);
$timezone = "Asia/Shanghai";
date_default_timezone_set($timezone);
//require_once ( __DIR__ . '/cls_mysql.php');
require_once ( __DIR__ . '/create_filter2.php');
//$db = new PDO('localhost', 'jjshouse', 'jjshouse', 'jjshouse');
$db = new PDO("mysql:host=localhost;dbname=jjshouse", 'jjshouse', 'jjshouse');
rebuildFilter2Action($db, $argv[1]);

