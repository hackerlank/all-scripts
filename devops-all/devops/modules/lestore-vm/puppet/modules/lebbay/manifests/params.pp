#default parameter for lebbay module

class lebbay::params {
# $binary_repo = 'http://deployer-test.opvalue.com/repo'
# $nginx_version= "1.4.7-1.17.amzn1"
# $php_version = "5.3.28-1.5.amzn1"
  $nginx_version= "1.6.1-2.21.amzn1"
  $php_version = "5.3.29-1.7.amzn1"
  $php55_version = "5.5.18-1.92.amzn1"
  $user = 'www-data'
  $group = 'www-data'
  $rootdir = '/etc'
  $httpdir = "/var/www/http"
  $datadir = "/opt/data1"
  $icinga_server = "10.212.239.195,127.0.0.1"
  $mysql_password = "1e6baypa5svvOrd"
  $composer_url = "https://getcomposer.org/installer"
  $zabbix_server = "monitor.opvalue.com"
  $nodename_file = "/home/ec2-user/nodename"
}
