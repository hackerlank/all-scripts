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


$user = $lebbay::params::user
$group = $lebbay::params::group
$httpdir = $lebbay::params::httpdir
$stagename = 'vb-prod'
$sitename = 'sr'
$test = true
$php = "/usr/local/bin/php"
$s3cmd = 's3cmd-1.5.0-beta1'

group { "$group" :
    ensure => present,
}
user { "$user" :
    ensure  => present,
    gid     => "$group",
    require => Group["$group"],
}


file {
    '/var/job/ssh-agent.sh' :
        ensure => present,
        owner  => 'root',
        mode   => 0700;
}

file { 
    "/var/job/$s3cmd" :
        ensure  => directory,
        source  => "puppet:///modules/sr/$s3cmd",
        owner  => 'root',
        group  => 'root',
        recurse => true;
    "/var/job/$s3cmd/s3cmd" :
    	ensure => present,
        owner  => 'root',
        group  => 'root',
    	mode => 755,
		require => File["/var/job/$s3cmd"];
    '/usr/bin/s3cmd' :
    	ensure => link,
		target => "/var/job/$s3cmd/s3cmd",
		require => File["/var/job/$s3cmd/s3cmd"];
}


package {
    "ImageMagick":
    ensure  => installed;
}
package {
    "inotify-tools":
    ensure  => installed,
    require => Yumrepo['p.epel'];
}
# yum version too old
#package {
#    "s3cmd":
#    ensure  => installed,
#    require => Yumrepo['p.epel'];
#}
package {
    "mysql":
    ensure  => installed,
    require => Yumrepo['p.epel'];
}

lebbay::os::cronjob{ "$stagename.clean_log" :
        script  => false,
        command => 'find /opt/data1/log/{s3sync*.log,goods_thumb*.log,goods_thumb_multi_*.log} -mtime +5 2>/dev/null | xargs -I {} rm -f {}',
        user    => 'root',
        minute  => 1,
        hour    => 0;
}

#lebbay::os::cronjob{ "$stagename.check_disk" :
#        script  => false,
#        command => '/var/job/check_disk.sh',
#        user    => 'root',
#        minute  => [ 0, 30 ];
#}

#lebbay::os::cronjob{ "$stagename.rsync_task" :
#        script  => false,
#        command => '/var/job/rsynctask >> /var/log/publish.log 2>>/var/log/publish.log',
#        user    => 'root',
#        minute  => *,
#        hour    => *;
#}

lebbay::os::cronjob{ "$stagename.rsyncupload" :
        script  => false,
        command => '/var/job/rsyncupload.sh e9573fbb5840585c1e3b2fe4b354d61b',
        user    => 'root',
        minute  => '*/10';
}

lebbay::os::cronjob{ "$stagename.goods_thumb" :
        script  => false,
        command => '/var/job/goods_thumb_m_vb.sh',
        user    => 'root';
}

lebbay::os::cronjob{ "$stagename.check_sync2s3" :
        script  => false,
        command => '/var/job/sync2s3_checklog.sh put 93b99269b0cf7a670b62e87ae200cb39 >> /opt/data1/log/s3sync.checklog_$(date +\%Y\%m\%d).log 2>&1',
        user    => 'root';
}
