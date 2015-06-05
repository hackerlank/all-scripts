#default middleware configuration

class lebbay::middleware(
    $user = $lebbay::params::user,
    $group = $lebbay::params::group,
    $datadir = $lebbay::params::datadir,
    $httpdir = $lebbay::params::httpdir,
    $rootdir = $lebbay::params::rootdir,
    $php_ver = 5.3,
    $appname = undef,
){
    file { 'rootdir' :
      path    => "$rootdir",
      ensure  => directory,
      owner   => "$user",
      group   => "$group",
    }

    file { 'httpdir' :
      path    => "$httpdir",
      ensure  => directory,
      owner   => "$user",
      group   => "$group",
    }

    file { 'datadir' :
      path    => "$datadir",
      ensure  => directory,
      owner   => "$user",
      group   => "$group",
    }

    file { 
    'data_code' :
      path    => "$datadir/code",
      ensure  => directory,
      owner   => "$user",
      group   => "$group",
      require => File['datadir'];
    'data_code_backup' :
      path    => "$datadir/code/backup",
      ensure  => directory,
      owner   => "$user",
      group   => "$group",
      require => File['data_code'];
    }

    group { "$group" :
      ensure => present,
    }
    user { "$user" :
      ensure  => present,
      gid     => "$group",
      require => Group["$group"],
    }

    class { 'lebbay::middleware::nginx' :
      appname => $appname,
      require => [User["$user"], File['datadir'], File['rootdir']];
    }


    if $php_ver == 5.5 {
        class { 'lebbay::middleware::php55' :
            require => [User["$user"], File['datadir'], File['rootdir'], Class["lebbay::middleware::nginx"]];
        }
    } else {
        class { 'lebbay::middleware::php' :
            require => [User["$user"], File['datadir'], File['rootdir'], Class["lebbay::middleware::nginx"]];
        }
    }

}

