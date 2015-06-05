define lebbay::zabbix::agent::mysql_status()
{
	file { "zabbix_agent_mysql_status":
		path => "/etc/zabbix_agentd.conf.d/userparameter_mysql.conf",
		source => "puppet:///modules/lebbay/zabbix/conf/userparameter_mysql.conf",
		notify => Service ['zabbix-agentd'];
	}

	file { "/var/job/zabbix_mysql.sh":
		source => "puppet:///modules/lebbay/zabbix/scripts/zabbix_mysql.sh",
		mode => '755',
		require => File["zabbix_agent_mysql_status"];
	}
}
