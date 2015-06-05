class lebbay::zabbix(
    $server_hostname = undef,
    $nodename = undef,
    $type = undef,
){
	if $type == "agent" {
		lebbay::zabbix::agent{ "zabbix_agent":
			server_hostname => $lebbay::params::zabbix_server,
			nodename => "$nodename",
		}
	}
    if $type == "server" {
        lebbay::zabbix::server { 'zabbix_server':
			nodename => "$nodename",
        }
    }
}
