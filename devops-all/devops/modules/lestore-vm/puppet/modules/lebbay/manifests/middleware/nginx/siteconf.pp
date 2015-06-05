define lebbay::middleware::nginx::siteconf(
  $srcdir = undef,
  $rootdir = $lebbay::params::rootdir,
  $user = $lebbay::params::user,
  $group = $lebbay::params::group
){

  file { "$name" :
    path   => "$rootdir/nginx/conf/sites-enabled/$name",
    mode   => '0644',
    owner  => "$user",
    group  => "$group",
    source => "$srcdir/$name", 
  }
}
