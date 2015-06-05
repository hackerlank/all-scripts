define lebbay::middleware::nginx::ssl(
  $srcdir = undef,
  $rootdir = $lebbay::params::rootdir,
  $user = $lebbay::params::user,
  $group = $lebbay::params::group
){

  file { "$name" :
    path   => "$rootdir/nginx/conf/ssl/$name",
    mode   => '0644',
    owner  => "$user",
    group  => "$group",
    source => "$srcdir/$name", 
  }
}
