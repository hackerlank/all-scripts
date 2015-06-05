<?php
/*********************************************************************
    ost-config.php

    Static osTicket configuration file. Mainly useful for mysql login info.
    Created during installation process and shouldn't change even on upgrades.

    Peter Rotich <peter@osticket.com>
    Copyright (c)  2006-2010 osTicket
    http://www.osticket.com

    Released under the GNU General Public License WITHOUT ANY WARRANTY.
    See LICENSE.TXT for details.

    vim: expandtab sw=4 ts=4 sts=4:
    $Id: $
**********************************************************************/

#Disable direct access.
if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__)) || !defined('ROOT_PATH')) die('kwaheri rafiki!');

#Install flag
define('OSTINSTALLED',TRUE);
if(OSTINSTALLED!=TRUE){
    if(!file_exists(ROOT_PATH.'setup/install.php')) die('Error: Contact system admin.'); //Something is really wrong!
    //Invoke the installer.
    header('Location: '.ROOT_PATH.'setup/install.php');
    exit;
}

# Encrypt/Decrypt secret key - randomly generated during installation.
define('SECRET_SALT','%CONFIG-SIRI');

#Default admin email. Used only on db connection issues and related alerts.
define('ADMIN_EMAIL','%ADMIN-EMAIL');

#Mysql Login info
define('DBTYPE','mysql');
define('DBHOST','__DB_HOST__');
define('DBNAME','jjshouse');
#define('DBUSER','jjshouseticket');
define('DBUSER','jjs0517ticket');
#define('DBPASS','ympMhMwVxjGt3UjY');
define('DBPASS','jjshousecommonpass');

#Table prefix
define('TABLE_PREFIX','ost_');

if (!defined('SOAP_LOGIN')) {
        define('SOAP_LOGIN','lebbay420');
}
if (!defined('SOAP_PASSWORD')) {
        define('SOAP_PASSWORD','lebbay420api');
}

$siteConf['proj_name_upper'] = 'JJsHouse';
$siteConf['proj_name'] = strtolower($siteConf['proj_name_upper']);
$siteConf['proj_domain_upper'] = $siteConf['proj_name_upper'] . '.com';
$siteConf['proj_domain'] = $siteConf['proj_name'] . '.com';

define('PROJECT_NAME', $siteConf['proj_name_upper']);
define('PROJECT_NAME_LOWER', $siteConf['proj_name']);
define('SITE_DOMAIN_ROOT', $siteConf['proj_domain_upper']);
define('SITE_DOMAIN',$siteConf['proj_domain']);
defined('SERVICE_EMAIL') || define('SERVICE_EMAIL', 'service@' . SITE_DOMAIN);
defined('NOTICE_EMAIL') || define('NOTICE_EMAIL', 'notice@' . SITE_DOMAIN);
defined('ALERT_EMAIL') || define('ALERT_EMAIL', 'notice@' . SITE_DOMAIN); #changed according to mxu2
defined('BAK_EMAIL') || define('BAK_EMAIL', 'folder@' . SITE_DOMAIN);

define('CMS_TICKET_SOAP','https://cms.' . SITE_DOMAIN . '/index.php?q=soapTicket');
define('SCP_UPLOAD_URL','http://up.' . SITE_DOMAIN . '/osticket/scp/upload_file.php');
#define('PIC_URL_CDN','http://d3bvl598xc7qos.cloudfront.net/upimg/ticket/');
define('PIC_URL_CDN','http://img.%domain/ticket/');
#define('PIC_URL_ORI','http://img.' . SITE_DOMAIN . '/ticket/');
define('PIC_URL_ORI','http://img.%domain/ticket/');

$siteConf['aws_config'] = array(
        'AWS_KEY' => '__AWS_ACCESS_KEY__',
        'AWS_SECRET_KEY' => '__AWS_SECRET_KEY__'
);

define('XHPROF_ROOT','/var/www/xhprof-0.9.2');// xhprof路径
define('XHPROF_VIEW_URL','http://t.jjshouse.com/xhprof_html/'); // xhprof查看地址

$siteConf['cache'] = array(
    'memcache' => array(
        'servers' => array(
            'host' => '__MC_CLUSTER_NODE1__',
            'port' => 11211
        )
    )
);

defined('FILTER_WORD_EMAIL') || define('FILTER_WORD_EMAIL', 'risknotice@i9i8.com');

define('CHECK_AUTH_USER', true);
