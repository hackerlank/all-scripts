<?php
/**
 * @version $Id: config.db.php 4876 2010-03-07 12:15:28Z yzhang $
 *
 * $dsn = "数据库类://用户名:密码@主机:端口/数据库名/编码/是否新建链接/是否长链接";
 */

$dbname = array();
$siteConf = isset($siteConf) && is_array($siteConf) ? $siteConf : array();

$dbname['uni'] = 'azazie'; // database name
$siteConf['dsn']['uni']['writer'] = "MySQL://jjs0517cms:azaziecommonpass@__DB_HOST__:3306/{$dbname['uni']}/utf8/true/false";
$siteConf['dsn']['uni']['reader'] = $siteConf['dsn']['uni']['writer'];

$dbname['www'] = 'azazie'; // database name
$siteConf['dsn']['www']['writer'] = "MySQL://jjs0517cms:azaziecommonpass@__DB_HOST__:3306/{$dbname['www']}/utf8/true/false";
//$siteConf['dsn']['www']['reader'] = $siteConf['dsn']['www']['writer'];
$siteConf['dsn']['www']['reader'] = "MySQL://jjs0517cms:azaziecommonpass@__DB_SLAVE_HOST__:3306/{$dbname['www']}/utf8/true/false";


?>
