<?php

#{{{----- diff for testenv
$db_host = "__DB_HOST__:3306";
$db_name = "azazie";
$db_user = "jjs0517editor";
$db_pass = "azaziecommonpass";

defined('SERVICE_EMAIL') || define('SERVICE_EMAIL', 'service@azazie.com');
defined('NOTICE_EMAIL') || define('NOTICE_EMAIL', 'customerservice@azazie.com');
defined('ALERT_EMAIL') || define('ALERT_EMAIL', 'customerservice@azazie.com');
defined('BAK_EMAIL') || define('BAK_EMAIL', 'folder@azazie.com');

define('LOGIN_URL',"https://cms.azazie.com");
// $domain = "http://zp.azazie.com";

$siteConf['domain'] = 'www.azazie.com';
$siteConf['cdn'] = 'http://__CDN_IMG1__/upimg/';
# image host (e.g. http://img.azazie.com/)
$siteConf['imageHost'] = 'http://img.azazie.com/';
$siteConf['eseditor'] = 'https://eseditor.azazie.com/';
$siteConf['cms'] = 'http://cms.azazie.com/';
$siteConf['aws_config'] = array(
        'AWS_KEY' => '__AWS_ACCESS_KEY__',
        'AWS_SECRET_KEY' => '__AWS_SECRET_KEY__'
);
define('SOAP_LOGIN', 'lebbay420');
define('SOAP_PASSWORD', 'lebbay420api');
#}}}----- end

#{{{----- shared
$proj_name = 'azazie';
$proj_name = isset($_COOKIE['proj']) && $_COOKIE['proj'] ? $_COOKIE['proj'] : ($proj_name ? $proj_name : 'azazie');

$COOKIE_DOMAIN = "";
define('PARTY_ID', 65582);
define('ENCRYPT_KEY', 'lebbay');

$prefix = "";
$timezone = "Asia/Shanghai";
$cookie_path = "/";
$session = "1440000";

$rdstimezone = '-8:00';
$timezone = "America/Los_Angeles"; // PST 美国洛杉矶时间

$siteConf['loginProjects'] = array ('Azazie');
$siteConf['projName'] = strtolower($proj_name);
$siteConf['proj4display'] = 'Azazie';
$siteConf['domain4display'] = $siteConf['proj4display'].'.com';
$siteConf['allProjects'] = array('Azazie');
#}}}----- end
