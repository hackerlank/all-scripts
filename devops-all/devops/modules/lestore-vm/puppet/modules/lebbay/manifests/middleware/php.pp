class lebbay::middleware::php(
    $binary_repo = $lebbay::params::binary_repo,
    $user = $lebbay::params::user,
    $group = $lebbay::params::group,
    $rootdir = $lebbay::params::rootdir,
    $datadir = $lebbay::params::datadir,
    $version = $lebbay::params::php_version,
    $composer_url = $lebbay::params::composer_url
){

    #    package {
    #      'libmcrypt' :
    #        ensure => present;
    #      'mysql-libs' :  #'mysql55-libs' :
    #        ensure => present; #'5.5-1.3.amzn1'
    #      'libxml2' :
    #        ensure => present;
    #      'bzip2' :
    #        ensure => present;
    #      'curl' :
    #        ensure => present;
    #      'libjpeg' :
    #        ensure => present;
    #      'libpng' :
    #        ensure => present;
    #      'libXpm' :
    #        ensure => present;
    #      'gd' :
    #        ensure => present;
    #      'freetype' :
    #        ensure => present;
    #      'gmp' :
    #        ensure => present;
    #    }

    #file { 'php_rpm' :
	#	ensure   =>  present,
	#	path 	 => "$rootdir/php-5.3.20-1.lebbay.x86_64.rpm",
	#	source   => "puppet:///modules/lebbay/php/binaries/php-5.3.20-1.lebbay.x86_64.rpm",
	#}

    package { 'php' :
        #require => [Package['libmcrypt'],Package['mysql55-libs'],Package['curl'],Package['libjpeg'],Package['libpng'],Package['libXpm'],Package['gd'],Package['freetype'],Package['gmp'],Package['bzip2'], Package['libxml2']],
        alias   => 'php',
        ensure  => "$version", # could be a version number
        #provider => 'rpm',
        #source   => "$rootdir/php-5.3.20-1.lebbay.x86_64.rpm",
        #require => File['php_rpm'],
    }

    $php_exts = ["php-pecl-xhprof", "php-pecl-memcache", "php-pecl-memcached", "php-pecl-redis", "php-fpm", "php-devel", "php-mysql", "php-pdo", "php-pear", "php-mbstring", "php-cli", "php-odbc", "php-imap", "php-gd", "php-xml", "php-soap"]
	package {$php_exts : ensure => installed, require => Package['php'],}

    package { 'php-pecl-apc' :
        ensure => absent,
    }

#   file { 'opcache-rpm' :
#       ensure => present,
#       path   => "/home/ec2-user/php-pecl-zendopcache-7.0.3-1.el6.x86_64.rpm",
#   	source => "puppet:///modules/lebbay/php/binaries/php-pecl-zendopcache-7.0.3-1.el6.x86_64.rpm",
#   }
#   package {'php-pecl-zendopcache-7.0.3-1.el6' :
#       provider => 'rpm',
#       ensure   => installed,
#   	source   => "/home/ec2-user/php-pecl-zendopcache-7.0.3-1.el6.x86_64.rpm",
#       notify   => Service['php-fpm'],
#       require  => [File['opcache-rpm'], Package['php']]
#   }

    file { 'php_exec' :
        ensure  => link,
        path    => "/usr/local/bin/php",
        owner   => "$user",
        group   => "$group",
        target  => "/usr/bin/php",
        require => Package['php'],
    }

#    file { 'php_home' :
#        ensure  => link,
#        path    => "$lebbay::params::rootdir/php",
#        owner   => "$user",
#        group   => "$group",
#        target  => "$lebbay::params::rootdir/php5.3",
#        require => Package['php'],
#    }

#	file { 'php-fpm.init' :
#   	ensure  => present,
#   	path    => "/etc/init.d/php-fpm",
#   	owner   => "root",
#   	group   => "root",
#   	mode    => '0744',
#   	source  => "puppet:///modules/lebbay/php/php-fpm",
#   	require => Package['php'],
#	}

    service { 'php-fpm':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => false,
        require    => Package["php-fpm"],
    }

    file { "$rootdir/php.ini" :
        	owner   => "$user",
        	group   => "$group",
        	mode    => '0644',
        	source  => 'puppet:///modules/lebbay/php/etc/php.ini',
        	notify  => Service['php-fpm'],
        	require => Package['php'];
        "$rootdir/php.d/apc.ini" :
    		ensure  => absent,
    		notify  => Service['php-fpm'],
    		require => Package["php-pecl-apc"];
    	"$rootdir/php.d/memcache.ini" :
    		ensure  => absent,
    		notify  => Service['php-fpm'],
    		require => Package["php-pecl-memcache"];
    	"$rootdir/php.d/xhprof.ini" :
    		ensure  => absent,
    		notify  => Service['php-fpm'],
    		require => Package["php-pecl-xhprof"];
    }

    file { "$rootdir/php-fpm.conf" :
        owner   => "$user",
        group   => "$group",
        mode    => '0644',
        source  => 'puppet:///modules/lebbay/php/etc/php-fpm.conf',
        notify  => Service['php-fpm'],
        require => Package['php'],
    }

    file { "$rootdir/php-fpm.d/www.conf" :
    	mode    => '0644',
    	source  => 'puppet:///modules/lebbay/php/etc/www.conf',
    	notify  => Service['php-fpm'],
    	require => [Package['php-fpm'], File["$rootdir/php-fpm.conf"]];
    	"/var/log/php-fpm" :
    	owner   => "$user",
    	group	=> "$group",
        mode    => '0755',
    	notify  => Exec['php-fpm-mode'],
    	require => Package['php-fpm'];
    }

    exec { "php-fpm-mode":
    	path   	=> ["/bin", "/usr/bin"],
    	command => "find /var/log/php-fpm -type f | xargs -I {} chmod 0644 {}";
    }

    exec { "install-composer":
        command => "curl -sS $composer_url | sudo php -- --install-dir=/usr/local/bin/",
        path => ["/usr/bin", "/usr/local/bin", "/bin"],
        unless => "test -x /usr/local/bin/composer.phar",
	    require => Package['php'];
    }

    file { "composer_link":
	    path => "/usr/local/bin/composer",
	    ensure => link,
	    target => "/usr/local/bin/composer.phar";
    }

    #    file { 'php.d' :
    #      path    => "$rootdir/php/etc/php.d",
    #      ensure  => directory,
    #      owner   => "$user",
    #      group   => "$group",
    #      require => Package['php'],
    #    }

    #file { 'eaccelerator_cache_dir' :
    #    path   => "$datadir/eaccelerator",
    #    ensure => directory,
    #    owner  => "$user",
    #    group  => "$group",
    #}
    #file { 'eaccelerator_cache_dir_cache' :
    #    path    => "$datadir/eaccelerator/cache",
    #    ensure  => directory,
    #    owner   => "$user",
    #    group   => "$group",
    #    require => File['eaccelerator_cache_dir'],
    #}

    #    lebbay::middleware::php::extension{ 'php-eaccelerator':
    #      version => '0.9.6.1-1.lebbay',
    #      require => [File['php.d'], File['eaccelerator_cache_dir_cache']],
    #      notify  => Service['php-fpm'],
    #    }

    file { 'memcache_cache_dir' :
        path   => "$datadir/memcache",
        ensure => directory,
        owner  => "$user",
        group  => "$group",
    }
    #    lebbay::middleware::php::extension{ 'php-pecl-memcache':
    #      version => '3.0.6-1.lebbay',
    #      require => [File['php.d'], File['memcache_cache_dir']],
    #      notify  => Service['php-fpm'],
    #    }

    file { 'xhprof_dir' :
        path   => "$datadir/xhprof",
        ensure => directory,
        owner  => "$user",
        group  => "$group",
    }

    #    lebbay::middleware::php::extension{ 'php-pecl-xhprof':
    #      version => '0.9.2-1.lebbay',
    #      require => [File['php.d'], File['xhprof_dir']],
    #      notify  => Service['php-fpm'],
    #    }

    file { 'stem' :
        path   => "/usr/lib64/php/modules/stem.so",
        ensure => present,
        owner  => "root",
        group  => "root",
		source   => "puppet:///modules/lebbay/php/binaries/stem.so",
        notify  => Service['php-fpm'],
        require => Package['php'],
        mode   => 0755,
    }

    # for php 5.3
    file { 'elasticache.so' :
        path    => "/usr/lib64/php/modules/amazon-elasticache-cluster-client.so",
        ensure => present,
        source => "puppet:///modules/lebbay/php/binaries/amazon-elasticache-cluster-client.so",
        owner  => "root",
        group  => "root",
        mode   => 0755,
    }

    file { 'elasticache.ini' :
        path => '/etc/php.d/memcached.ini',
        ensure => present,
        source => "puppet:///modules/lebbay/php/etc/php.d/aws.elasticache.ini",
        owner  => "root",
        group  => "root",
        mode   => 0644,
        require => [Package['php'],File['elasticache.so']],
        notify  => Service['php-fpm'],
    }

    file { 'opcache.so' :
        path    => "/usr/lib64/php/modules/opcache.so",
        ensure => present,
        source => "puppet:///modules/lebbay/php/binaries/opcache.so",
        owner  => "root",
        group  => "root",
        mode   => 0755,
    }

    file {
        'opcache.ini' :
            path => '/etc/php.d/opcache.ini',
            ensure => present,
            source => "puppet:///modules/lebbay/php/etc/php.d/opcache.ini",
            owner  => "root",
            group  => "root",
            mode   => 0644,
            require => [Package['php'],File['opcache.so']],
            notify  => Service['php-fpm'];
        'opcache-default.blacklist' :
            path => '/etc/php.d/opcache-default.blacklist',
            ensure => present,
            source => "puppet:///modules/lebbay/php/etc/php.d/opcache-default.blacklist",
            owner  => "root",
            group  => "root",
            mode   => 0644,
            require => [Package['php'],File['opcache.so']],
            notify  => Service['php-fpm'];
    }
}
