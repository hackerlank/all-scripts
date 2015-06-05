class { 'lebbay::params' : }
class { 'lebbay::os' :
  require  => Class['lebbay::params'],
  test    => true,
}
#class { 'lebbay::middleware' :
#  require => Class['lebbay::os'],
#}
#class { 'lebbay::middleware::cronjobs' :
#  require => Class['lebbay::middleware'],
#  test    => true,
#}

lebbay::zabbix::agent::mysql{"mysql":
   require => Class['lebbay::os'];
}
lebbay::zabbix::agent::mysql_status{"mysql_status":
   require => Class['lebbay::os'];
}

package {
    "mysql55":
        ensure  => installed;
    "s3cmd":
        ensure  => installed;
}

file {
    '/var/opt/basedbdata' :
        ensure => link,
        target => '/opt/data1/basedbdata';
    '/var/opt/dbdata' :
        ensure => link,
        target => '/opt/data1/dbdata';
}

$user = $lebbay::params::user
$group = $lebbay::params::group
$httpdir = $lebbay::params::httpdir
$stagename = 'zz-prod'
$sitename = 'ssd'
$test = true
$php = "/usr/local/bin/php"

#lebbay::os::cronjob{ "$stagename.check_memfree" :
#        script  => false,
#        command => "/var/job/check_memfree.sh",
#        user    => 'root';
#}
#
#lebbay::os::cronjob{ "$stagename.check_uptime" :
#        script  => false,
#        command => "/var/job/check_uptime.sh",
#        user    => 'root';
#}
#
#lebbay::os::cronjob{ "$stagename.top" :
#        script  => false,
#        command => "/var/job/top.sh",
#        user    => 'root';
#}
#
#lebbay::os::cronjob{ "$stagename.check_disk" :
#        script  => false,
#        command => "/var/job/check_disk.sh",
#        user    => 'root',
#        minute  => [ 0, 30 ];
#}

lebbay::os::cronjob{ "$stagename.clean_log" :
        script  => false,
        command => 'find /var/log/{top.*.log,monitor/*,basedbdatatest.*.log,*slow_log*.sql,*slow_log*.log,*mysqlbak*.log,*processlist*.log,table_sync_js2je*.log,auth_mysqldump*.log,export_prices*.log,batch_backup*.log} -mtime +10 2>/dev/null | xargs -I {} rm -f {}',
        user    => 'root',
        minute  => 0,
        hour    => 4;
}

lebbay::os::cronjob{ "$stagename.table_sync" :
        script  => false,
        command => 'find /opt/data1/table_sync -name "*.gz" -mtime +3 2>/dev/null | xargs -I {} rm -f {}',
        user    => 'root',
        minute  => 0,
        hour    => 4;
}

lebbay::os::cronjob{ "$stagename.monitor_slave_dpm" :
        script  => false,
        command => '/var/job/moni_mysql_slave.dpm.sh 8d26e035cc3e0204d5548ed43c4e99d3 >> /var/log/monitor/moni_mysql_slave.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root';
}

lebbay::os::cronjob{ "$stagename.monitor_slave" :
        script  => false,
        command => '/var/job/moni_mysql_slave.sh 2889a925cc30fae006c8da748e66ebd4 >> /var/log/monitor/moni_mysql_slave.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => '*/5';
}

lebbay::os::cronjob{ "$stagename.mysql_process_list" :
        script  => false,
        command => '/var/job/mysqlprocesslist.sh >> /var/log/processlist.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => '*/5';
}

lebbay::os::cronjob{ "$stagename.mysql_slow_log" :
        script  => false,
        command => '/var/job/sql_slow_log.sh >> /var/log/sql_slow_log.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 5,
        hour    => 18,
        day => '*/5';
}

lebbay::os::cronjob{ "$stagename.mysql_bak_lite" :
        script  => false,
        command => '/bin/bash /var/job/mysqlbak_lite.sh >> /var/log/mysqlbak_lite.$(date +\%Y\%m\%d).log 2>&1 #dump hourly order info',
        user    => 'root',
        minute  => 25;
}

lebbay::os::cronjob{ "$stagename.mysql_bak_s3" :
        script  => false,
        command => '/var/job/mysqlbak.sh s3 >> /var/log/mysqlbak.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 10,
        hour    => [ 1, 4, 8, 9, 12, 20, 23 ];
}

lebbay::os::cronjob{ "$stagename.mysql_bak_full" :
        script  => false,
        command => '/var/job/mysqlbak_full.sh s3 >> /var/log/mysqlbak_full.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 35,
        hour    => 1,
        day => [ 1, 7, 13, 19, 25 ];
}

lebbay::os::cronjob{ "$stagename.basedb_data_test" :
        script  => false,
        command => '/var/job/basedbdatatest.sh >> /var/log/basedbdatatest.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 35,
        hour    => 10;
}

lebbay::os::cronjob{ "$stagename.check_mail_space" :
        script  => false,
        command => '/var/job/check_mail_space.sh >> /var/log/monitor/check_mail_space.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 20,
        hour    => [ 1, 12 ];
}

lebbay::os::cronjob{ "$stagename.export_prices" :
        script  => false,
        command => '/var/job/export_prices.sh >>  /var/log/export_prices.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 0,
        hour    => 0;
}

lebbay::os::cronjob{ "$stagename.clean_table" :
        script  => false,
        command => '/var/job/batch_backup.sh >> /var/log/batch_backup.$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root',
        minute  => 0,
        hour    => 20;
}

lebbay::os::cronjob{ "$stagename.auth_mysqldump" :
        script  => false,
        command => "/var/job/auth_mysqldump.sh $stagename >> /var/log/auth_mysqldump.$(date +\\%Y\\%m\\%d).log 2>&1",
        user    => 'root',
        minute  => 55,
        hour    => 13;
}

lebbay::os::cronjob{ "$stagename.check_mysql_processlist" :
        script  => false,
        command => "/var/job/check_mysql_processlist.sh",
        user    => 'root',
        minute  => '*/5';
}
