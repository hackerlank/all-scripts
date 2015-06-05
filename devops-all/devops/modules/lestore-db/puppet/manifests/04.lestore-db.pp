yumrepo { 'p.epel':
    descr          => 'Extra Packages for Enterprise Linux 6 - $basearch',
    #baseurl       => "$repo",
    mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    enabled        => 1,
    priority       => 1,
    #timeout       => 10,
    failovermethod => 'priority',
}

class { 'lebbay::params' : }
class { 'lebbay::mysql' : }
lebbay::mysql::db { 'jjshouse' : 
  user     => 'jjshouse',
  password => 'jjshouse',
  require  => Class["lebbay::mysql"],
}

package { 
'php' :
    ensure  => present;
'php-mysql' :
    ensure  => present;
'php-pdo' :
    ensure  => present;
'php-fpm' :
    ensure  => present;
'phpMyAdmin' :
    ensure  => present,
    require => Yumrepo['p.epel'];
'nginx' :
    ensure => present;
}

service { 'nginx' :
    enable    => true,
    ensure    => 'running',
    hasstatus => true,
    require   => Package['nginx'],
}

service { 'php-fpm':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    require    => Package['php-fpm'], 
}

file { 
    "phpmyadmin.config" :
        path   => "/etc/phpMyAdmin/config.inc.php",
        ensure  => present,
        source  => 'puppet:///modules/testdb/config.inc.php',
        require => Package['phpMyAdmin'];
    'nginx_phpmyadmin' :
        path    => "/etc/nginx/conf.d/phpmyadmin.conf",
        ensure  => present,
        source  => 'puppet:///modules/testdb/phpmyadmin.conf',
        notify  => Service['nginx'],
        require => Package['nginx'];
}
