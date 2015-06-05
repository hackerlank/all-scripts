<?php
use Monolog\Logger;

$siteConf = array_merge($siteConf, array(
    'node' => 'zzp1',

    'db_timezone' => 'America/Los_Angeles',
    'db_host' => "__DB_HOST__",
    'db_name' => "vbridal",
    'db_user' => "jjs0517fe",
    'db_pass' => "vbridalcommonpass",

    'log_level' => Logger::ERROR,
    'log_dir' => $APP_FS_ROOT.'var/logs',
    'fs_repo' => $APP_FS_ROOT.'var/repo',

    'cache_cluster' => array(
        array('__MC_CLUSTER_NODE1__', 11211),
        array('__MC_CLUSTER_NODE2__', 11211),
    ),
    'cache_dynamic' => array('__MC_DYNAMIC__', 11211),
    'cache_timeout' => 3600 * 24 * 7,

    'SOAP_OSTICKET_URL' => 'http://t.vbridal.com/osticket/api/soap.php',
    'SOAP_LOGIN' => 'lebbay420',
    'SOAP_PASSWORD' => 'lebbay420api',
));
