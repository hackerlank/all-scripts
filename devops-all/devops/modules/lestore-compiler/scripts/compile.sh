#!/bin/bash


sudo yum -y install pcre-devel openssl-devel zlib-devel

sudo rm -fr ~/rpmbuild
dos2unix nginx.init php-5.3.20/make_install_php.sh nginx-1.2.6/make_install_nginx.sh #php-fpm.init 
mkdir -p ~/rpmbuild/{SOURCES,SPECS,SRPMS,RPMS,BUILD}
cp -f *.spec ~/rpmbuild/SPECS
cp -f *.init ~/rpmbuild/SOURCES
tar czf make_install_php.tar.gz php-5.3.20
tar czf make_install_nginx.tar.gz nginx-1.2.6
cp -f *.tar.gz ~/rpmbuild/SOURCES

rpmbuild -ba ~/rpmbuild/SPECS/nginx.lebbay.sh.spec
rpmbuild -ba ~/rpmbuild/SPECS/php.lebbay.sh.spec

#cp ~/rpmbuild/SRPMS/*.rpm .
#cp ~/rpmbuild/RPMS/x86_64/*.rpm .

#rm -f *~ *.tar.gz ; tar czf compiler.tar.gz *