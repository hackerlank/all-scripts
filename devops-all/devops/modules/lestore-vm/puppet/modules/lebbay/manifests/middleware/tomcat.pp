class lebbay::middleware::tomcat{
    $user = 'tomcat'
    $group = 'tomcat'

    package { 'tomcat6' :
        ensure => latest,
    }

    file { '/usr/sbin/tomcat6' :
        ensure  => present,
        source  => 'puppet:///modules/lebbay/tomcat/tomcat6',
        owner   => "root",
        group   => "root",
        mode    => '0755',
        require => Package['tomcat6'],
        notify  => Service['tomcat6'],
    }

    file { '/etc/tomcat6/server.xml' :
        ensure  => present,
        source  => 'puppet:///modules/lebbay/tomcat/server.xml',
        owner   => "root",
        group   => "$group",
        mode    => '0664',
        require => Package['tomcat6'],
        notify  => Service['tomcat6'],
    }

    service { 'tomcat6' :
        enable    => true,
        ensure    => 'running',
        restart   => '/sbin/service tomcat6 restart',
        hasstatus => true,
        require   => [Package['tomcat6'], File['/etc/tomcat6/server.xml'], File['/usr/sbin/tomcat6']],
    }
}
