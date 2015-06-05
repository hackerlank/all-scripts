file { '/var/job' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
}

lebbay::os::cronjob{ 'run_puppet.sh' : 
    minute  => 15,
    ensure  => absent,
    require => File['/var/job'],
}
