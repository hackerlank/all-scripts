define lebbay::os::cronjob(
  $ensure = 'present',
  $command = "/var/job/$name",
  $script = true,
  $minute = '*',
  $hour = '*',
  $day = '*',
  $month = '*',
  $week = '*',
  $content = '',
  $user = 'root',
  $group = 'root',
){
  if $content != '' {
    file { "/var/job/$name" :
      ensure => present,
      owner  => $user,
      group  => $group,
      mode   => 0744,
      content => $content,
      before => Cron["cron_$name"],
    }
  } elsif $script {
    file { "/var/job/$name" :
      ensure => present,
      owner  => $user,
      group  => $group,
      mode   => 0744,
      source => "puppet:///modules/lebbay/os/var/job/$name",
      before => Cron["cron_$name"],
    }
  }
  cron { "cron_$name" :
    ensure  => "$ensure",
    command => "$command",
    user    => $user,
    minute  => $minute,
    hour    => $hour,
    monthday     => $day,
    month   => $month,
    weekday    => $week,
  }
}
