#!/bin/bash 

# install GitLab on CentOS6.5

#-----------------------------------------------------------------------------#

# 1. Installing the operating system (CentOS 6.5 Minimal)

# 1.1 Install yum 
# Download the GPG key for EPEL repository from fedoraproject and install it on your system:
wget -O /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 https://www.fedoraproject.org/static/0608B895.txt
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

# If you can't see them listed, use the folowing command (from yum-utils package) to enable them:
# yum-config-manager --enable epel --enable PUIAS_6_computational

#-----------------------------------------------------------------------------#

# 1.2 Install the required tools for GitLab

#yum -y update
#yum -y groupinstall 'Development Tools'
#yum -y install readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui redis sudo wget crontabs logwatch logrotate perl-Time-HiRes git cmake libcom_err-devel.i686 libcom_err-devel.x86_64

yum groupinstall 'Development Tools'
yum install readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui redis sudo wget crontabs logwatch logrotate perl-Time-HiRes git cmake libcom_err-devel.i686 libcom_err-devel.x86_64

# For reStructuredText markup language support, install required package:
#yum -y install python-docutils
yum install python-docutils

#-----------------------------------------------------------------------------#

# 1.3 Install mail server 
yum -y install postfix

#-----------------------------------------------------------------------------#

# 2. Ruby
# Download Ruby and compile it:
mkdir /tmp/ruby && cd /tmp/ruby
curl --progress ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz | tar xz
cd ruby-2.1.2
./configure --disable-install-rdoc
make
make prefix=/usr/local install

# Install the Bundler Gem:
gem sources -r https://rubygems.org/
gem sources -a http://ruby.taobao.org/
gem install bundler --no-doc

# Logout and login again for the $PATH to take effect. Check that ruby is properly installed with:
#-----------------------------------------------------------------------------#

# 3. System Users
# Create a git user for Gitlab:
adduser --system --shell /bin/bash --comment 'GitLab' --create-home --home-dir /home/git/ git
# Important: In order to include /usr/local/bin to git user's PATH, one way is to edit the sudoers file. As root run:
visudo
# Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
# add 
# Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

#-----------------------------------------------------------------------------#

# 4. Database
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
mysql> CREATE USER 'git'@'localhost' IDENTIFIED BY '$password';
# Ensure you can use the InnoDB engine which is necessary to support long indexes. If this fails, check your MySQL config files (e.g. /etc/mysql/*.cnf, /etc/mysql/conf.d/*) for the setting "innodb = off".

mysql> SET storage_engine=INNODB;
# Create the GitLab production database:
mysql> CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
# Grant the GitLab user necessary permissions on the table:
mysql> GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'git'@'localhost';
# Try connecting to the new database with the new user:
sudo -u git -H mysql -u git -p -D gitlabhq_production

#-----------------------------------------------------------------------------#

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
mkdir -p  /var/run/redis
chown redis:redis /var/run/redis
chmod 755 /var/run/redis

service redis start
# Add git to the redis group:
usermod -aG redis git

#-----------------------------------------------------------------------------#

# 6. GitLab
cd /home/git
# Clone GitLab repository
sudo -u git -H git clone https://gitlab.com/gitlab-org/gitlab-ce.git -b 7-4-stable gitlab

# Go to GitLab installation folder
cd /home/git/gitlab

# Copy the example GitLab config
sudo -u git -H cp config/gitlab.yml.example config/gitlab.yml

# Update GitLab config file, follow the directions at top of file
# sudo -u git -H editor config/gitlab.yml
sudo -u git -H vim config/gitlab.yml

# Make sure GitLab can write to the log/ and tmp/ directories
chown -R git log/
chown -R git tmp/
chmod -R u+rwX log/
chmod -R u+rwX tmp/

# Create directory for satellites
sudo -u git -H mkdir /home/git/gitlab-satellites
chmod u+rwx,g=rx,o-rwx /home/git/gitlab-satellites

# Make sure GitLab can write to the tmp/pids/ and tmp/sockets/ directories
chmod -R u+rwX tmp/pids/
chmod -R u+rwX tmp/sockets/

# Make sure GitLab can write to the public/uploads/ directory
chmod -R u+rwX  public/uploads

# Copy the example Unicorn config
sudo -u git -H cp config/unicorn.rb.example config/unicorn.rb

# Find number of cores
nproc

# Enable cluster mode if you expect to have a high load instance
# Ex. change amount of workers to 3 for 2GB RAM server
# Set the number of workers to at least the number of cores
# sudo -u git -H editor config/unicorn.rb
sudo -u git -H vim config/unicorn.rb

# Copy the example Rack attack config
sudo -u git -H cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb

# Configure Git global settings for git user, useful when editing via web
# Edit user.email according to what is set in gitlab.yml
sudo -u git -H git config --global user.name "GitLab"
sudo -u git -H git config --global user.email "example@example.com"
sudo -u git -H git config --global core.autocrlf input

# Configure Redis connection settings
sudo -u git -H cp config/resque.yml.example config/resque.yml

# Change the Redis socket path if you are not using the default CentOS configuration
# sudo -u git -H editor config/resque.yml
sudo -u git -H vim config/resque.yml

# Configure GitLab DB settings
sudo -u git cp config/database.yml.mysql config/database.yml
# Make config/database.yml readable to git only
sudo -u git -H chmod o-rwx config/database.yml

# Install Gems
cd /home/git/gitlab
# Or for MySQL (note, the option says "without ... postgres")
sudo -u git -H bundle install --deployment --without development test postgres aws
# cd /home/git/gitlab and modified Gemfile for http://rubygems.org/
# fixed Installing charlock_holmes 0.6.9.4 with native extensions
yum install icu libicu-devel libicu
# fixed Installing rugged 0.21.2 with native extensions
yum install cmake


# Install GitLab shell
# Run the installation task for gitlab-shell (replace `REDIS_URL` if needed):
# install gitlab-shell use v2.0.1
#sudo -u git -H bundle exec rake gitlab:shell:install[v2.1.0] REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production
sudo -u git -H bundle exec rake gitlab:shell:install[v2.0.1] REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production

# By default, the gitlab-shell config is generated from your main GitLab config.
# You can review (and modify) the gitlab-shell config as follows:
sudo -u git -H vim /home/git/gitlab-shell/config.yml

# Ensure the correct SELinux contexts are set
# Read http://wiki.centos.org/HowTos/Network/SecuringSSH
#restorecon -Rv /home/git/.ssh
# Initialize Database and Activate Advanced Features
sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production

# Install Init Script
wget -O /etc/init.d/gitlab https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/init/sysvinit/centos/gitlab-unicorn
chmod +x /etc/init.d/gitlab
chkconfig --add gitlab
chkconfig gitlab on

# Set up logrotate
cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab
# Check Application Status
# Check if GitLab and its environment are configured correctly:
sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
# Compile assets
sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production
# Start your GitLab instance
service gitlab start

#-----------------------------------------------------------------------------#

# 7. Configure the web server
