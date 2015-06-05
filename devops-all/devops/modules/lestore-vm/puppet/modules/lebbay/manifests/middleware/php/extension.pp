define lebbay::middleware::php::extension(
  $package = $name,
  $version = undef,
  $config  = "puppet:///modules/lebbay/php/etc/php.d/$name.ini"
){
  package { "$package" :
    ensure => "$version",
  }

  #file { "/usr/local/webserver/php/etc/php.d/$package.ini" :
  #  ensure => present,
  #  source => "$config",
  #  owner  => "$lebbay::params::user",
  #  group  => "$lebbay::params::group",
  #  mode   => 0644,
  #  notify  => Service['php-fpm'],
  #}
}
