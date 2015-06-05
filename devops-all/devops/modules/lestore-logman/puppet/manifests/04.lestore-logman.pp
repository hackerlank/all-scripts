class { 'lebbay::params' : }
class { 'lebbay::os' :
  require  => Class['lebbay::params'],
  test    => true,
}

$user = $lebbay::params::user
$group = $lebbay::params::group
$httpdir = $lebbay::params::httpdir
$stagename = 'zz-prod'
$sitename = 'logman'
$test = true
$php = "/usr/local/bin/php"


package {
    "aws-apitools-common":
    ensure  => installed,
    require => Yumrepo['p.epel'];
}

file {
    "keys" :
        path   => "/home/ec2-user/.awstools/keys",
        ensure => directory;
    '/var/job/ssh-agent.sh' :
        ensure => present,
        owner  => 'root',
        mode   => 0700;
}

lebbay::os::cronjob{ "$stagename.clean_tmp" :
        script  => false,
        command => "find /home/ec2-user/tmp -type d -mtime +3 2>/dev/null | xargs -I {} rm -fr {}",
        user    => 'root',
        minute  => 50,
        hour    => 1;
}

lebbay::os::cronjob{ "$stagename.fetch_log_merge" :
        script  => false,
        command => 'flock -x -n /tmp/fetch_log.lock -c "/var/job/fetch_log.sh m" >> /var/log/cronjob/fetch_log.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 5,
        hour    => 1;
}

lebbay::os::cronjob{ "$stagename.fetch_log_monitor" :
        script  => false,
        command => 'flock -x -n /tmp/fetch_log.lock -c "/var/job/fetch_log.sh l" >> /var/log/cronjob/fetch_log.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 30,
        hour    => 0;
}

lebbay::os::cronjob{ "$stagename.fetch_log_access" :
        script  => false,
        command => 'flock -x -n /tmp/fetch_log.lock -c "/var/job/fetch_log.sh a" >> /var/log/cronjob/fetch_log.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 5,
        hour    => 13;
}

lebbay::os::cronjob{ "$stagename.count_ip" :
        script  => false,
        command => "/var/job/count_ip.sh",
        user    => 'root',
        minute  => 0,
        hour    => 3;
}

lebbay::os::cronjob{ "$stagename.clean_pack_a" :
        script  => false,
        command => "find /opt/data1/access_log/*/*.tar.gz -mtime +30 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 2;
}

lebbay::os::cronjob{ "$stagename.clean_log_a" :
        script  => false,
        command => "find /opt/data1/access_log/*/*.log -mtime +3 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 2;
}

lebbay::os::cronjob{ "$stagename.clean_pack_m" :
        script  => false,
        command => "find /opt/data1/merge_log/*/*.tar.gz -mtime +10 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 5;
}

lebbay::os::cronjob{ "$stagename.clean_log_m" :
        script  => false,
        command => "find /opt/data1/merge_log/*/*.rar -mtime +10 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 5;
}

lebbay::os::cronjob{ "$stagename.clean_log_error" :
        script  => false,
        command => "find /opt/data1/error_log/ -name '*.log*' -mtime +10 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 5;
}

lebbay::os::cronjob{ "$stagename.clean_log_monitor" :
        script  => false,
        command => "find /opt/data1/monitor_log/*/*.log -mtime +7 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 5;
}

lebbay::os::cronjob{ "$stagename.clean_stat_monitor" :
        script  => false,
        command => "find /opt/data1/monitor_log/*.log -mtime +3 2>/dev/null | xargs -I {} rm -f {}",
        user    => 'root',
        minute  => 0,
        hour    => 5;
}
