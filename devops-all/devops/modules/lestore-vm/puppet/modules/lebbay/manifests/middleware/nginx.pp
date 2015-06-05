class lebbay::middleware::nginx(
    $user = $lebbay::params::user,
    $group = $lebbay::params::group,
    $rootdir = $lebbay::params::rootdir,
    $datadir = $lebbay::params::datadir,
    $version = $lebbay::params::nginx_version,
    $appname = undef,
){

    include lebbay::os
    #file { 'nginx_rpm' :
	#	ensure   =>  present,
	#	path 	 => "$rootdir/nginx-1.2.6-1.lebbay.x86_64.rpm",
	#	source   => "puppet:///modules/lebbay/nginx/binaries/nginx-1.2.6-1.lebbay.x86_64.rpm",
	#}
	
    package { 'nginx' :
        ensure   => "$version", # could be a version number
        alias    => 'nginx',
        #provider => 'rpm',
        #source   => "$rootdir/nginx-1.2.6-1.lebbay.x86_64.rpm",
        #require => File['nginx_rpm'],
    }

    file { 'nginxlogs' :
        path   => "$datadir/nginxlogs",
        ensure => directory,
        owner  => "$user",
        group  => "$group",
    }

    file { 'nginxproxycache' :
        ensure  => directory,
        path    => "$datadir/nginxproxycache",
        owner   => "$user",
        group   => "$group";
    'nginxproxycache_cache' :
        ensure  => directory,
        path    => "$datadir/nginxproxycache/proxy_cache_dir",
        owner   => "$user",
        group   => "$group",
        require => File['nginxproxycache'];
    'nginxproxycache_temp' :
        ensure  => directory,
        path    => "$datadir/nginxproxycache/proxy_temp_dir",
        owner   => "$user",
        group   => "$group",
        require => File['nginxproxycache'];
    'nginxproxycache_client' :
        ensure  => directory,
        path    => "$datadir/nginxproxycache/client_temp",
        owner   => "$user",
        group   => "$group",
        require => File['nginxproxycache'];
    }

    file { 
    'app-snippets':
        path => "$rootdir/nginx/app-snippets",
        ensure  => directory,
        owner   => "$user",
        group   => "$group",
        notify  => Service['nginx'],
        require => Package['nginx'];
    'sites-enabled':
        path => "$rootdir/nginx/sites-enabled",
        ensure  => directory,
        owner   => "$user",
        group   => "$group",
        notify  => Service['nginx'],
        require => Package['nginx'];
    'ssl':
        path => "$rootdir/nginx/ssl",
        ensure  => directory,
        owner   => "$user",
        group   => "$group",
        notify  => Service['nginx'],
        require => Package['nginx'];
    'fastcgi_params' :
        path   => "$rootdir/nginx/fastcgi_params",
        ensure => present,
        source => 'puppet:///modules/lebbay/nginx/conf/fastcgi_params',
        notify  => Service['nginx'],
        require => Package['nginx'];
    'nginx_logs':
        path    => "/usr/share/nginx/logs",
        ensure  => link,
        force   => true,
        target  => "$datadir/nginxlogs",
        owner   => "$user",
        group   => "$group",
        notify  => Service['nginx'],
        require => [Package['nginx'], File['nginxlogs']];
    'index_html':
    	path    => "/usr/share/nginx/html/index.html",
        ensure  => present,
        owner   => "$user",
        group   => "$group",
        source  => 'puppet:///modules/lebbay/nginx/conf/index.html',
        require => [Package['nginx']];   
     'nginx_dir' :
     	path	=> "/var/lib/nginx",
     	ensure  => "present",
     	owner	=> $user,
     	group	=> $group,
     	recurse => true,
     	require => Package['nginx'];	
     '/var/log/nginx' :
     	ensure  => "present",
     	owner	=> $user,
     	group	=> $group,
     	require => Package['nginx'];	
     '/etc/logrotate.d/nginx' :
        ensure  => present,
	source  => "puppet:///modules/lebbay/nginx/conf/nginx_logrotate",
	require => Package['nginx'];
    }

    service { 'nginx' :
        enable    => true,
        ensure    => 'running',
        restart   => '/sbin/service nginx reload',
        hasstatus => true,
        require   => [Package['nginx'], File['nginxproxycache'], File['nginxlogs']],
    }

    if $appname == "azazie" {
        file {
            'nginx_conf' :
            path    => "$rootdir/nginx/nginx.conf",
            ensure  => present,
            source  => 'puppet:///modules/lebbay/nginx/conf/nginx_zz.conf',
            notify  => Service['nginx'],
            require => [Package['nginx']];
            'cloudflare_conf' :
            path    => "$rootdir/nginx/cloudflare.conf",
            ensure  => present,
            source  => 'puppet:///modules/lebbay/nginx/conf/cloudflare.conf',
            notify  => Service['nginx'],
            require => [Package['nginx']];
        }
    }
    else {
        file{
            'nginx_conf' :
            path    => "$rootdir/nginx/nginx.conf",
            ensure  => present,
            source  => 'puppet:///modules/lebbay/nginx/conf/nginx.conf',
            notify  => Service['nginx'],
            require => [Package['nginx']];
        }
    }
}

