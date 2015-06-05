define lebbay::app::frontend2(
    $appname = undef,
    $stagename = undef,
    $domain = undef,
    $sitename = $appname,
    $appdir = $stagename,
    $cmshost = undef,
    $cmsport = 32200,
    $newsletterdir = undef,
    $countsearch = false,
    $report_task = false,
    $clean_applogs = false,
    $clean_alert = false,
    $search_appdir = undef,
    $check_domain = undef,
    $checksku = undef,
    $test = false,
    $sitemap_cronhour = 1,
    $sitemap_cronminute = 30,
    $user = $lebbay::params::user,
    $group = $lebbay::params::group,
    $rootdir = $lebbay::params::rootdir,
    $httpdir = $lebbay::params::httpdir,
    $datadir = $lebbay::params::datadir,
    $nodename_file = $lebbay::params::nodename_file,
    $enable_zabbix_agent = true,
    $default_site = true,
    $langs = "en de es fr se no da fi ru nl it pt",
){
    $cachedir = "${appdir}_cache"

    $phproot = $appdir

    if $cachedir != undef {
        file { 'appcache' :
            ensure  => directory,
            path    => "$datadir/$cachedir",
            owner   => "$user",
            group   => "$group",
            require => File['datadir'];
        'appcache_applogs' :
            ensure  => directory,
            path    => "$datadir/$cachedir/log",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_alert' :
            ensure  => directory,
            path    => "$datadir/$cachedir/alert",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_repo' :
            ensure  => directory,
            path    => "$datadir/$cachedir/repo",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_robots' :
            ensure  => directory,
            path    => "$datadir/$cachedir/robots",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_sitemap' :
            ensure  => directory,
            path    => "$datadir/$cachedir/sitemap",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_twig' :
            ensure  => directory,
            path    => "$datadir/$cachedir/twig",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        }
    }

    if $cmshost != undef and $newsletterdir != undef {
        lebbay::os::cronjob{ "cms_rsync_newsletter" :
            script  => false,
            command => "`rsync -zrtopg -e 'ssh -i /root/.ssh/aws.cms -p$cmsport -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' --exclude '/tmp_zip/' --progress syncer@$cmshost:/opt/data1/$newsletterdir/ $datadir/newsletter`",
            minute  => '*/5',
            hour    => '*',
        }

        file { "$datadir/newsletter" :
            ensure => "directory",
            owner => "$user",
            group => "$group",
            mode  => '0777',
        }

        file { 'appcache_nl' :
            ensure  => 'link',
            path    => "$datadir/$cachedir/newsletter",
            target  => "$datadir/newsletter",
            owner   => "$user",
            group   => "$group",
            require => [File['appcache'],File["$datadir/newsletter"]],
        }
    }

    if $appdir != undef {
        file {
        'appdir' :
            path    => "$httpdir/$appdir",
            ensure  => link,
            owner   => "$user",
            group   => "$group",
            require => File['httpdir'];
        'var_link' :
            path    => "$httpdir/$appdir/var",
            ensure  => link,
            target  => "$datadir/$cachedir",
            owner   => "$user",
            group   => "$group",
            require => [File['httpdir'], File['appcache']];
        'appdir_data' :
            path    => "$httpdir/$appdir/data",
            ensure  => directory,
            owner   => "$user",
            group   => "$group",
            require => File['httpdir'];
        }
    }

    ##### for jobs #####
    lebbay::os::cronjob{ "$stagename.nginx_cronlog.sh" :
        command => "/var/job/$stagename.nginx_cronlog.sh >> /var/log/$stagename.nginx_cronlog.$(date +\\%Y\\%m\\%d).log 2>&1",
        minute  => '0',
        hour    => '0',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/nginx_cronlog.sh.erb'),
    }

    lebbay::os::cronjob{ "$stagename.checkdbaddr.sh" :
        minute  => '*/3',
        hour    => '*',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/checkdbaddr.sh.erb'),
    }

#    lebbay::os::cronjob{ "$stagename.mail_filter.sh" :
#        minute  => '*/2',
#        hour    => '*',
#        ensure  => present,
#        script  => false,
#        content => template('lebbay/os/var/job/mail_filter.sh.erb'),
#    }

    if $countsearch == true {
        lebbay::os::cronjob{ "count_search.sh" :
            command => "/var/job/count_search.sh",
            minute  => '25',
            hour    => '0',
            ensure  => present,
            script  => true,
        }
    }
    else {
        lebbay::os::cronjob{ "count_search.sh" :
            command => "/var/job/count_search.sh",
            minute  => '25',
            hour    => '0',
            ensure  => absent,
            script  => true,
        }
    }

    if $report_task == true {
        lebbay::os::cronjob{ "log_check_report_task.php" :
            command => "php /var/www/jjshouse_monitor/log_check_report_task.php >> /var/log/log_check_report_task.log 2>&1",
            minute  => '58',
            hour    => [5,11,17,23],
            ensure  => present,
            script  => false,
        }
    }
    else {
        lebbay::os::cronjob{ "log_check_report_task.php" :
            command => "php /var/www/jjshouse_monitor/log_check_report_task.php >> /var/log/log_check_report_task.log 2>&1",
            minute  => '58',
            hour    => [5,11,17,23],
            ensure  => absent,
            script  => false,
        }
    }

    lebbay::os::cronjob{ "$stagename.error_log_check_task.sh" :
        command => "/var/job/$stagename.error_log_check_task.sh >> /var/log/$stagename.error_log_check_task.log 2>&1",
        minute  => '5',
        hour    => '*',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/error_log_check_task.sh.erb'),
    }

    lebbay::os::cronjob{ "clean_php_fpm_log" :
        script  => false,
        command => "find /var/log/php-fpm/ -mtime +14 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '20',
        hour    => '2',
    }

    if $clean_applogs == true {
        lebbay::os::cronjob{ "$stagename.clean_applogs" :
        script  => false,
        command => "find $httpdir/$appdir/var/log/ -type f -mtime +14 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '25',
        hour    => '3',
        }
    }

    if $clean_alert == true {
        lebbay::os::cronjob{ "$stagename.clean_alert" :
        script  => false,
        command => "find $httpdir/$appdir/var/alert/ -type f -mtime +14 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '25',
        hour    => '3',
        }
    }

    lebbay::os::cronjob{ "$stagename.clean_cache.sh" :
        command => "/var/job/$stagename.clean_cache.sh",
        minute  => '*',
        hour    => '*',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/clean_cache.sh.erb'),
    }


    lebbay::os::cronjob{ "$stagename.php_check.www-data" :
        script  => false,
        minute  => "*/10",
        hour    => "*",
        command => "php $httpdir/$appdir/bin/check.php -d=$domain -s=$checksku",
        ensure  => present,
        user    => $user,
    }

    lebbay::os::cronjob{ "$stagename.php_sitemap.www-data" :
        script  => false,
        minute  => "$sitemap_cronminute",
        hour    => "$sitemap_cronhour",
        command => "php $httpdir/$appdir/bin/sitemap.php -a -i=0.5 -d=$domain -l='$langs'",
        ensure  => present,
        user    => $user,
    }

    lebbay::os::cronjob{ "$stagename.php_robots.www-data" :
        script  => false,
        minute  => '0',
        hour    => '22',
        command => "php $httpdir/$appdir/bin/robots.php -d=$domain -l='$langs'",
        ensure  => present,
        user    => $user,
    }

    lebbay::os::cronjob{ "xhprof_logs_backup.sh" :
        minute  => '15',
        hour    => '0',
        ensure  => present,
        script  => true,
		command => "/var/job/xhprof_logs_backup.sh >> /var/log/monitor/xhprof_logs_backup.$(date +\\%Y\\%m\\%d).log 2>&1",
    }

    if $enable_zabbix_agent == true {
        lebbay::zabbix::agent::nginx{"nginx":}
        lebbay::zabbix::agent::php_fpm{"php_fpm":}
    }
}

