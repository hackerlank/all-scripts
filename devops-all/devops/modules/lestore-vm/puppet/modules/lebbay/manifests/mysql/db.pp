define lebbay::mysql::db(
  $rootpass = $lebbay::params::mysql_password,
  $user, 
  $password 
) {
  exec { "create-${name}-db":
    unless => "/usr/bin/mysql -uroot -p\"$rootpass\" ${name}",
    command => "/usr/bin/mysql -uroot -p\"$rootpass\" -e \"create database ${name};\"",
    require => Service["mysqld"],
  }

  exec { "grant-${name}-db":
    unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
    command => "/usr/bin/mysql -uroot -p\"$rootpass\" -e \"grant all privileges on ${name}.* to '${user}'@'%' identified by '$password'; grant all privileges on ${name}.* to '${user}'@'localhost' identified by '$password';\"",
    require => [Service["mysqld"], Exec["create-${name}-db"]]
  }
}

