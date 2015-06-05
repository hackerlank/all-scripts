define lebbay::middleware::tomcat::appconf(
  $appname = undef
){
  file { "/etc/tomcat6/Catalina/localhost/$name" :
    ensure  => present,
    source => "puppet:///modules/lebbay/app/$appname/$name",
    owner   => "root",
    mode    => '0664',
    group   => "$lebbay::middleware::tomcat::group",
  }
}
