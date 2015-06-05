#!/bin/bash
:<<INFO
#by Zandy
#created 2009/03/
#lastmod 2009/08/23|2010/01/31|php5.3: 2011/03/25
INFO
#SRC_DIR="/home/zandy/src/"
DESTDIR="$1"
echo Using dest dir $DESTDIR
SRC_DIR="$PWD"
WEBSERVER_DIR="/usr/local/webserver"

if [ "$1" = "vps" ]; then
	sudo su
	ulimit -v 60000
fi

export PHP_VER="5.3.20"
export PHP_APC_VER="3.1.9"
#export PHP_MEMCACHE_VER="3.0.7"
export PHP_MEMCACHE_VER="2.2.7"
#export PHP_MEMCACHED_VER="1.0.2"
export PHP_MEMCACHED_VER="2.1.0"
export PHP_EACCELERATOR_VER="0.9.6.1"
export PHP_XHPROF_VER="0.9.2"

export RE2C_VER="0.13.5"

export PHP_PATH="$WEBSERVER_DIR/php5.3"
export PHP_PATH_DEST="$DESTDIR$PHP_PATH"
[ ! -d $PHP_PATH ] && sudo mkdir -p $PHP_PATH

export USERGROUP=www-data

if grep -q -s 'Debian' /etc/issue || grep -q -s 'Ubuntu' /etc/issue; then
	sudo apt-get -y install build-essential gcc g++ make automake openssl libpcre3 libpcre3-dev libssl-dev libmysqlclient-dev libxml2-dev libcurl3-dev libjpeg-dev libpng-dev libfreetype6-dev libmcrypt-dev libbz2-dev libxpm-dev libtool patch lemon re2c bison libgmp3-dev libmemcached-dev graphviz
	libmemcached_ver=$(apt-cache show libmemcached-dev|grep '^Version\s*:'|awk -F: '{gsub("-","",$2);print $2*1000}')
else
	#centOS or readhat or amazon linux AMI
	sudo yum -y install libxml2-devel bzip2-devel libcurl-devel libjpeg-devel libpng-devel libXpm-devel libtiff-devel freetype-devel libmcrypt-devel libc-client-devel mhash-devel mysql-devel pspell-devel libtidy-devel libxslt-devel lemon bison ncurses-devel autoconf automake flex re2c bison gcc-c++ libtool-ltdl-devel gmp-devel libmemcached-devel graphviz
	###export PHP_MEMCACHED_VER="1.0.2"
	libmemcached_ver=$(yum info libmemcached|grep '^Version\s*:'|awk -F: '{gsub("-","",$2);print $2*1000}')
fi
if [ $? -ne 0 ]; then echo "--make&install php-$PHP_VER: init env failed."; exit 1; else echo "--make&install php-$PHP_VER: init env ok."; fi

wget -c -O php-$PHP_VER.tar.gz "http://www.php.net/get/php-$PHP_VER.tar.gz/from/this/mirror"
wget -c "http://pecl.php.net/get/APC-$PHP_APC_VER.tgz"
wget -c "http://pecl.php.net/get/memcache-$PHP_MEMCACHE_VER.tgz"
wget -c "http://pecl.php.net/get/memcached-$PHP_MEMCACHED_VER.tgz"
#@see https://github.com/eaccelerator/eaccelerator @see http://eaccelerator.net/ -- found at 20121022
#wget -c "http://bart.eaccelerator.net/source/$PHP_EACCELERATOR_VER/eaccelerator-$PHP_EACCELERATOR_VER.tar.bz2"
#see http://sourceforge.net/projects/eaccelerator/
wget -c "http://downloads.sourceforge.net/project/eaccelerator/eaccelerator/eAccelerator%20$PHP_EACCELERATOR_VER/eaccelerator-$PHP_EACCELERATOR_VER.zip"
wget -c "http://pecl.php.net/get/xhprof-$PHP_XHPROF_VER.tgz"

[ -e php-$PHP_VER/ ] && rm -rf php-$PHP_VER/
[ -e APC-$PHP_APC_VER/ ] && rm -rf APC-$PHP_APC_VER/
[ -e memcache-$PHP_MEMCACHE_VER/ ] && rm -rf memcache-$PHP_MEMCACHE_VER/
[ -e memcached-$PHP_MEMCACHED_VER/ ] && rm -rf memcached-$PHP_MEMCACHED_VER/
[ -e eaccelerator-$PHP_EACCELERATOR_VER/ ] && rm -rf eaccelerator-$PHP_EACCELERATOR_VER/
[ -e xhprof-$PHP_XHPROF_VER/ ] && rm -rf xhprof-$PHP_XHPROF_VER/
[ -e re2c-$RE2C_VER/ ] && rm -rf re2c-$RE2C_VER/

# {{{ check re2c version
re2c -v >/dev/null 2>&1
if [ $? -eq 127 ]; then echo "re2c not found, Please install re2c first for php compilation."; exit 127; fi
re2c_vernum=`re2c -V 2>/dev/null`
if test -z "$re2c_vernum" || test "$re2c_vernum" -lt "1304"; then
	echo "Your will need re2c 0.13.4 or later if you want to regenerate PHP parsers."
	test -f re2c-$RE2C_VER.tar.gz && rm -f re2c-$RE2C_VER.tar.gz
	#wget http://sourceforge.net/projects/re2c/files/re2c/$RE2C_VER/re2c-$RE2C_VER.tar.gz/download
	wget http://downloads.sourceforge.net/project/re2c/re2c/$RE2C_VER/re2c-$RE2C_VER.tar.gz
	tar zxf re2c-$RE2C_VER.tar.gz
	cd re2c-$RE2C_VER/
	#./configure --prefix=/usr
	./configure && make && sudo make install 
	ist_re2c=$?
	sudo ldconfig
	if [ "$ist_re2c" -eq 0 ]; then echo "make & install `re2c -v` ok."; else echo "make & install `re2c -v` failed."; exit 1; fi
else
	echo "re2c version is `re2c -v | cut -d ' ' -f 2  2>/dev/null`"
fi
# }}}

#compile php
cd $SRC_DIR
tar zxf php-$PHP_VER.tar.gz
cd php-$PHP_VER/
#./configure --prefix=$PHP_PATH --with-config-file-path=$PHP_PATH/etc --with-fpm-user=$USERGROUP --with-fpm-group=$USERGROUP --with-mysql --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --enable-xml --disable-rpath --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-zlib --with-bz2 --enable-zip --with-mysql=/usr/bin/mysql_config --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-soap --enable-cli --with-iconv-dir=/usr/local --with-libxml-dir=/usr --with-xpm-dir=/usr/ --with-gmp --enable-pcntl
./configure --prefix=$PHP_PATH --with-config-file-path=$PHP_PATH/etc --with-fpm-user=$USERGROUP --with-fpm-group=$USERGROUP --enable-mysqlnd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --enable-xml --disable-rpath --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-zlib --with-bz2 --enable-zip --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-soap --enable-cli --with-iconv-dir=/usr/local --with-libxml-dir=/usr --with-xpm-dir=/usr/ --with-gmp --enable-pcntl --enable-exif --with-libdir=lib64
#--with-libdir=lib64
if [ $? -ne 0 ]; then echo "--make&install php-$PHP_VER: configure failed."; exit 1; else echo "--make&install php-$PHP_VER: configure ok."; fi
make
if [ $? -ne 0 ]; then echo "--make&install php-$PHP_VER: make failed."; exit 1; else echo "--make&install php-$PHP_VER: make ok."; fi
#for rpm
sudo make install INSTALL_ROOT=$DESTDIR
#for extension compilation
sudo make install 
if [ $? -ne 0 ]; then echo "--make&install php-$PHP_VER: failed."; exit 1; else echo "--install&php-$PHP_VER ok."; fi
#[ -f $DESTDIR/usr/local/bin/php ] || ( [ -f $PHP_PATH/bin/php ] && sudo ln -s $PHP_PATH/bin/php $DESTDIR/usr/local/bin/php )

#php.ini & php-fpm.conf
ls php.ini-*
if [ $? -eq 0 ]; then
	sudo cp php.ini-* $PHP_PATH_DEST/etc/
fi
[ -f $PHP_PATH_DEST/etc/php.ini ] || ( [ -f php.ini-production ] && sudo cp php.ini-production $PHP_PATH_DEST/etc/php.ini )
[ -f $PHP_PATH_DEST/etc/php-fpm.conf ] || ( [ -f $PHP_PATH_DEST/etc/php-fpm.conf.default ] && sudo cp $PHP_PATH_DEST/etc/php-fpm.conf.default $PHP_PATH_DEST/etc/php-fpm.conf )
[ -f $DESTDIR/etc/rc.d/init.d/php-fpm ] || ( [ -f sapi/fpm/init.d.php-fpm ] && sudo mkdir -p $DESTDIR/etc/rc.d/init.d/ ; sudo cp sapi/fpm/init.d.php-fpm $DESTDIR/etc/rc.d/init.d/php-fpm ; sudo chmod a+x $DESTDIR/etc/rc.d/init.d/php-fpm)

#/usr/local/webserver/php5.3/lib/php/extensions/no-debug-non-zts-20090626/

#compile php-APC
cd $SRC_DIR
tar zxf APC-$PHP_APC_VER.tgz
cd APC-$PHP_APC_VER/
$PHP_PATH/bin/phpize
./configure --enable-apc --enable-apc-mmap --with-php-config=$PHP_PATH_DEST/bin/php-config
make
sudo make install INSTALL_ROOT=$DESTDIR
if [ $? -ne 0 ]; then echo "--install php-APC-$PHP_APC_VER failed."; exit 1; else echo "--install php-APC-$PHP_APC_VER ok."; fi

#compile php-memcache
cd $SRC_DIR
tar zxf memcache-$PHP_MEMCACHE_VER.tgz
cd memcache-$PHP_MEMCACHE_VER/
$PHP_PATH/bin/phpize
./configure --enable-memcache --with-php-config=$PHP_PATH_DEST/bin/php-config
make
sudo make install INSTALL_ROOT=$DESTDIR
if [ $? -ne 0 ]; then
	echo "--install php-memcache-$PHP_MEMCACHE_VER failed."
	exit 1
else
	echo "--install php-memcache-$PHP_MEMCACHE_VER ok."
	
	echo "config memcache for php:"
	grep "memcache.so" $PHP_PATH_DEST/etc/php.ini
	if [ $? -ne 0 ]; then
		test -d /opt/data1/memcache || sudo mkdir -p /opt/data1/memcache
		cat <<- EOF | sudo tee -a $PHP_PATH_DEST/etc/php.ini

	extension=memcache.so
	[memcache]
	memcache.dbpath="/opt/data1/memcache"
	memcache.maxreclevel=0
	memcache.maxfiles=0
	memcache.archivememlim=0
	memcache.maxfilesize=0
	memcache.maxratio=0

EOF
	fi
fi

## {{{ install libmemcached for php-memcached
#if test -z "$libmemcached_ver" || test "$libmemcached_ver" -lt 400; then
#	libmemcached_ver="0.48"
#	if test -d /usr/include/libmemcached/ && grep -rn "$libmemcached_ver" /usr/include/libmemcached/ ; then
#		:
#	else
#		wget http://launchpad.net/libmemcached/1.0/$libmemcached_ver/+download/libmemcached-$libmemcached_ver.tar.gz
#		tar zxf libmemcached-$libmemcached_ver.tar.gz
#		cd libmemcached-$libmemcached_ver/
#		./configure --with-memcached --prefix=/usr
#		make && sudo make install INSTALL_ROOT=$DESTDIR
#		if [ $? -ne 0 ]; then echo "--install libmemcached-$libmemcached_ver failed."; exit 1; else echo "--install libmemcached-$libmemcached_ver #ok."; fi
#	fi
#fi
## }}}
#
##compile php-memcached
#cd $SRC_DIR
#tar zxf memcached-$PHP_MEMCACHED_VER.tgz
#cd memcached-$PHP_MEMCACHED_VER/
#$PHP_PATH/bin/phpize
#./configure --enable-memcached --with-php-config=$PHP_PATH_DEST/bin/php-config
##./configure --enable-memcached --with-libmemcached-dir=/usr/include/libmemcached/ --with-php-config=$PHP_PATH_DEST/bin/php-config
##--with-libmemcached-dir=DIR
#make
#sudo make install INSTALL_ROOT=$DESTDIR
#if [ $? -ne 0 ]; then echo "--install php-memcached-$PHP_MEMCACHED_VER failed."; exit 1; else echo "--install php-memcached-$PHP_MEMCACHED_VER ok."; fi

#compile php-eaccelerator
cd $SRC_DIR
#tar jxf eaccelerator-$PHP_EACCELERATOR_VER.tar.bz2
unzip eaccelerator-$PHP_EACCELERATOR_VER.zip
cd eaccelerator-$PHP_EACCELERATOR_VER/
$PHP_PATH/bin/phpize
./configure --enable-eaccelerator=shared --with-eaccelerator-doc-comment-inclusion --with-php-config=$PHP_PATH_DEST/bin/php-config 
make
sudo make install INSTALL_ROOT=$DESTDIR
if [ $? -ne 0 ]; then
	echo "--install php-eaccelerator-$PHP_EACCELERATOR_VER failed."
	exit 1
else
	echo "--install php-eaccelerator-$PHP_EACCELERATOR_VER ok."

	echo "config eaccelerator for php:"
	grep "eaccelerator.so" $PHP_PATH_DEST/etc/php.ini
	if [ $? -ne 0 ]; then
		test -d /opt/data1/eaccelerator/cache || sudo mkdir -p /opt/data1/eaccelerator/cache
		cat <<- EOF | sudo tee -a $PHP_PATH_DEST/etc/php.ini

	[eaccelerator]
	zend_extension="$PHP_PATH/lib/php/extensions/no-debug-non-zts-20090626/eaccelerator.so"
	eaccelerator.shm_size="128"
	eaccelerator.cache_dir="/opt/data1/eaccelerator/cache"
	eaccelerator.enable="1"
	eaccelerator.optimizer="1"
	eaccelerator.check_mtime="1"
	eaccelerator.debug="0"
	eaccelerator.filter=""
	eaccelerator.shm_max="0"
	eaccelerator.shm_ttl="300"
	eaccelerator.shm_prune_period="120"
	eaccelerator.shm_only="0"
	eaccelerator.compress="1"
	eaccelerator.compress_level="9"

EOF
	fi
fi

#compile php-xhprof
cd $SRC_DIR
tar zxf xhprof-$PHP_XHPROF_VER.tgz
cd xhprof-$PHP_XHPROF_VER/extension/
$PHP_PATH/bin/phpize
./configure --enable-xhprof --with-php-config=$PHP_PATH_DEST/bin/php-config
make
sudo make install INSTALL_ROOT=$DESTDIR
if [ $? -ne 0 ]; then
	echo "--install php-xhprof-$PHP_XHPROF_VER failed."
	exit 1
else
	echo "--install php-xhprof-$PHP_XHPROF_VER ok."
	
	echo "config xhprof for php:"
	grep "xhprof.so" $PHP_PATH_DEST/etc/php.ini
	if [ $? -ne 0 ]; then
		test -d /opt/data1/xhprof || sudo mkdir -p /opt/data1/xhprof
		sudo sh -c "cat <<- EOF >> $PHP_PATH_DEST/etc/php.ini

	[xhprof]
	extension=xhprof.so
	xhprof.output_dir=\"/opt/data1/xhprof\"

EOF"
	fi
fi




echo "all is ok."
