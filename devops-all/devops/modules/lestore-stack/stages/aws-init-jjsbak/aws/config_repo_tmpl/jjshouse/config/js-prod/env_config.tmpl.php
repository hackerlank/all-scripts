<?php

// database host
$db_host = "__DB_HOST__";
$db_name = "jjshouse";
$db_user = "jjs0517fe";
$db_pass = "jjshousecommonpass";

$db_host_RO = "__DB_SLAVE_HOST__";

// search host
//$search_host = "ec2-184-73-32-248.compute-1.amazonaws.com:38080/jjssearch";
$search_hosts = array(
	'main' => "__SEARCH_MAIN__",
	'backup' => "__SEARCH_BACK__",
);
$serve_host = '__SERVER_NAME__';
$cache_host = '__CACHE_HOST__';
$cache_host_2 = $cache_host;
$cache_timeout = 3600 * 3;
$session_host = "tcp://$cache_host:11211";
$soap_host = 't.jjshouse.com';
defined('SOAP_LOGIN') || define('SOAP_LOGIN', 'lebbay420');//soap登录用户名
defined('SOAP_PASSWORD') || define('SOAP_PASSWORD', 'lebbay420api');//soap登录密码
defined('SOAP_OSTICKET_URL') || define('SOAP_OSTICKET_URL', 'http://' . $soap_host . '/osticket/api/soap.php');//soap url

// xhprof
$XHPROF_ROOT = '/var/www/xhprof-0.9.2';

// party ID
defined('PARTY_ID') || define('PARTY_ID', 65582);

// cdn
$_is_https = (isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == '443')
    || (isset($_SERVER['HTTP_X_PORT']) && $_SERVER['HTTP_X_PORT'] == '443')
    || (isset($_SERVER['HTTP_X_FORWARDED_PORT']) && $_SERVER['HTTP_X_FORWARDED_PORT'] == '443');
$_use_http_or_https = $_is_https ? 'https' : 'http';
$rs_server = $_use_http_or_https . '://__RS_SERVER__/';

// debug mode
$GLOBALS['DEBUG_MODE'] = false;
$GLOBALS['ON_PRODUCT'] = true;
//$GLOBALS['ON_PRODUCT_ALARM'] = true;

$siteConf['alarm_mail_list'] = array(
    'debug' => 'yzhang@tetx.com',
    'pre'   => array('bwzhang@i9i8.com','bcheng@i9i8.com','hwang@i9i8.com'),
    'prod'  => 'alarm@i9i8.com',
);
$GLOBALS['maillist']='pre';

$GLOBALS['use_geoip'] = false;
$_project_name = "JJsHouse";
defined('PROJECT_NAME_LOCAL') || define('PROJECT_NAME_LOCAL',$_project_name);
#defined('COOKIE_DOMAIN') || define('COOKIE_DOMAIN', '');

$jjshouse_domain = 'www.jjshouse.com';

// paypal prod
$siteConf['paypal'] = array(
    'domain' => 'www.paypal.com',
    'account_email' => 'paypal@jjshouse.com',
    'business' => 'zz'
);

// gspay 正式
$siteConf['gspay'] = array(
    'siteID' => '90364',
    'merchantID' => '16572',
    'payurl' => 'https://secure.redirect2pay.com/payment/pay.php',
    'toProduct' => true
);

// GC prod
#$gc_server_url = 'https://ps.gcsip.nl/wdl/wdl'; // test
$gc_server_url = 'https://ps.gcsip.com/wdl/wdl'; // production

// production ses
$siteConf['aws_config'] = array(
	'AWS_KEY' => '__AWS_ACCESS_KEY__',
	'AWS_SECRET_KEY' => '__AWS_SECRET_KEY__'
);

$siteConf['free_shipping_time'] = array(
    'JJsHouse' => array(
        'start_time' => '2012-06-01 00:00:00',
        'end_time' => '2012-06-04 00:00:00',
    ),
);

$siteConf['adword_account_list'] = array(
    "971961408" => "lchen",
    "978676367" => "qzhong",
);

$siteConf['analytics_account_list'] = array(
    "UA-22969574-2" => "lchen",
    "UA-20779114-1" => "qzhong",
);


$GLOBALS['sql_max_cache_time']  = 10800;

$siteConf['black_friday_time'] = array(
		'begin' => '2013-12-02',
		'end' => '2013-12-05'
);
$siteConf['black_friday_alert_email'] = array('mxu2@i9i8.com');
$siteConf['black_friday_alert_switch'] = false;

$siteConf['change_banner_time'] = array(
	'begin' => '2013-12-09',
	'end' => '2013-12-10'
);

$siteConf['promotion_time'] = array(
		'begin' => '2013-12-27',
		'end' => '2013-12-31'
);

// promotion christmas time
$siteConf['promotion_christmas_time'] = array(
		'begin' => '2013-12-23',
		'end' => '2013-12-25',
);

$siteConf['checkWeeklyDealOffForce'] = false;

$siteConf['year_end_sale_time'] = array(
		'begin' => '2013-12-27',
		'end' => '2013-12-31'
);
$siteConf['year_end_alert_email'] = array('mxu2@i9i8.com');
$siteConf['year_end_alert_switch'] = true;

$siteConf['presidents_day_sale_time'] = array(
    'begin' => '2014-02-14',#presidents
    'end' => '2014-02-17',#presidents
);

$_v5_ = array(
    'stage' => 'production',
    'filter' => true,
    'index' => true,
    'search' => true,
    'mc.cluster' => array(
        array('__MC_CLUSTER_NODE1__', 11211),
        array('__MC_CLUSTER_NODE2__', 11211),
    ),
    'mc.dynamic' => array('__MC_DYNAMIC__', 11211),
);

defined('APP_NAME') || define('APP_NAME', 'JJsHouse');
defined('APP_NAME_LOWER') || define('APP_NAME_LOWER', strtolower(APP_NAME));
defined('APP_DOMAIN') || define('APP_DOMAIN', APP_NAME.'.com');
defined('APP_DOMAIN_LOWER') || define('APP_DOMAIN_LOWER', strtolower(APP_DOMAIN));
defined('THEME_NAME') || define('THEME_NAME', APP_NAME_LOWER);
defined('COOKIE_DOMAIN') || define('COOKIE_DOMAIN', APP_DOMAIN_LOWER);

$siteConf['pic_cdn'] = array(
		'jjshouse.com' => array(
				'http' => array(
						'http://__CDN_IMG1__/upimg/',
						'http://__CDN_IMG2__/upimg/',
						'http://__CDN_IMG1__/upimg/',
						'http://__CDN_IMG2__/upimg/',
				),
				'https' => array(
						'https://__CDN_IMG1__/upimg/',
						'https://__CDN_IMG2__/upimg/',
						'https://__CDN_IMG1__/upimg/',
						'https://__CDN_IMG2__/upimg/',
				)
		),
);
