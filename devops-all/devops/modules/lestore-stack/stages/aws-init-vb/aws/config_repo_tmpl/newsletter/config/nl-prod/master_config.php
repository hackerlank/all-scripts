<?php

#{{{----- diff for prodenv
// database host
$db_host = "__DB_HOST__:3306";
$db_name = "vbridal";
$db_user = "jjs0517email";
$db_pass = "vbridalcommonpass";

$session = "3600";

$GLOBALS['ON_PRODUCT'] = true;
$siteConf['openHttps'] = true;
$siteConf['tplCacheMaxTime'] = 24 * 60 * 60;

//SendGrid 账户
define('SENDGRID_USERNAME', 'vbridal');
define('SENDGRID_PASSWORD', 'leqee8888');

define('CHECK_AUTH_USER', true);

$img_prefix = 'http://__CDN_IMG1__/upimg/l/';
$rs_server = 'http://__CDN_RESOURCE__/';

$siteConf['aws_config'] = array(
        'AWS_KEY' => '__AWS_ACCESS_KEY__',
        'AWS_SECRET_KEY' => '__AWS_SECRET_KEY__'
);

$test_email = 'mxu2@tetx.com';
$default_test_email = 'mxu2@i9i8.com;lchen@i9i8.com';
$siteConf['nl_cdn'] = 'https://newsletter.vbridal.com/newsletter/images/';
$siteConf['testers'] = array('mxu2@i9i8.com','lchen@i9i8.com','hwang@i9i8.com','yywang1@i9i8.com','dcpeng@i9i8.com');
$siteConf['monitors'] = array('luckygeini@163.com');
#}}}----- end

#{{{----- shared
$rdstimezone = '-8:00';
//$timezone = "Asia/Shanghai";
$timezone = "America/Los_Angeles"; // PST 美国洛杉矶时间
$charset = 'utf-8';

$cookie_path = "/";

$GLOBALS['DEBUG_MODE'] = false;

define('PROJECT_NAME', 'Vbridal');
define('PROJECT_NAME_LOWER', strtolower(PROJECT_NAME));
define('SITE_DOMAIN_ROOT', PROJECT_NAME.'.com');
define('SITE_DOMAIN', strtolower(SITE_DOMAIN_ROOT));
defined('NOTICE_EMAIL') || define('NOTICE_EMAIL', 'notice@'.SITE_DOMAIN);
defined('BAK_EMAIL') || define('BAK_EMAIL', 'folder@'.SITE_DOMAIN);
defined('ALERT_EMAIL') || define('ALERT_EMAIL', 'notice@' . SITE_DOMAIN); #changed according to mxu2

defined('DEFAULT_LANGUAGE_ID') || define('DEFAULT_LANGUAGE_ID', 1);
defined('DEFAULT_CURRENCY_ID') || define('DEFAULT_CURRENCY_ID', 1);

isset($_LANG) && is_array($_LANG) ? null : $_LANG = array();
isset($siteConf) && is_array($siteConf) ? null : $siteConf = array();

$siteConf['use_cronjob'] = true;
$siteConf['use_cronjob_dir'] = '/var/job/newsletter/';
#}}}----- end

?>
