define lebbay::app::frontend(
    $appname = undef,
    $stagename = undef,
    $sitename = $appname,
    $appdir = $stagename,
    $cmshost = undef,
    $cmsport = 32200,
    $newsletterdir = undef,
    $countsearch = false,
    $report_task = false,
    $clean_applogs = false,
    $search_appdir = undef,
    $check_domain = undef,
    $checksku = undef,
    $test = false,
    $sitemap_cronhour = 1,
    $sitemap_cronminute = 30,
    $clean_cache_min=20,
    $clean_cache_weekday=0,
    $cache_domain = undef,
    $remote_cache_dir = $appdir,
    $user = $lebbay::params::user,
    $group = $lebbay::params::group,
    $rootdir = $lebbay::params::rootdir,
    $httpdir = $lebbay::params::httpdir,
    $datadir = $lebbay::params::datadir,
    $nodename_file = $lebbay::params::nodename_file,
    $enable_zabbix_agent = true,
    $default_site = true,
){
    $cachedir = "${appdir}_cache"
    $logdir = $appdir

    $phproot = $appdir

    if $appdir == 'lestore' {
        $phproot = "$appdir/application"
    }

    if $cachedir != undef {
        file { 'appcache' :
            ensure  => directory,
            path    => "$datadir/$cachedir",
            owner   => "$user",
            group   => "$group",
            require => File['datadir'];
        'appcache_caches' :
            ensure  => directory,
            path    => "$datadir/$cachedir/caches",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_compiled' :
            ensure  => directory,
            path    => "$datadir/$cachedir/compiled",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_applogs' :
            ensure  => directory,
            path    => "$datadir/$cachedir/applogs",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_repo' :
            ensure  => directory,
            path    => "$datadir/$cachedir/repo",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        'appcache_xhprof' :
            ensure  => link,
            path    => "$datadir/$cachedir/xhprof",
            target  => "$datadir/xhprof",
            owner   => "$user",
            group   => "$group",
            require => File['appcache'];
        }
    }

    if $appdir != undef {
        file {
        'appdir' :
            path    => "$httpdir/$appdir",
            ensure  => link,
            #target  => "$httpdir/$appdir.current",
            owner   => "$user",
            group   => "$group",
            require => File['httpdir'];
        'template_link' :
            path    => "$httpdir/$appdir/templates",
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

    if $logdir != undef {
        file { "/var/log/$logdir" :
            ensure => directory,
            owner  => "$user",
            group  => "$group",
        }
    }

    file { "/var/log/$sitename" :
        ensure => directory,
        owner  => "$user",
        group  => "$group",
    }

    ##### for jobs #####
    file { '/var/job/startjjsserver' :
        ensure => present,
        source => 'puppet:///modules/lebbay/os/var/job/startfrontend',
        mode   => '0744',
        owner  => 'root',
        group  => 'root',
    }
    if $cache_domain != undef {
		lebbay::os::cronjob{ "$stagename.flush_cache.sh" :
		  ensure => present,
		  script  => false,
		  command => "/var/job/$stagename.flush_cache.sh",
		  minute  => '05',
		  user    => $user,
		  content => template('lebbay/os/var/job/flush_cache.sh.erb'),
		}

		file { 'cache_repo':
			path => "$datadir/$stagename_cache/repo",
			ensure => "directory",
			owner => $user,
		}

		lebbay::os::cronjob{ "$stagename.update_cache.sh" :
		  ensure => present,
		  script  => false,
		  command => "/var/job/$stagename.update_cache.sh",
		  minute  => '1',
		  hour	  => '*',
		  user    => 'root',
          content => template('lebbay/os/var/job/sync_cache.sh.erb'),
          #content => template('lebbay/os/var/job/dump_cache.sh.erb'),
		}
	}

    # language pack generation has been moved to install scripts
    lebbay::os::cronjob{ "$stagename.gen_langpack" :
        command => "make -C $httpdir/$appdir/stages _lang_pack >> /var/log/$stagename.langpack.log 2>&1",
        minute  => '33',
        hour    => '*/3',
        ensure  => absent,
        script  => false,
    }

    lebbay::os::cronjob{ "$stagename.nginx_cronlog.sh" :
        command => "/var/job/$stagename.nginx_cronlog.sh >> /var/log/$stagename.nginx_cronlog.$(date +\\%Y\\%m\\%d).log 2>&1",
        minute  => '0',
        hour    => '0',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/nginx_cronlog.sh.erb'),
    }

    if $test == true {
        lebbay::os::cronjob{ "$stagename.checkdbhealth.sh" :
            minute  => '*/30',
            hour    => '*',
            ensure  => present,
            script  => false,
            content => template('lebbay/os/var/job/checkdbhealth.sh.erb'),
        }
    } else{
        lebbay::os::cronjob{ "$stagename.checkdbhealth.sh" :
            minute  => '*',
            hour    => '*',
            ensure  => present,
            script  => false,
            content => template('lebbay/os/var/job/checkdbhealth.sh.erb'),
        }
    }
    if $search_appdir != undef and $check_domain != undef and $checksku != undef {
        lebbay::os::cronjob{ "$stagename.checksearch.sh" :
            minute => '*/6',
            hour => '*',
            ensure => present,
            script => false,
            content => template('lebbay/os/var/job/checksearch.sh.erb'),
        }
    }


    lebbay::os::cronjob{ "$stagename.checkdbaddr.sh" :
        minute  => '*/3',
        hour    => '*',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/checkdbaddr.sh.erb'),
    }

    lebbay::os::cronjob{ "$stagename.mail_filter.sh" :
        minute  => '*/2',
        hour    => '*',
        ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/mail_filter.sh.erb'),
    }

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

    lebbay::os::cronjob{ "$stagename.clean_compiled" :
        script  => false,
        command => "find $httpdir/$phproot/templates/compiled/ -type f -mtime +14 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '20',
        hour    => '4',
    }


    if $clean_applogs == true {
        lebbay::os::cronjob{ "$stagename.clean_applogs" :
        script  => false,
        command => "find $httpdir/$phproot/templates/applogs/ -type f -mtime +14 2>/dev/null | xargs -I {} rm -f {}",
        minute  => '25',
        hour    => '3',
        }
    }

    lebbay::os::cronjob{ "$stagename.clean_cache.sh" :
        command => "/var/job/$stagename.clean_cache.sh",
        minute  => '*',
        hour    => '*',
#       minute  => $clean_cache_min,
#	week    => $clean_cache_weekday,
	ensure  => present,
        script  => false,
        content => template('lebbay/os/var/job/clean_cache.sh.erb'),
    }

    lebbay::os::cronjob{ "$stagename.clean_nginx_cache" :
       script  => false,
       ensure => absent,
       command => "echo '/opt/data1/nginxproxycache/proxy_cache_dir/*' > /tmp/delete_cache_list",
       minute  => '30',
       hour    => '0',
    }

    lebbay::os::cronjob{ "$stagename.clean_sql_cache" :
        script  => false,
        ensure => absent,
        command => "echo '/var/www/http/$phproot/templates/caches/*' > /tmp/delete_cache_list",
        minute  => '30',
        hour    => '2',
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
        }
        file { "newsletter" :
            path    => "$httpdir/$appdir/newsletter",
            ensure  => 'link',
            target  => "$datadir/newsletter", 
            owner   => "$user",
            group   => "$group",
            require => [File["appdir"], File["$datadir/newsletter"]],
        }
    } 

#    lebbay::os::cronjob{ "$stagename.php_create" :
#        script  => false,
#        minute  => "$sitemap_cronminute",
#        hour    => "$sitemap_cronhour",
#        command => "$httpdir/$appdir/stages/common/gen_sitemap.sh $sitename $appdir",
#        ensure  => absent,
#    }

#    lebbay::os::cronjob{ "$stagename.php_create_robots" :
#        script  => false,
#        minute  => '0',
#        hour    => '22',
#        command => "php $httpdir/$phproot/sitemap/create_robots.php $sitename",
#        ensure  => absent,
#    }

    lebbay::os::cronjob{ "$stagename.php_create.www-data" :
        script  => false,
        minute  => "$sitemap_cronminute",
        hour    => "$sitemap_cronhour",
        command => "$httpdir/$appdir/stages/common/gen_sitemap.sh $sitename $appdir",
        ensure  => present,
        user    => $user,
    }

    lebbay::os::cronjob{ "$stagename.php_create_robots.www-data" :
        script  => false,
        minute  => '0',
        hour    => '22',
        command => "php $httpdir/$phproot/sitemap/create_robots.php $sitename",
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

    lebbay::os::cronjob{ "clean_php_log" :
           minute => '30',
           hour   => '1',
	   week	  => '1',
           ensure => present,
           script => false,
           command => "find /var/log/php-fpm/ -type f -mtime +15 | xargs -I {} rm -fr {}",
    }

    if $enable_zabbix_agent == true {
        lebbay::zabbix::agent::nginx{"nginx":}
        lebbay::zabbix::agent::php_fpm{"php_fpm":}
    }
}

