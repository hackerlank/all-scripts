#!/bin/bash 

# install GitLab on CentOS6.5

# Download the GPG key for EPEL repository from fedoraproject and install it on your system:
wget -O /etc/yum.repos.d/PUIAS_6_computational.repo https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/install/centos/PUIAS_6_computational.repo
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

# Verify that the key got installed successfully
rpm -qa gpg*

# Now install the epel-release-6-8.noarch package, which will enable EPEL repository on your system:
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Download PUIAS repo:
wget -O /etc/yum.repos.d/PUIAS_6_computational.repo https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/install/centos/PUIAS_6_computational.repo
# Next download and install the gpg key:
wget -O /etc/pki/rpm-gpg/RPM-GPG-KEY-puias http://springdale.math.ias.edu/data/puias/6/x86_64/os/RPM-GPG-KEY-puias
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puias

# Verify that the key got installed successfully:
rpm -qa gpg*
# Verify that the EPEL and PUIAS Computational repositories are enabled as shown below: 
yum repolist

# yum-config-manager --enable epel --enable PUIAS_6_computational

# Install the required tools for GitLab

#yum -y update
#yum -y groupinstall 'Development Tools'
#yum -y install readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui redis sudo wget crontabs logwatch logrotate perl-Time-HiRes git cmake libcom_err-devel.i686 libcom_err-devel.x86_64

yum groupinstall 'Development Tools'
yum install readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui redis sudo wget crontabs logwatch logrotate perl-Time-HiRes git cmake libcom_err-devel.i686 libcom_err-devel.x86_64

# Install mail server 
#yum -y install postfix
yum  install postfix

# Download Ruby and compile it:
mkdir /tmp/ruby && cd /tmp/ruby
curl --progress ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz | tar xz
cd ruby-2.1.2
./configure --disable-install-rdoc
make
make prefix=/usr/local install

# Install the Bundler Gem:
gem install bundler --no-doc

# Logout and login again for the $PATH to take effect. Check that ruby is properly installed with:
exit 0

# System Users
# Create a git user for Gitlab:
adduser --system --shell /bin/bash --comment 'GitLab' --create-home --home-dir /home/git/ git
# Important: In order to include /usr/local/bin to git user's PATH, one way is to edit the sudoers file. As root run:
# visudo
# Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
# Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# Database
# Install mysql and enable the mysqld service to start on boot:
#yum install -y mysql-server mysql-devel
yum install mysql-server mysql-devel
chkconfig mysqld on
service mysqld start
# Secure your installation:
mysql_secure_installation
# Login to MySQL (type the database root password):
mysql -u root -p

# Create a user for GitLab (change $password in the command below to a real password you pick):
# CREATE USER 'git'@'localhost' IDENTIFIED BY '$password';
# Ensure you can use the InnoDB engine which is necessary to support long indexes. If this fails, check your MySQL config files (e.g. /etc/mysql/*.cnf, /etc/mysql/conf.d/*) for the setting "innodb = off".

# SET storage_engine=INNODB;
# Create the GitLab production database:
# CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
# Grant the GitLab user necessary permissions on the table:
# GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'git'@'localhost';
# Try connecting to the new database with the new user:
# sudo -u git -H mysql -u git -p -D gitlabhq_production


# 5. Redis
#Make sure redis is started on boot:
chkconfig redis on

cp /etc/redis.conf /etc/redis.conf.orig

# Disable Redis listening on TCP by setting 'port' to 0:
sed 's/^port .*/port 0/' /etc/redis.conf.orig | sudo tee /etc/redis.conf

# Enable Redis socket for default CentOS path:
echo 'unixsocket /var/run/redis/redis.sock' | sudo tee -a /etc/redis.conf
echo -e 'unixsocketperm 0770' | sudo tee -a /etc/redis.conf
# Create the directory which contains the socket
mkdir /var/run/redis
chown redis:redis /var/run/redis
chmod 755 /var/run/redis


