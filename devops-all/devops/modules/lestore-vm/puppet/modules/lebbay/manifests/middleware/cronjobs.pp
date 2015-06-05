class lebbay::middleware::cronjobs(
    $datadir = $lebbay::params::datadir,
    $test = false
){

    lebbay::os::cronjob{ 'check_nginx_pid.sh' :
        require => [File["$datadir/nginxlogs"], Class["lebbay::middleware::nginx"]],
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/check_nginx_pid.sh.erb'),
    }

    #    lebbay::os::cronjob{ 'nginx_cronlog.sh' :
    #        command => '/var/job/nginx_cronlog.sh >> /var/log/nginx_cronlog.$(date +\%Y\%m\%d).log 2>&1',
    #        minute  => '0',
    #        hour    => '0',
    #        ensure  => present,
    #    }

    lebbay::os::cronjob{ 'clean_cronlog' :
        script  => false,
        command => 'find /var/log/{*.nginx_cronlog.*,top.*.log,delete_cache_client.*.log,monitor/*} -mtime +10 2>/dev/null | xargs -I {} rm -f {}',
        minute  => '0',
        hour    => '4',
    }

    lebbay::os::cronjob{ 'clean_nginxlogs' :
        script  => false,
        command => "find $datadir/nginxlogs/*.log -mtime +1 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '0',
        hour    => '4',
    }


    lebbay::os::cronjob{ 'clean_nginxlogs_tar' :
        script  => false,
        command => "find $datadir/nginxlogs/*.tar.gz -mtime +30 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '0',
        hour    => '4',
    }

    lebbay::os::cronjob{ 'delete_cache_client.sh' :
        minute  => '*/1',
        command => '/var/job/delete_cache_client.sh  fa8b1f67815b8960c2ecf2b77f4e7d2a >> /var/log/delete_cache_client.$(date +\%Y\%m\%d).log 2>&1',
    }
}
