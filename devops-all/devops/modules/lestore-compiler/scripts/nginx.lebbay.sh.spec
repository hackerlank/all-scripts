%define nginx_user      www-data
%define nginx_group     www-data
%define version   1.2.6
%define ngx_cache_purge_version         2.0
%define nginx_home      /usr/local/webserver/nginx
%define nginx_confdir   %{nginx_home}/conf
%define real_name       nginx
%define dist            lebbay
%define _unpackaged_files_terminate_build 0

Name:           nginx
Version:        %{version}
Release:        1.%{dist}
Summary:        Robust, small and high performance http and reverse proxy server
Group:          System Environment/Daemons

# BSD License (two clause)
# http://www.freebsd.org/copyright/freebsd-license.html
License:        BSD
URL:            http://nginx.org/
BuildRoot:      %{_tmppath}/%{real_name}-%{version}-%{release}-buildroot-%(%{__id_u} -n)

BuildRequires:      pcre-devel,zlib-devel,openssl-devel, gcc, make, dos2unix
#perl(ExtUtils::Embed)
Requires:           pcre,zlib,openssl
#Requires:           perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
# for /usr/sbin/useradd
Requires(pre):      shadow-utils
Requires(post):     chkconfig
# for /sbin/service
Requires(preun):    chkconfig, initscripts
Requires(postun):   initscripts

Source0:    make_install_nginx.tar.gz
Source1:    %{real_name}.init

#Source1:    %{real_name}.logrotate
#Source2:    virtual.conf
#Source3:    %{real_name}.init ## Its init script does not contained in this post

%description
This package is built by Lebbay.
The current version for this is %{version}, which can be downloaded from http://nginx.org/.

%prep
%setup


%build

%install
chmod +x make_install_nginx.sh
./make_install_nginx.sh %{buildroot}
dos2unix %{SOURCE1}
%{__install} -p -D -m 0744 %{SOURCE1} %{buildroot}/%{_initrddir}/%{real_name}
#sudo %{__install} -p -D -m 0744 %{SOURCE1} %{buildroot}/%{_initrddir}/%{real_name}

%clean
[ "%{buildroot}" != "/" ] && sudo rm -rf %{buildroot}

%pre

%post
#/sbin/chkconfig --add %{real_name}

%preun
#if [ $1 = 0 ]; then
#    /sbin/service %{real_name} stop >/dev/null 2>&1
#    /sbin/chkconfig --del %{real_name}
#fi

%postun
#if [ $1 -ge 1 ]; then
#    /sbin/service %{real_name} condrestart > /dev/null 2>&1 || :
#fi

%files
%defattr(-,%{nginx_user},%{nginx_group},-)
%attr(-,root,root) %{_initrddir}/%{real_name}
%dir %{nginx_home}
%dir %{nginx_confdir}
#%dir %{nginx_confdir}/conf.d
#%config(noreplace) %{nginx_confdir}/conf.d/*.conf
%config(noreplace) %{nginx_confdir}/win-utf
%config(noreplace) %{nginx_confdir}/mime.types
%config(noreplace) %{nginx_confdir}/mime.types.default
%config(noreplace) %{nginx_confdir}/fastcgi_params
%config(noreplace) %{nginx_confdir}/fastcgi_params.default
%config(noreplace) %{nginx_confdir}/scgi_params
%config(noreplace) %{nginx_confdir}/scgi_params.default
%config(noreplace) %{nginx_confdir}/uwsgi_params
%config(noreplace) %{nginx_confdir}/uwsgi_params.default
%config(noreplace) %{nginx_confdir}/fastcgi.conf
%config(noreplace) %{nginx_confdir}/fastcgi.conf.default
%config(noreplace) %{nginx_confdir}/koi-win
%config(noreplace) %{nginx_confdir}/koi-utf
%config(noreplace) %{nginx_confdir}/%{real_name}.conf
%config(noreplace) %{nginx_confdir}/%{real_name}.conf.default
#%config(noreplace) %{_sysconfdir}/logrotate.d/%{real_name}
%{nginx_home}/sbin
%{nginx_home}/html
%dir %{nginx_home}/logs

%changelog
