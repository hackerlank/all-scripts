file { 
    '/var/job' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root';
    'composer':
    path    => "/usr/local/bin/composer",
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    source  => "puppet:///modules/lebbay/os/bin/composer";
}

lebbay::os::cronjob{ 'run_puppet.sh' : 
    minute   => '9',
    hour    => '*/8',
    ensure  => absent,
    require => File['/var/job'],
}

