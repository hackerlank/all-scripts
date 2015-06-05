<?php

#{{{----- diff for testenv
$db_host = "__DB_HOST__:3306";
$db_name = "jjshouse";
$db_user = "jjs0517editor";
$db_pass = "jjshousecommonpass";

defined('SERVICE_EMAIL') || define('SERVICE_EMAIL', 'service@jjshouse.com');
defined('NOTICE_EMAIL') || define('NOTICE_EMAIL', 'notice@jjshouse.com');
defined('ALERT_EMAIL') || define('ALERT_EMAIL', 'notice@jjshouse.com');
defined('BAK_EMAIL') || define('BAK_EMAIL', 'folder@jjshouse.com');

define('LOGIN_URL',"https://cms.jjshouse.com");
// $domain = "http://zp.jjshouse.com";

$siteConf['domain'] = 'www.jjshouse.com';
$siteConf['cdn'] = 'http://__CDN_IMG1__/upimg/';
# image host (e.g. http://img.jjshouse.com/)
$siteConf['imageHost'] = 'http://img.jjshouse.com/';
$siteConf['eseditor'] = 'https://eseditor.jjshouse.com/';
$siteConf['cms'] = 'http://cms.jjshouse.com/';
$siteConf['aws_config'] = array(
        'AWS_KEY' => '__AWS_ACCESS_KEY__',
        'AWS_SECRET_KEY' => '__AWS_SECRET_KEY__'
);
define('SOAP_LOGIN', 'lebbay420');
define('SOAP_PASSWORD', 'lebbay420api');
#}}}----- end

#{{{----- shared
$proj_name = 'jjshouse';
$proj_name = isset($_COOKIE['proj']) && $_COOKIE['proj'] ? $_COOKIE['proj'] : ($proj_name ? $proj_name : 'jjshouse');

$COOKIE_DOMAIN = "";
define('PARTY_ID', 65582);
define('ENCRYPT_KEY', 'lebbay');

$prefix = "";
$timezone = "Asia/Shanghai";
$cookie_path = "/";
$session = "1440000";

$rdstimezone = '-8:00';
$timezone = "America/Los_Angeles"; // PST 美国洛杉矶时间

$siteConf['loginProjects'] = array ('JJsHouse');
$siteConf['projName'] = strtolower($proj_name);
$siteConf['proj4display'] = 'JJsHouse';
$siteConf['domain4display'] = $siteConf['proj4display'].'.com';
$siteConf['allProjects'] = array('JJsHouse');
#}}}----- end
