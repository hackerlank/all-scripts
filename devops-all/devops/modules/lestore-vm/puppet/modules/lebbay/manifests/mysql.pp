class lebbay::mysql(
  $mysql_password = $lebbay::params::mysql_password
){
  package { 'mysql' : ensure => installed }
  package { 'mysql-libs' : ensure => installed }
  package { 'mysql-common' : ensure => installed }
  package { "mysql-server": ensure => installed }

  file { "/var/lib/mysql" :
    ensure => directory,
    owner  => "mysql",
    group => "mysql",
  }

  file { "/var/lib/mysql/my.cnf":
    owner => "mysql", 
    group => "mysql",
    source => 'puppet:///modules/lebbay/mysql/my.cnf',
    require => [Package["mysql-server"], File["/var/lib/mysql"]],
  }
 
  file { "/etc/my.cnf":
    owner => "mysql", 
    group => "mysql",
    require => File["/var/lib/mysql/my.cnf"],
    ensure => "/var/lib/mysql/my.cnf",
    notify => Service["mysqld"],
  }

  service { "mysqld":
    enable => true,
    ensure => running,
    require => File["/etc/my.cnf"],
  }

  exec { "set-mysql-password":
    unless => "mysqladmin -u root -p\"$mysql_password\" status",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -u root password \"$mysql_password\"",
    require => Service["mysqld"],
  }

  exec { "set-mysql-timezone":
    onlyif => "test 0 -eq $(echo 'select count(*) as count from mysql.time_zone_name' | mysql -u root -p'$mysql_password' | grep -v count)",
    path => ["/bin", "/usr/bin"],
    command => "mysql_tzinfo_to_sql /usr/share/zoneinfo/|mysql -u root mysql -p\"$mysql_password\"",
    require => Exec["set-mysql-password"],
  }
}

