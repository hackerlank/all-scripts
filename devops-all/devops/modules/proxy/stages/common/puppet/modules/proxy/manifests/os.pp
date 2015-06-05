class proxy::os(
    $salt_master = $proxy::params::salt_master,
    $nodename = $proxy::params::nodename,
    $shadowsocks_pwd = $proxy::params::shadowsocks_pwd,
    $shadowsocks_port =$proxy::params::shadowsocks_port,
    $enable_shadowsocks = false,
)
{

if $operatingsystem == 'Amazon' {
    yumrepo { 'p.epel':        
        descr          => 'Extra Packages for Enterprise Linux 6 - $basearch',
        #baseurl       => "$repo",      
        mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
        gpgcheck       => 1,   
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
        enabled        => 1,   
        priority       => 99,  
        #timeout       => 10,  
        failovermethod => 'priority',   
    }
   
    $squid = 'squid'
    $ncsa = "/etc/$squid/ncsa_auth"
    $target = "/usr/lib64/squid/ncsa_auth"

    file {
      "squid_conf_dir":
        path => "/etc/$squid",
        ensure => directory,
	require => Package["$squid"];
      "ncsa_bin":
        path => "$ncsa",
        ensure => link,
        target => "$target",
        require => Package["$squid"];
    }

    if $enable_shadowsocks == true {
        file { 
        "shadowsocks_rpm":
	    path => '/tmp/shadowsocks-1.0-1.x86_64.rpm',
       	    ensure => present,
    	    source => 'puppet:///modules/proxy/pkg/shadowsocks-1.0-1.x86_64.rpm';
	"shadowsocks_dir":
	    ensure => directory,
	    path   => '/etc/shadowsocks',
	    owner  => 'root',
	    group  => 'root',
	    mode   => '0755';
	"shadowsocks_conf":
	    path => '/etc/shadowsocks/config.json',
	    mode => '0644',
	    owner  => 'root',
	    group  => 'root',
	    content => template('proxy/etc/config.json.erb'),
	    require => File['shadowsocks_dir'];
	"shadowsocks_script":
	    path => '/etc/init.d/shadowsocks',
	    mode => '0755',
	    owner  => 'root',
	    group  => 'root',
	    source => 'puppet:///modules/proxy/os/etc/shadowsocks';
        }
        
        package { 'shadowsocks':
            ensure => installed,
            provider => 'rpm',
            source => '/tmp/shadowsocks-1.0-1.x86_64.rpm',
            require  => [File["shadowsocks_rpm"]];
        }

	service { 'shadowsocks':
	   ensure => 'running',
	   enable => true,
	   hasrestart => true,
	   hasstatus => true,
	   require => [Package['shadowsocks'], File['shadowsocks_script'], File['shadowsocks_conf']];
	}
    }
}
elsif $operatingsystem == 'Ubuntu' {
    include apt
    apt::ppa { 'ppa:saltstack/salt': }
    exec {'apt-get-update':
	path    => ["/usr/bin", "/usr/sbin"],
	command => 'apt-get update',
	require => Apt::Ppa["ppa:saltstack/salt"];
    }
    $squid = 'squid3'
    $link = "/etc/squid"
    $ncsa = "/etc/$squid/ncsa_auth"
    $target = "/usr/lib/squid3/ncsa_auth"

    file {
      "squid_conf_dir":
        path => "$link",
        ensure => link,
        target => "/etc/$squid",
	require => Package["$squid"];
      "ncsa_bin":
        path => "$ncsa",
        ensure => link,
        target => "$target",
        require => [Package["$squid"], File["squid_conf_dir"]];
    }

}

    package { "salt-minion":
	ensure => 'present',
	require => Yumrepo['p.epel'];
	"$squid":
	ensure => 'present',
	require => Yumrepo['p.epel'];
	"git":
	ensure => 'present',
	require => Yumrepo['p.epel'];
    }

    file { "/etc/salt/minion":
	ensure => present,
	owner => 'root',
	group => 'root',
	content => template('proxy/minion.erb'),
	notify => Service['salt-minion'],
	require => Package['salt-minion'];
    }

    file {
      "squid_conf_d":
	ensure => directory,
	path => "/etc/$squid/conf.d",
	owner => 'root',
	group => 'root',
	require => Package["$squid"];
    }

    file { "empty_conf":
	ensure => present,
	path => "/etc/$squid/conf.d/empty.conf",
	owner => 'root',
	group => 'root',
	require => File["squid_conf_d"];
    }

    service { "salt-minion":
	ensure => 'running',
	enable => true,
	hasstatus => true,
	require => [Package['salt-minion'], File['/etc/salt/minion']];
	"$squid":
	ensure => 'running',
	hasstatus => true,
	require => [Package["$squid"], File["squid_conf_dir"], File["empty_conf"], File["ncsa_bin"]];
    }

    proxy::os::user { "syncer":
	ensure => 'present',
    }

    proxy::os::user { "httpproxy":
        ensure => 'present',
	shell => '/bin/false';
    }
}
