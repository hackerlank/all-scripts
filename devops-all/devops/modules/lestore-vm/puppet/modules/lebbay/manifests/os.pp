class lebbay::os(
    $repo = $lebbay::params::binary_repo,
    $nodename_file = $lebbay::params::nodename_file,
    $hostname = undef,
    $test = false
){

    #    $node_name=file("$nodename_file")
    #    notify { "Puppet node name is $node_name." : }

#    yumrepo { 'lebbay':
#        descr          => "Lebbay's binary rpm packages",
#        baseurl        => "$repo",
#        gpgcheck       => 0,
#        enabled        => 1,
#        priority       => 1,
#        #timeout        => 10,
#        failovermethod => 'priority',
#    }

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

    package{
        "pdsh" :
            ensure  => latest,
            require => Yumrepo['p.epel'];
        "pdsh-mod-genders" :
            ensure  => latest,
            require => Yumrepo['p.epel'];
        "pdsh-rcmd-ssh" :
            ensure  => latest,
            require => Yumrepo['p.epel'];
        "pdsh-rcmd-rsh" :
            ensure  => latest,
            require => Yumrepo['p.epel'];
	'nodejs':
	    ensure => present,
            require => Yumrepo['p.epel'];
	'npm':
	    ensure => present,
            require => [Yumrepo['p.epel'], Package['nodejs']];
    }

    file {
    '/var/job' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root';
	'/var/log/cronjob' :
        ensure  => directory,
        owner   => 'root',
        mode	=> '777',
        group   => 'root';
    '/var/ssl' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root';
    '/var/www' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root';
    }

    file {
    'oslog_monitor' :
        path    => "/var/log/monitor",
        ensure  => directory,
        owner   => 'root',
        group   => 'root';
    'oslog_config' :
        path    => "/var/log/config",
        ensure  => directory,
        owner   => 'root',
        group   => 'root';
    }

    if $hostname != undef {
        notify { "Using $hostname in host_name.conf" :}

        file { 'host_name_conf' :
            path    => "/var/job/host_name.conf",
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            content => "host_name=\"$hostname\"",
        }
    }

    file { 'alert_sh' :
        path    => "/var/job/alert.sh",
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => 0744,
        source  => 'puppet:///modules/lebbay/os/var/job/alert.sh',
    }

    lebbay::os::cronjob{ 'check_disk.sh' :
        minute => [0,30],
        ensure => present,
        script  => false,
        content => template('lebbay/os/var/job/check_disk.sh.erb'),
    }

    lebbay::os::cronjob{ 'check_memfree.sh' :
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/check_memfree.sh.erb'),
    }

    lebbay::os::cronjob{ 'check_uptime.sh' :
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/check_uptime.sh.erb'),
    }

#    lebbay::os::cronjob{ 'passwd' :
#        minute => '*/5',
#        ensure => absent,
#    }

    lebbay::os::cronjob{ "clean_puppet_log" :
        script  => false,
        command => "find /var/lib/puppet/reports/ -type f -mtime +7 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '20',
        hour    => '3',
    }

    lebbay::os::cronjob{ "clean.puppet.clientbucket" :
  	   minute => '50',
  	   hour   => '1',
  	   ensure => present,
  	   script => false,
  	   command => "find /var/lib/puppet/clientbucket/ -type f -ctime +30 2>/dev/null | xargs -I {} rm -fr {}",
    }

    lebbay::os::cronjob{ "clean.mail" :
  	   minute => '50',
  	   hour   => '0',
  	   ensure => present,
  	   script => false,
  	   command => "echo > /var/spool/mail/root",
    }

    lebbay::os::cronjob{ "clean.monitor" :
  	   minute => '0',
  	   hour   => '2',
  	   ensure => present,
  	   script => false,
  	   command => "find /var/log/monitor -type f -ctime +10 2>/dev/null | xargs -I {} rm -fr {}",
    }

    lebbay::os::cronjob{ "clean.tmp" :
  	   minute => '0',
  	   hour   => '2',
  	   ensure => present,
  	   script => false,
  	   command => "find /home/ec2-user -type f -name tmp-*-unpack.tar.gz -ctime +7 2>/dev/null | xargs -I {} rm -fr {}",
    }

    lebbay::os::cronjob{ "clean.app_unpack" :
  	   minute => '0',
  	   hour   => '2',
  	   ensure => present,
  	   script => false,
  	   command => "find /home/ec2-user -type d -name app_unpack_* -ctime +7 2>/dev/null | xargs -I {} rm -fr {}",
    }

    lebbay::os::cronjob{ 'top.sh' :
    }

    package{ 'sendmail' :
        ensure => 'installed',
    }

    package{ 'mailx' :
        ensure => 'installed',
        require => Package['sendmail'],
    }

    augeas { "sudosetup":
        context => "/files/etc/sudoers",
        changes => [
            "set Defaults/requiretty/negate \"\"",
            #            "set Cmnd_Alias[alias/name = 'CONFMGMT']/alias/name CONFMGMT",
            #            "set Cmnd_Alias[alias/name = 'CONFMGMT']/alias/command /usr/bin/puppet",
            ],
            #require => Package['sudo'],
    }

    class{ "lebbay::zabbix":
        server_hostname => $lebbay::params::zabbix_server,
        nodename => file($nodename_file),
        type => 'agent',
    }


    lebbay::os::ulimits{
        "root-soft": domain => root, type => soft, item => nofile, value => 51200;
        "root-hard": domain => root, type => hard, item => nofile, value => 51200;
        "www-data-soft": domain => www-data, type => soft, item => nofile, value => 51200;
        "www-data-hard": domain => www-data, type => hard, item => nofile, value => 51200;
    }

    lebbay::os::user{ 'syncer' :
    }

    lebbay::os::user{ 'lchen' :
        sudoer => true,
    }

    lebbay::os::user{ 'ychen' :
        sudoer => true,
    }
    lebbay::os::user{ 'yzhang' :
        sudoer => true,
    }
    lebbay::os::user{ 'hwang' :
        sudoer => true,
    }
    lebbay::os::user{ 'cmwu' :
        sudoer => true,
    }
}

