define lebbay::zabbix::agent::mysql()
{
	file { "zabbix_agent_mysql":
		path => "/etc/zabbix_agentd.conf.d/mysql",
		source => "puppet:///modules/lebbay/zabbix/conf/mysql",
		notify => Service ['zabbix-agentd'];
	}

	file { "/var/job/zabbix_mysql_slave.sh":
		source => "puppet:///modules/lebbay/zabbix/scripts/zabbix_mysql_slave.sh",
		mode => '755',
		require => File["zabbix_agent_mysql"];
	}

	file { "/var/job/zabbix_get_slave.sh":
		source => "puppet:///modules/lebbay/zabbix/scripts/zabbix_get_slave.sh",
		mode => '755',
		require => File["zabbix_agent_mysql"];
	}
}
