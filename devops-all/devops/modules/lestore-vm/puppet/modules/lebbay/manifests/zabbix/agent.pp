define lebbay::zabbix::agent(
	$server_hostname = undef,
    $nodename = undef,
){
	#notify { "Puppet node name is $node_name." : }

	package {
		"zabbix22-agent":
			ensure  => latest,
			require => Yumrepo['p.epel'];
	}
	
	service {'zabbix-agentd' :
		enable => true,
		ensure => 'running',
		hasstatus => true,
		require => [Package['zabbix22-agent'], File['/etc/zabbix/zabbix_agentd.conf'], File['/etc/zabbix_agentd.conf.d']]
	}

    file { 
		'/etc/zabbix_agentd.conf' :
			content => template('lebbay/zabbix/zabbix_agentd.conf.erb'),
	        ensure  => file,
	        owner   => 'root',
	        group   => 'root',
	        mode	=> '644',
		notify => Service ['zabbix-agentd'];
		'/etc/zabbix/zabbix_agentd.conf' :
			require	=> File['/etc/zabbix_agentd.conf'],
			ensure	=> link,
			target => '/etc/zabbix_agentd.conf',
			notify => Service ['zabbix-agentd'];
    	'/var/job/check_search_server.sh' :
    		content => template('lebbay/zabbix/check_search_server.sh.erb'),
	        owner   => 'root',
	        group   => 'root',
	        require	=> File['/var/job'],
	        mode	=> '755';
		'/etc/zabbix_agentd.conf.d' :
			ensure => directory,
			owner   => 'root',
	        group   => 'root',
	        mode	=> '755',
	        require => Package['zabbix22-agent'];
    }
}