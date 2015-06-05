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

package { 
    "java-1.6.0-openjdk" :
        ensure => latest;
    #"libxml2-devel" :
    #    ensure => latest;
    #"libxslt-devel" :
    #    ensure => latest;
    #"gcc" :
    #    ensure => latest; 
    "ant" :
    	ensure => latest;
    "aws-apitools-cfn" :
    	ensure => latest; 
    "aws-apitools-common" :
    	ensure => latest; 
    "aws-apitools-ec2" :
    	ensure => latest; 
    "aws-apitools-elb" :
    	ensure => latest; 
    "aws-apitools-as" :
    	ensure => latest; 
    "aws-apitools-mon" :
    	ensure => latest; 
    "aws-apitools-rds" :
    	ensure => latest; 
    "aws-apitools-iam" :
    	ensure => latest;
    #"nginx" :
    #    ensure => latest;
    "php":
        ensure => present;
    #"php-mcrypt" :
    #    ensure => present;
    "git" :
        ensure => present;
    #"nodejs" :
    #	ensure => present;
    #"npm" :
    #	ensure => present;
    #	reqiure => Package['nodejs'];
}

#exec { "install-bower":
#    command => "npm -g install bower",
#    path => ["/usr/bin", "/usr/local/bin", "/bin"],
#    reqiure => Package['npm'],
#    unless => "test -x /usr/bin/bower";
#}

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
    #"xmlstarlet" :
    #    ensure  => latest,
    #    require => Yumrepo['p.epel'];
    #"php-domxml-php4-php5.noarch":
    #	ensure => latest;
    "python26-pip" :
        ensure  => latest,
        require => Yumrepo['p.epel'];
}

#service { 'nginx' :
#    enable    => true,
#    ensure    => 'running',
#    restart   => '/sbin/service nginx reload',
#    hasstatus => true,
#    require   => Package['nginx'],
#}


file { 
    "keys" :
        path   => "/home/ec2-user/.awstools/keys",
        ensure => directory;
    "keys.README" :
        path   => "/home/ec2-user/.awstools/keys/README",
        ensure => present,
        source => 'puppet:///modules/deployer/keys.README';
#    'nginx_defalut' :
#        path   => '/etc/nginx/conf.d/default.conf',
#        ensure => absent;
#    'nginx_deployer' :
#        path    => "/etc/nginx/conf.d/deployer.conf",
#        ensure  => present,
#        source  => 'puppet:///modules/deployer/deployer.conf',
#        notify  => Service['nginx'],
#        require => Package['nginx'];
    "pd" :
        path    => "/home/ec2-user/.awstools/pd",
        content => template('deployer/pd.erb'),
        ensure  => present,
        owner   => 'ec2-user',
        group   => 'ec2-user',
        mode    => 0744;
    "composer" :
        path   => '/usr/local/bin/composer',
        ensure => present,
        source => 'puppet:///modules/deployer/composer',
        owner  => 'root',
        group  => 'root',
        mode   => 0755;
}

cron { 
    "clean_tmp" :
        ensure  => present,
        command => "find /home/ec2-user/tmp -type d -mtime +3 2>/dev/null | xargs -I {} rm -fr {}",
        user    => 'root',
        minute  => 50,
        hour    => 1;
}
