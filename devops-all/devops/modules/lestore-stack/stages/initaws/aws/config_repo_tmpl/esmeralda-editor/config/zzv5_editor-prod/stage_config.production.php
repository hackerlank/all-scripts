<?php
use Monolog\Logger;
global $APP_FS_ROOT;

$siteConf = array_merge($siteConf, array(
    'db_host' => "__DB_HOST__",
    'db_name' => "azazie",
    'db_user' => "jjs0517editor",
    'db_pass' => "azaziecommonpass",
    'db_conf' => array(
        // db name
        'Azazie' => array(
            'db_host' => "__DB_HOST__",
            'db_name' => "azazie",
            'db_user' => "jjs0517editor",
            'db_pass' => "azaziecommonpass",
        ),
    ),

    'login' => array('user' => 'lebbay', 'pwd' => 'passw0rd'),

    // root path of display image files
//    'disImgRoots' => array(
//        'JJsHouse' => 'http://v5editor.dhvalue.com/upload',
//        'JenJenHouse' => 'http://v5editor.dhvalue.com/upload',
//        'DressFirst' => 'http://v5editor.dhvalue.com/upload',
//    ),
    'disImgRoots' => array(
	'Azazie' => '//__CDN_IMG1__/v5res',
    ),

    'log_level' => Logger::ERROR,
    'log_dir' => $APP_FS_ROOT.'/var/log',
    'fs_repo' => $APP_FS_ROOT.'/var/repo',

    'cache_cluster' =>  array(
        array('__MC_CLUSTER_NODE1__', 11211),
        array('__MC_CLUSTER_NODE2__', 11211),
    ),
    'cache_timeout' => 60,//seconds

    //'rs_server' => isset($rs_server) ? $rs_server : '/',

    'twig.debug' => false,
    'twig.strict' => false,
    'twig.cache' => $APP_FS_ROOT.'/var/twig',

    'slim.log.level' => \Slim\Log::ERROR,
    'slim.debug' => false,
    'slim.mode' => 'production',
));
