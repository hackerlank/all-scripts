class lebbay::middleware::php55(
    $user = $lebbay::params::user,
    $group = $lebbay::params::group,
    $rootdir = $lebbay::params::rootdir,
    $datadir = $lebbay::params::datadir,
    $version = $lebbay::params::php55_version,
    $composer_url = $lebbay::params::composer_url
){
    $php_pkgs = ["php55-fpm","php55-gmp","php55-pdo","php55-mbstring","php55-imap","php55-soap","php55-opcache","php55-mysqlnd","php55-gd"]
    package { $php_pkgs :
        ensure  => "$version", # could be a version number
    }
    #"php55-pecl-redis","php-mysql","php-pecl-xhprof","php55-devel",
    $php_exts = ["php55-pecl-memcached","php55-pecl-xdebug"]
    package { $php_exts :
        ensure => installed,
        require => Package['php55-fpm'],
    }

    service { 'php-fpm':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => false,
        require    => Package["php55-fpm"],
    }

    file {
        "/var/log/php-fpm/5.5" :
            ensure => directory,
        	owner   => "$user",
        	group   => "root",
        	mode    => '0777',
        	notify  => Service['php-fpm'],
        	require => Package['php55-fpm'];
        "$rootdir/php-5.5.ini" :
        	owner   => "$user",
        	group   => "$group",
        	mode    => '0644',
        	source  => 'puppet:///modules/lebbay/php/etc/php-5.5.ini',
        	notify  => Service['php-fpm'],
        	require => Package['php55-fpm'];
    	"$rootdir/php-5.5.d/stem.ini" :
    		notify  => Service['php-fpm'],
    		require => File["stem"],
            source  => "puppet:///modules/lebbay/php/etc/php.d/stem.ini";
    	"$rootdir/php-5.5.d/twig.ini" :
    		notify  => Service['php-fpm'],
    		require => File["twig"],
            source  => "puppet:///modules/lebbay/php/etc/php.d/twig.ini";
    	"$rootdir/php-5.5.d/xhprof.ini" :
    		notify  => Service['php-fpm'],
    		require => [File["xhprof"], File["xhprof_dir"]],
            source  => "puppet:///modules/lebbay/php/etc/php.d/php-pecl-xhprof.ini";
    }

    file {
        'opcache.ini' :
            path => '/etc/php-5.5.d/opcache.ini',
            ensure => present,
            source => "puppet:///modules/lebbay/php/etc/php.d/opcache-5.5.ini",
            owner  => "root",
            group  => "root",
            mode   => 0644,
            require => Package['php55-opcache'],
            notify  => Service['php-fpm'];
        'opcache-default.blacklist' :
            path => '/etc/php-5.5.d/opcache-default.blacklist',
            ensure => present,
            source => "puppet:///modules/lebbay/php/etc/php.d/opcache-default.blacklist",
            owner  => "root",
            group  => "root",
            mode   => 0644,
            require => Package['php55-opcache'],
            notify  => Service['php-fpm'];
    }

    file { "$rootdir/php-fpm-5.5.conf" :
        owner   => "$user",
        group   => "$group",
        mode    => '0644',
        source  => 'puppet:///modules/lebbay/php/etc/php-fpm-5.5.conf',
        notify  => Service['php-fpm'],
        require => Package['php55-fpm'],
    }

    file { "$rootdir/php-fpm-5.5.d/www.conf" :
        mode    => '0644',
        source  => 'puppet:///modules/lebbay/php/etc/www-5.5.conf',
        notify  => Service['php-fpm'],
        require => [Package['php55-fpm'], File["$rootdir/php-fpm-5.5.conf"]];
    }

    exec { "install-composer":
        command => "curl -sS $composer_url | sudo php -- --install-dir=/usr/local/bin/",
        path => ["/usr/bin", "/usr/local/bin", "/bin"],
        unless => "test -x /usr/local/bin/composer.phar",
        require => Package['php55-fpm'];
    }

    file { "composer_link":
	    path => "/usr/local/bin/composer",
	    ensure => link,
	    target => "/usr/local/bin/composer.phar";
    }

    file { 'stem' :
        path   => "/usr/lib64/php/5.5/modules/stem.so",
        ensure => present,
        owner  => "$user",
        group  => "$group",
		source   => "puppet:///modules/lebbay/php/binaries/stem-5.5.so",
        require => Package['php55-fpm'],
    }

    file { 'twig' :
        path   => "/usr/lib64/php/5.5/modules/twig.so",
        ensure => present,
        owner  => "$user",
        group  => "$group",
		source   => "puppet:///modules/lebbay/php/binaries/twig-5.5.so",
        require => Package['php55-fpm'],
    }

    file { 'xhprof' :
        path   => "/usr/lib64/php/5.5/modules/xhprof.so",
        ensure => present,
        owner  => "$user",
        group  => "$group",
		source   => "puppet:///modules/lebbay/php/binaries/xhprof-5.5.so",
        require => Package['php55-fpm'],
    }

    file { 'xhprof_dir' :
        path   => "$datadir/xhprof",
        ensure => directory,
        owner  => "$user",
        group  => "$group",
    }
}

