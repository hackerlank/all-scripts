define lebbay::zabbix::server (
    $nodename = undef,
) {
    package {
        'httpd':
            ensure => installed,
            require => Yumrepo['p.epel'];
        'php':
            ensure => present,
            require => Yumrepo['p.epel'];
        'php-gd':
            ensure => present,
            require => Yumrepo['p.epel'];
        'php-xml':
            ensure => present,
            require => Yumrepo['p.epel'];
        'php-mysql':
            ensure => present,
            require => Yumrepo['p.epel'];
        'php-bcmath':
            ensure => present,
            require => Yumrepo['p.epel'];
        'php-mbstring':
            ensure => present,
            require => Yumrepo['p.epel'];
        'mysql55':
            ensure => present,
            require => Yumrepo['p.epel'];
        'mysql55-server':
            ensure => present,
            require => Yumrepo['p.epel'];
        'curl':
            ensure => present,
            require => Yumrepo['p.epel'];
        'libcurl-devel':
            ensure => present,
            require => Yumrepo['p.epel'];
        'net-snmp':
            ensure => present,
            require => Yumrepo['p.epel'];
        'net-snmp-devel':
            ensure => present,
            require => Yumrepo['p.epel'];
    }
    $zabbix22_pack = ['zabbix22','zabbix22-server','zabbix22-server-mysql', 'zabbix22-web', 'zabbix22-web-mysql']
    package { $zabbix22_pack:
      ensure => latest,
      require => Yumrepo['p.epel'],
      before => Service['zabbix-server'];
    }
    package {
        'zabbix22-server-pgsql':
	    before => Service['zabbix-server'],
            ensure => absent;
	'zabbix22-dbfiles-pgsql':
	    before => Service['zabbix-server'],
	    require => Package['zabbix22-server-pgsql'],
            ensure => absent;
    }
    service {
        'httpd':
            ensure => running,
            require => Package['httpd'],
            subscribe => [File['php.ini'], File['httpd.conf']];
        'mysqld':
            ensure => running,
            require => Package['mysql55-server'];
        'zabbix-server':
            ensure => running,
            subscribe => File['zabbix_server.conf'];
    }
    file {
        'httpd.conf':
            path => '/etc/httpd/conf/httpd.conf',
            source => 'puppet:///modules/lebbay/zabbix/conf/httpd.conf',
            ensure => file,
            require => Package['httpd'];
        'php.ini':
            path => '/etc/php.ini',
            source => 'puppet:///modules/lebbay/zabbix/conf/php.ini',
            ensure => file;
        'zabbix_server.conf':
            path => '/etc/zabbix_server.conf',
            source => 'puppet:///modules/lebbay/zabbix/conf/zabbix_server.conf',
            ensure => file,
	          owner => 'root',
	          group => 'zabbixsrv',
            mode => 0640,
	    require => Package["zabbix22-server"];
    }
}
