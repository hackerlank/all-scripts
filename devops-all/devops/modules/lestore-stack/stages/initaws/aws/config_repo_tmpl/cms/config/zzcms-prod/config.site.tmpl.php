<?php

/**
 * @version $Id: config.site.php 5187 2010-04-26 13:48:31Z yzhang $
 *
 */

include_once dirname(__FILE__) . '/config.base.php';
//include_once dirname(__FILE__) . '/../lib/Zandy.php'; # add at 20060708


$site = str_replace(dirname(dirname(dirname(__FILE__))) . DIRECTORY_SEPARATOR, '', dirname(dirname(__FILE__)));

$_path = '../htm/';
$baseUri = getRootUri($_path);
unset($_path);
// 如果上面的程序不能正确的确定 baseUri 就需要手动指定了
//$baseUri = '';


$siteConf = isset($siteConf) && is_array($siteConf) ? $siteConf : array();
$siteConf['baseDir'] = $baseDir;
$siteConf['baseUri'] = $baseUri;

defined('P_S') || define("P_S", PATH_SEPARATOR);
defined('D_S') || define("D_S", DIRECTORY_SEPARATOR);

// {{{ base dir
$siteConf['tplBaseDir'] = $siteConf['baseDir'] . 'app/tpl/';
$siteConf['varBaseDir'] = $siteConf['baseDir'] . 'var/';
$siteConf['varDir'] = $siteConf['baseDir'] . 'var/';
$siteConf['htmDir'] = $siteConf['baseDir'] . 'htm/';
$siteConf['cacheDir'] = $siteConf['baseDir'] . 'var/tpl/';
$siteConf['libDir'] = $siteConf['baseDir'] . 'lib/';
$siteConf['tpl_debug'] = true;
$siteConf['tplCacheMaxTime'] = 24 * 60 * 60;
// }}}
// {{{ smarty compiled dir
#$siteConf['tplCacheBaseDir'] = $siteConf['cacheDir']; // Zandy_Template need this var
$siteConf['tplCacheBaseDir'] = $siteConf['varDir'] . 'tpl/'; // Zandy_Template need this var
// }}}
// {{{ resource
$siteConf['rsUrl'] = $siteConf['baseUri'] . 'resource/';
$siteConf['rsDir'] = $siteConf['baseDir'] . 'htm/resource/';
// }}}
// {{{ tpl
$siteConf['tplDir'] = $siteConf['tplBaseDir'];
$siteConf['tplAdminDir'] = $siteConf['tplBaseDir'] . 'admin/';
// }}}
// {{{ session dir
$siteConf['sessDir'] = $siteConf['varDir'] . 'session/';
// }}}
// {{{ per page
$siteConf['perPage'] = 100;
// }}}
// {{{ charset
$siteConf['charset'] = 'utf-8';
// }}}
// {{{ timezone
//$siteConf['default_timezone'] = 'Asia/Shanghai';
$siteConf['default_timezone'] = "America/Los_Angeles"; // PST 美国洛杉矶时间
if (PHP_VERSION >= '5.1.2' && function_exists('date_default_timezone_set') && isset($siteConf['default_timezone']))
{
	date_default_timezone_set($siteConf['default_timezone']);
}
//
//$siteConf['rdstimezone'] = '+8:00';
//$siteConf['rdstimezone'] = '-8:00';
$siteConf['dbtimezone'] = 'America/Los_Angeles';
// }}}
// {{{ cookie
$siteConf['cookie_expire'] = 60 * 60 * 24 * 30;
$siteConf['cookie_path'] = '/';
$siteConf['cookie_domain'] = 'cms.azazie.com';
// }}}
// {{{ define constant about cookie
defined('COOKIE_PATH') || define('COOKIE_PATH', $siteConf['cookie_path']);
if (isset($_tmp_cookie_domain_isnull) && $_tmp_cookie_domain_isnull)
{
	$siteConf['cookie_domain'] = null;
	unset($_tmp_cookie_domain_isnull);
}
elseif (!$siteConf['cookie_domain'] && isset($_guess_domain) && $_guess_domain)
{
	$siteConf['cookie_domain'] = $_guess_domain;
	unset($_guess_domain);
}
defined('COOKIE_DOMAIN') || define('COOKIE_DOMAIN', $siteConf['cookie_domain']);
defined('COOKIE_EXPIRE') || define('COOKIE_EXPIRE', $siteConf['cookie_expire']);
// }}}
defined('OKSID') || define('OKSID', 'OKSID');
defined('SSO_SESSION_KEY') || define('SSO_SESSION_KEY', 'SSID');
// {{{ controller directory
$siteConf['controllersDir'] = $siteConf['baseDir'] . 'app/controllers/';
// }}}
// {{{ routers, that is modules in fact
$siteConf['routers'] = array(
	'admin' => 'admin',
	'cron' => 'cron',
	'feature' => 'feature',
	'adminTop' => 'admin/top',
	'adminLeft' => 'admin/left',
	'adminMain' => 'admin/main'
);
// }}}


$siteConf['authkey'] = 'j^&$23ra*fda%#5f';

$siteConf['proj_name'] = 'azazie';
$siteConf['proj_name_upper'] = 'Azazie';
$siteConf['proj_domain'] = 'azazie.com';
$siteConf['proj_domain_upper'] = 'Azazie.com';

// {{{
// product server
$siteConf['server'] = array(
	'www' => 'http://www.azazie.com',
	'www_safe' => 'https://www.azazie.com',
	'cms' => 'https://cms.azazie.com',
	'ticket' => 'http://t.' . $siteConf['proj_domain'],
	'editor' => 'http://editor.azazie.com',
	'eseditor' => 'https://eseditor.azazie.com',
);
// }}}


$siteConf['site'] = $site;

$siteConf['upfileDir'] = $siteConf['htmDir'] . 'userfiles/';
$siteConf['upfileDir_goodsImages'] = '/opt/data1/jjsimg/';
$siteConf['upfileUrl'] = $siteConf['baseUri'] . 'userfiles/';

$siteConf['upfile'] = array(
	'allow' => array(
		'jpg',
		'jpeg',
		'gif',
		'png',
		'bmp',
		'icon',
		'txt',
		'doc'
	),
	'deny' => array(
		'exe',
		'torrent'
	)
);

#$sessionOptions = array('save_path' => $siteConf['sessDir'], 'cache_limiter' => 'private,must-revalidate');
#$sessionOptions = array('save_handler' => 'memcache', 'save_path' => 'tcp://127.0.0.1:11211', 'cache_limiter' => 'private,must-revalidate');
$siteConf['cache_prefix'] = 'ZZ_CMS_';
$siteConf['cache_cluster'] = array(
	array('__MC_DYNAMIC__', 11211),
);
$siteConf['cache_timeout'] = 600;

$siteConf['sessionOptions'] = array(
	#'save_path' => 'tcp://172.16.106.113:11211',
	#'save_path' => 'tcp://jjscache.2vg8lh.0001.use1.cache.amazonaws.com:11211',
	'save_path' => 'tcp://__CACHE_HOST__:11211',
	'save_handler' => 'memcache',
	//'save_path' => $siteConf['varDir'] . 'session',
	'gc_maxlifetime' => COOKIE_EXPIRE,
	'cookie_lifetime' => COOKIE_EXPIRE,
	'cookie_path' => COOKIE_PATH,
	'cookie_domain' => COOKIE_DOMAIN,
	'cache_limiter' => 'private,must-revalidate',  // 后退需重新发送
	//'cache_limiter' => 'private', // 后退不需重新发送
	'cache_expire' => COOKIE_EXPIRE
);

$siteConf['editor_url'] = 'https://editor.' . $siteConf['proj_name'] . '.com';

// {{{ 创始人，后台拥有超级权限，多个用半角逗号分隔
$siteConf['founders'] = '';
// }}}


define("AUTH_KEY", '8x$p#5%&q*z!');

// erp同步正式环境配置
$siteConf['erp_soap_service'] = 'http://127.0.0.1:38888/romeo/JjshouseService?wsdl';
#$siteConf['erp_soap_service'] = 'http://10.198.47.8:38888/romeo/JjshouseService?wsdl';//logman.dhvalue.com

defined('SIZE_CHART_CHANGE_DAY') || define('SIZE_CHART_CHANGE_DAY', '2011-04-01');

$siteConf['sendgrid_username'] = 'jshouse';
$siteConf['sendgrid_password'] = 'leqee8888';

$siteConf['gmail_username'] = 'qzhong@jjshouse.com';
$siteConf['gmail_password'] = 'Y95nh7bqe';
$siteConf['gmail_password'] = 'ifdssCC12';

define("PARTY_ID", 65545);

$siteConf['cms_http_user'] = 'lebbay420';
$siteConf['cms_http_pass'] = 'lebbay420api';

$siteConf['sys_listen_current_project'] = array('Azazie');
$siteConf['sys_listen_current_project_map'] = array(
	'azazie' => 'Azazie',
);

$siteConf['payment'] = array(
	'gc' => array(
		'JJsHouse' => array(
			'merchantid' => '7441',
			#'service_url' => 'https://ps.gcsip.nl/wdl/wdl', // test
			'service_url' => 'https://ps.gcsip.com/wdl/wdl', // production
		    'payment_product_id' => array(
		    	'creditcard' => array(
	    			1 => 1, // Visa
	    			2 => 2, // AMEX/American Express
	    			3 => 3, // MasterCard
	    			15 => 111, // Visa Delta
	    			12 => 114, // Visa Debit xxx
	    			#12 => 1, // Visa Debit yyy
	    			13 => 119, // MasterCard Debit xxx
	    			#13 => 3, // MasterCard Debit yyy
	    			10 => 122, // Visa Electron
	    			6 => 125, // JCB
	    			9 => 123, // Dankort
		    	),
		    	'realtimebank' => array(
	    			11 => 809, // iDEAL
	    			7 => 836, // Sofort
		    	),
		    	'webmoney' => array(
	    			18 => 841, // WebMoney
		    	),
		    	'boleto' => array(
	    			14 => 1503, // Boleto
		    	),
		    	'yandexmoney' => array(
	    			#20 => 849, // yandexmoney
		    	),
		    )
		),
		'JenJenHouse' => array(
			'merchantid' => '7442',
			#'service_url' => 'https://ps.gcsip.nl/wdl/wdl', // test
			'service_url' => 'https://ps.gcsip.com/wdl/wdl', // production
		    'payment_product_id' => array(
		    	'creditcard' => array(
	    			1 => 1, // Visa
	    			2 => 2, // AMEX/American Express
	    			3 => 3, // MasterCard
	    			15 => 111, // Visa Delta
	    			12 => 114, // Visa Debit xxx
	    			#12 => 1, // Visa Debit yyy
	    			13 => 119, // MasterCard Debit xxx
	    			#13 => 3, // MasterCard Debit yyy
	    			10 => 122, // Visa Electron
	    			6 => 125, // JCB
	    			9 => 123, // Dankort
		    	),
		    	'realtimebank' => array(
	    			11 => 809, // iDEAL
	    			7 => 836, // Sofort
		    	),
		    	'webmoney' => array(
	    			18 => 841, // WebMoney
		    	),
		    	'yandexmoney' => array(
	    			#20 => 849, // yandexmoney
		    	),
		    )
		),
		'JennyJoseph' => array(
			'merchantid' => '7443',
			#'service_url' => 'https://ps.gcsip.nl/wdl/wdl', // test
			'service_url' => 'https://ps.gcsip.com/wdl/wdl', // production
		    'payment_product_id' => array(
		    	'creditcard' => array(
	    			1 => 1, // Visa
	    			2 => 2, // AMEX/American Express
	    			3 => 3, // MasterCard
	    			15 => 111, // Visa Delta
	    			12 => 114, // Visa Debit xxx
	    			#12 => 1, // Visa Debit yyy
	    			13 => 119, // MasterCard Debit xxx
	    			#13 => 3, // MasterCard Debit yyy
	    			10 => 122, // Visa Electron
	    			6 => 125, // JCB
	    			9 => 123, // Dankort
		    	),
		    	'realtimebank' => array(
	    			11 => 809, // iDEAL
	    			7 => 836, // Sofort
		    	),
		    	'webmoney' => array(
	    			18 => 841, // WebMoney
		    	),
		    	'yandexmoney' => array(
	    			20 => 849, // yandexmoney
		    	),
		    )
		)
	)
);

$siteConf['aws_config'] = array(
	'AWS_KEY' => '__AWS_ACCESS_KEY__',
	'AWS_SECRET_KEY' => '__AWS_SECRET_KEY__'
);

$siteConf['send_change_permission_mail'] = array('w-qx-monitor@i9i8.com','hwang@i9i8.com');

// 每周要发的主站项目
$siteConf['wMainSiteProjectList'] = array('Azazie');
// 每周要发的手机站项目
$siteConf['wMobileSiteProjectList'] = array('Azazie');
// 每天要发的主站项目
$siteConf['dMainSiteProjectList'] = array('Azazie');

// 防止将项目名作为参数时因为项目名大小写原因，而造成wire transfer id无法获取引起统计数据出错的情况
$siteConf['projectMap'] = array(
	'jjshouse'=>'JJsHouse',
	'jenjenhouse'=>'JenJenHouse',
	'jennyjoseph'=>'JennyJoseph',
	'amormoda'=>'AmorModa',
	'dressdepot'=>'DressDepot',
	'jenjenhousenet'=>'JenJenHouseNET',
	'dressfirst'=>'DressFirst',
	'azazie'=>'Azazie'
);

// 设置不同项目对应的wire_transfer_id（项目名应和$siteConf['crProjectList']中的项目名保持一致，包括大小写）
$siteConf['wireTransferIdList'] = array(
    'JJsHouse' => '158',
    'JenJenHouse' => '162',
    'DressFirst' => '155'
);

// 设置要接收订单支付转化率的email
$siteConf['crForEmail'] = array(
    'qi.zhong@gmail.com',
    'qzhong@leqee.com',
    'lchen@leqee.com',
    'zju@i9i8.com',
    'yzhang@i9i8.com',
    'hwang@i9i8.com',
    'mxu2@i9i8.com',
    'yfli@leqee.com',
    'qwang1@i9i8.com',
    'xlhong1@i9i8.com',
);

#// 设置要接收订单支付转化率的测试email
#$siteConf['crForTestEmail'] = array(
#    'xzhou1@i9i8.com',
#    'yzhang@i9i8.com'
#);

// 设置是否使用测试email接收订单支付转化率（true将使用测试email，false则使用正式email）
$siteConf['useCRTestEmail'] = false;

$siteConf['perPageArraySimple'] = array(20, 50, 100);
$siteConf['perPageArray'] = array(20, 50, 100, 500, 1000, 1500, 2000, 5000);
$siteConf['pageTotalSimple'] = 2000;

$siteConf['check_auth_user'] = true;

$siteConf['today_update_goods_notice_mail'] = array('risknotice@i9i8.com', 'yzhang@i9i8.com');

// 执行 SHOW VARIABLES LIKE 'time_zone'; SQL查看
$siteConf['dbtimezone_default'] = 'UTC';
$siteConf['sync_db_email'] = array('hwang@i9i8.com');
$siteConf['sync_db_per_limit'] = 50000;// 每次最多同步几条数据
$siteConf['sync_db_encrypt_key'] = 'jjshouse';
define('SYNC_DB_SOAP_LOGIN','lebbay420');
define('SYNC_DB_SOAP_PASSWORD','lebbay420api');
define('SYNC_DB_SOAP_JENJENHOUSE','https://cms.dummy.com/index.php?q=cron/soapSyncDB');

//short link
$siteConf['bitly_key'] = "59fa1f1cf31ae9da8e3f76514f8f09b0fd6e6b82";

$siteConf['syncGoodsWithCustomStyle'] = true;

$siteConf['1000vipReportMail'] = array('to'=>'qi.zhong@gmail.com', 'cc'=>array('jhding@i9i8.com','gzhang1@i9i8.com', 'yyu@i9i8.com', 'zhangpingping@i9i8.com','jjiang@i9i8.com'));

/* tax & duty */
$siteConf['sys_all_projects'] = array('Azazie');//, 'JenJenHouse', 'JennyJoseph', 'AmorModa', 'DressFirst');
$siteConf['taxEnableSites'] = array('Azazie');
// regions (uk, de, fr, us, ca, au)
$siteConf['taxVipRegionIds'] = array(3859, 4003, 4017, 3858, 3835, 3844);

$siteConf['send_comment_report_mail'] = array('to'=> 'qzhong@i9i8.com', 'cc' => array('mxu2@i9i8.com'/*, 'rzhang1@i9i8.com'*/));
$siteConf['send_comment_report_domains'] = array('Azazie');

$siteConf['force_new_goods'] = array(25520,25523,26073,19176,25617,28101,25381,19600,26281,19092,15324, 9147, 20910, 20839, 20989, 15327, 13812,
9882,27090,27378,28089,27094,25455, 27461,27232,28095,25384,18847, 19553,19596,19600,19601,19675, 19603,25361,26253,25617,26275, 27385,27382,25446,25447,19173,19584,25385,25383,25387,19100);

$siteConf['upfileDir_orderReview'] = '/opt/data1/jjsimg/order_review/';
$siteConf['upfileDir_orderReview_url'] = 'order_review/';

/* sales stat from rzhang1 */
$siteConf['statGoodsSale_ProjectList'] = array(
     'JJsHouse'
);
$siteConf['statGoodsSale_email'] = array(
     //'rzhang1@i9i8.com'
	'mxu2@i9i8.com',
	'hli2@i9i8.com',
);
$siteConf['statGoodsSale_testEmail'] = array(
     'hywang@i9i8.com'
);
$siteConf['statGoodsSale_useTestEmail'] = false;

$siteConf['black_friday_alert_email'] = array('to' => array('mxu2@i9i8.com'), 'cc' => '');

//feed monitor
$siteConf['feedAuth'] = array(
     'authName' => 'feedtest',
     'authPswd' => 'feedtest123',
);

$siteConf['alarm_mail_list'] = array(
	'dev' => 'yzhang@i9i8.com',
	'debug' => 'yzhang@tetx.com',
	'pre' => array(
		'bwzhang@i9i8.com',
		'bcheng@i9i8.com',
		'yzhang@i9i8.com',
		'hwang@i9i8.com'
	),
	'prod' => 'alarm@i9i8.com'
);
$siteConf['alarm_level'] = 'prod';

$siteConf['imageHost'] = 'http://img.azazie.com/';
$siteConf['cdn'] = 'http://__CDN_IMG1__/upimg/';

// ---- copy order
$siteConf['order_copy_notice'] = array(
    'yzhu2@i9i8.com',
);
$siteConf['API_URL'] = 'https://api-dd.opvalue.com/';
$siteConf['API_USERPWD'] = '__DD_API_USERPWD__';
$siteConf['API_PROJECT_NAME'] = 'dressdepot';

$siteConf['zendesk'] = array(
    "subdomain" => "azazie",
    "username" => "zendesk@azazie.com",
    "token" => "__ZENDESK_TOKEN__",
);
$siteConf['zendeskAlarmEmail'] = array(
	'alarm@i9i8.com'
);

$siteConf['order_copy_default_info'] = array(
    'user_id' => array(
        "user_id" => 557208,
    ),
    'address' => array(
        'consignee' => 'Q. Zhong',
        'gender' => 'male',
        'email' => 'purchase@azazie.com',
        'country' => '3859',
        'province' => '3871',
        'province_text' => '',
        'city' => '0',
        'city_text' => 'Mountain View',
        'district' => '',
        'district_text' => '',
        'address' => '650 Castro St., Suite 120-232',
        'zipcode' => '94041',
        'tel' => '4157668862',
        'mobile' => '',
        'sign_building' => '',
        'best_time' => '',
    ),
    'time' => array(
        "order_time" => "",
        "important_day" => "",
    ),
    'status' => array(
        "order_status" => 0,
        "shipping_status" => 0,
        "pay_status" => 0,
    ),
    'shipping' => array(
        "sm_id" => 1,
        "shipping_id" => 90,
    ),
    'payment' => array(
        "payment_id" => 97,
        "payment_name" => "paypal",
    ),
    'currency' => array(
        "base_currency_id" => 1,
        "order_currency_id" => 1,
        "order_currency_symbol" => "US$",
        "rate" => "100.0000/100.0000",
        "display_currency_id" => 1,
        "display_currency_rate" => "100.0000/100.0000",
    ),
    'language' => array(
        "language_id" => 1,
    ),
    'domain' => array(
        "from_domain" => "www.".$siteConf['API_PROJECT_NAME'].".com",
        "project_name" => $siteConf['API_PROJECT_NAME'],
    ),
    'amount' => array(
        "goods_amount" => 0,
        "goods_amount_exchange" => 0,
        "display_goods_amount_exchange" => 0,

        "shipping_fee" => 0,
        "shipping_fee_exchange" => 0,
        "display_shipping_fee_exchange" => 0,

        "duty_fee" => 0,
        "duty_fee_exchange" => 0,
        "display_duty_fee_exchange" => 0,

        "bonus" => 0,
        "bonus_exchange" => 0,
        "display_bonus_exchange" => 0,

        "order_amount" => 0,
        "order_amount_exchange" => 0,
        "display_order_amount_exchange" => 0,
    ),
);
$siteConf["pic_upload_dir"] = "/opt/data1/jjsimg/upimg/ticket/";

defined('NOTICE_EMAIL') || define('NOTICE_EMAIL', 'customerservice@'.$siteConf['proj_domain']);
defined('ALERT_EMAIL') || define('ALERT_EMAIL', 'customerservice@'.$siteConf['proj_domain']);

