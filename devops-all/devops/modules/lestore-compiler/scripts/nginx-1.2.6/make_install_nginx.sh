#!/bin/bash
:<<INFO
#by Zandy
#created 2009/03/
#lastmod 2009/08/23|2010/01/31|php5.3: 2011/03/25
#nginx1.0.0 -> ngx_cache_purge1.2/1.3
#nginx1.0.1 -> ngx_cache_purge1.3
INFO
#SRC_DIR="/home/zandy/src/"
DESTDIR="$1"
echo Using dest dir $DESTDIR
SRC_DIR="$PWD"
WEBSERVER_DIR="/usr/local/webserver"

#export NGINX_VER="1.0.15"
#export NGINX_CACHE_PURGE_VER="1.5"
export NGINX_VER="1.2.6"
#export NGINX_CACHE_PURGE_VER="1.6"
export NGINX_CACHE_PURGE_VER="2.0"

export NGINX_PATH="$WEBSERVER_DIR/nginx"
#[ ! -d $NGINX_PATH ] && sudo mkdir -p $NGINX_PATH

wget -c "http://nginx.org/download/nginx-$NGINX_VER.tar.gz"
wget -c "http://labs.frickle.com/files/ngx_cache_purge-$NGINX_CACHE_PURGE_VER.tar.gz"

#if grep -q -s 'Debian' /etc/issue || grep -q -s 'Ubuntu' /etc/issue; then
#	sudo apt-get -y install gcc make libpcre3-dev zlib1g-dev libssl-dev
#	USERGROUP=www-data
#else
#	#centOS or readhat or amazon linux AMI
#	sudo yum -y install gcc make pcre-devel zlib-devel openssl-devel
#	USERGROUP=apache
#fi
USERGROUP=www-data
#if [ $? -ne 0 ]; then echo "--make&install nginx-$NGINX_VER: init env failed."; exit 1; else echo "--make&install nginx-$NGINX_VER: init env ok."; fi

#compile nginx
cd $SRC_DIR
tar zxf nginx-$NGINX_VER.tar.gz
tar zxf ngx_cache_purge-$NGINX_CACHE_PURGE_VER.tar.gz
cd nginx-$NGINX_VER/
make clean
./configure --prefix=$NGINX_PATH --user=$USERGROUP --group=$USERGROUP --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --add-module=../ngx_cache_purge-$NGINX_CACHE_PURGE_VER
if [ $? -ne 0 ]; then echo "--make&install nginx-$NGINX_VER: configure failed."; exit 1; else echo "--make&install nginx-$NGINX_VER: configure ok."; fi
make
if [ $? -ne 0 ]; then echo "--make&install nginx-$NGINX_VER: make failed."; exit 1; else echo "--make&install nginx-$NGINX_VER: make ok."; fi
make install DESTDIR=$DESTDIR INSTALLDIRS=vendor
#sudo make install DESTDIR=$DESTDIR INSTALLDIRS=vendor
if [ $? -ne 0 ]; then echo "--make&install nginx-$NGINX_VER: failed."; exit 1; else echo "--make&install nginx-$NGINX_VER: ok."; fi

#for config
#test -d ${NGINX_PATH}/conf/sites-available || sudo mkdir -p ${NGINX_PATH}/conf/sites-available
#if [ $? -ne 0 ]; then echo "--make&install nginx-$NGINX_VER: create sites-available dir failed."; exit 1; else echo "--make&install nginx-$NGINX_VER: create sites-available dir ok."; fi
#test -d ${NGINX_PATH}/conf/sites-enabled || sudo mkdir -p ${NGINX_PATH}/conf/sites-enabled
#if [ $? -ne 0 ]; then echo "--make&install nginx-$NGINX_VER: create sites-enabled dir failed."; exit 1; else echo "--make&install nginx-$NGINX_VER: create sites-enabled dir ok."; fi

###if [ ! -d /opt/data1/nginxlogs ]; then
###	[ -d /opt/data1 ] || sudo mkdir -p /opt/data1
###	if [ -d $NGINX_PATH/logs ] && [ ! -L $NGINX_PATH/logs ]; then
###		sudo mv $NGINX_PATH/logs /opt/data1/nginxlogs
###		sudo ln -s /opt/data1/nginxlogs $NGINX_PATH/logs
###	elif [ -L $NGINX_PATH/logs ]; then
###		sudo rm -f $NGINX_PATH/logs
###		sudo ln -s /opt/data1/nginxlogs $NGINX_PATH/logs
###	elif [ ! -e $NGINX_PATH/logs ]; then
###		sudo ln -s /opt/data1/nginxlogs $NGINX_PATH/logs
###	fi
###fi




