class { 'lebbay::params' : }

file {
    '/var/job' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root';
}

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

class{ "lebbay::zabbix":            
    nodename => file("/home/ec2-user/nodename"),
    type => 'server',
    require => [Class['lebbay::params'],Yumrepo['p.epel']];
}
