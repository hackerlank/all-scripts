define lebbay::zabbix::agent::nginx()
{
	file { "zabbix_agent_nginx":
		path => "/etc/zabbix_agentd.conf.d/userparameter_nginx_stub_status.conf",
		source => "puppet:///modules/lebbay/zabbix/conf/userparameter_nginx_stub_status.conf",
		notify => Service ['zabbix-agentd'];
	}

	file { "/var/job/zabbix_nginx_stub_status.sh":
		source => "puppet:///modules/lebbay/zabbix/scripts/zabbix_nginx_stub_status.sh",
		mode => '755',
		require => File["zabbix_agent_nginx"];
	}
}
