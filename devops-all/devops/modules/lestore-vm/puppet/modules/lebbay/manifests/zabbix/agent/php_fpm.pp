define lebbay::zabbix::agent::php_fpm()
{
	file { "zabbix_agent_php_fpm":
		path => "/etc/zabbix_agentd.conf.d/userparameter_php_fpm_status.conf",
		source => "puppet:///modules/lebbay/zabbix/conf/userparameter_php_fpm_status.conf",
		notify => Service ['zabbix-agentd'];
	}

	file { "/var/job/zabbix_php_fpm_status.sh":
		source => "puppet:///modules/lebbay/zabbix/scripts/zabbix_php_fpm_status.sh",
		mode => '755',
		require => File["zabbix_agent_php_fpm"];
	}
}
