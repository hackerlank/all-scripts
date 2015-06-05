class lebbay::middleware::memcached(
){
    package { 'memcached':
        ensure => latest,
    }

    service{ 'memcached':
        enable    => true,
        ensure    => 'running',
        restart   => '/sbin/service memcached reload',
        hasstatus => true,
        require => Package['memcached'],
    }
}
