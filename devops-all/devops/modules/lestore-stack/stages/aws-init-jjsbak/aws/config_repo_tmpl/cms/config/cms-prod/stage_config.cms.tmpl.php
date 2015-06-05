<?php
$siteConf = array_merge($siteConf, array(
	'node' => 'cms',
	'db_host' => "__DB_HOST__",
	'db_name' => "jjshouse",
	'db_user' => "jjs0517cms",
	'db_pass' => "jjshousecommonpass",

	'log_level' => \Monolog\Logger::ERROR,
	'cache_timeout' => 60, //seconds


	'rs_server' => isset($rs_server) ? $rs_server : '/',

	'twig.debug' => false,
	'twig.strict' => false,
	'twig.cache' => false,

	'slim.log.level' => \Slim\Log::ERROR,
	'slim.debug' => false,
	'slim.mode' => 'development',
)
);
