%define php_fpm_user www-data
%define php_fpm_group www-data
%define php_home /usr/local/webserver/php5.3
%define mysql_dir /usr/bin/mysql_config
%define iconv_dir /usr/local
%define libxml_dir /usr
%define xpm_dir /usr
%define version 5.3.20
%define dist lebbay
#%define so_version 5

Name: php
Summary: PHP: Hypertext Preprocessor
Group: Development/Languages
Version: %{version}
Release: 1.%{dist}
License: The PHP license (see "LICENSE" file included in distribution)
Source0: make_install_php.tar.gz
#Source1: php-fpm.init
URL: http://www.php.net/
Packager: Lebbay
#Requires: httpd mysql sqlite
#Requires: mysql
#BuildRequires: httpd mysql sqlite
#BuildRequires: libxml2-devel mysql-devel bzip2-devel curl-devel libjpeg-devel libpng-devel libXpm-devel gd-devel freetype-devel gmp-devel libmcrypt-devel
#bison-devel 
Requires(post):     chkconfig
# for /sbin/service
Requires(preun):    chkconfig, initscripts
Requires(postun):   initscripts
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot-%(%{__id_u} -n)
%description
PHP is an HTML-embedded scripting language. Much of its syntax is
borrowed from C, Java and Perl with a couple of unique PHP-specific
features thrown in. The goal of the language is to allow web
developers to write dynamically generated pages quickly.

%prep
%setup

%build

%install
chmod +x make_install_php.sh
./make_install_php.sh %{buildroot}
sudo rm -fr %{buildroot}/.channels %{buildroot}/.depdb %{buildroot}/.depdblock %{buildroot}/.filemap %{buildroot}/.lock %{buildroot}/.registry
#dos2unix %{SOURCE1}
#sudo %{__install} -p -D -m 0744 %{SOURCE1} %{buildroot}/%{_initrddir}/php-fpm
#sudo mkdir -p %{buildroot}%{php_home}/etc/php.d

%clean
#rm -rf $RPM_BUILD_ROOT
[ "%{buildroot}" != "/" ] && sudo rm -rf %{buildroot}

%post
#/sbin/chkconfig --add php-fpm

%preun
#if [ $1 = 0 ]; then
#    /sbin/service php-fpm stop >/dev/null 2>&1
#    /sbin/chkconfig --del php-fpm
#fi

%postun
#if [ $1 -ge 1 ]; then
#    /sbin/service php-fpm condrestart > /dev/null 2>&1 || :
#fi

%files
#%defattr(-,root,root,-)
%defattr(-,%{php_fpm_user},%{php_fpm_group},-)
%attr(-,root,root) %{_initddir}/php-fpm
%{php_home}
#%config(noreplace) %{php_home}/etc/php.ini
#%config(noreplace) %{php_home}/etc/php-fpm.conf


%changelog

