<?php
$APP_FS_ROOT = dirname(__DIR__);
// include $APP_FS_ROOT . '/data/env_config.php';
$templates_dir = $APP_FS_ROOT . '/var/log/';

$siteConf = array(
	'domain' => 'Vbridal',
	'stage' => 'cms',
	'version' => '001',

	'log_dir' => $templates_dir
);
