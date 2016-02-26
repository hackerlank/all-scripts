#!/bin/bash 
# add new wordpress site 
# eg: add_new_wordpress.sh bluvideo.it
# eg: add_new_wordpress.sh doc-share.it
# eg 
DOMAIN=$1
echo $DOMAIN
APPNAME=$(echo $DOMAIN|awk -F. '{print $1}')

DIR=/root/all_files
NGINX_DIR=/etc/nginx/conf.d
SSL_DIR=/etc/nginx/ssl
WEB_DIR=/var/www/http
# Setup 1 create dababases
if [ ! -e $DIR/${DOMAIN}.sql ]; then
		cp -f  $DIR/domain.sql $DIR/${DOMAIN}.sql
fi
sed -i -r "s/domain/${DOMAIN}/g" $DIR/${DOMAIN}.sql
if [ ! -e $DIR/create_${DOMAIN}_db.sh ];then
	cp -f $DIR/create_db.sh  $DIR/create_${DOMAIN}_db.sh
fi
		sed -i -r "s/domain/${DOMAIN}/g" $DIR/create_${DOMAIN}_db.sh

bash $DIR/create_${DOMAIN}_db.sh
if [ $? = 0 ];then
	echo "Create $DOMAIN Database OK ^-^ "
	rm -rf $DIR/${DOMAIN}.sql $DIR/create_${DOMAIN}_db.sh
else
	exit 1;
fi
		#echo "Create $DOMAIN Database OK ^-^ "

# Setup 2 create nginx conf 
if [ ! -e $DIR/${DOMAIN}.conf ];then
		cp -f $DIR/domain.conf $DIR/${DOMAIN}.conf
	fi
	#sed -i -r "s/domain/${APPNAME}/g" $DIR/${DOMAIN}.conf
	sed -i -r "s/DOMAIN/${DOMAIN}/g" $DIR/${DOMAIN}.conf

	mv $DIR/${DOMAIN}.conf  ${NGINX_DIR}/
	echo "Create $DOMAIN nginx conf OK ^-^ "
	cd /tmp
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.${DOMAIN}" -keyout ${DOMAIN}.key  -out ${DOMAIN}.crt
	mv ${DOMAIN}.key ${SSL_DIR}
	mv ${DOMAIN}.crt ${SSL_DIR}
	echo "Create $DOMAIN SSL conf OK ^-^ "
	nginx -t
	if [ $? = 0 ];then
			/etc/init.d/nginx reload
		fi
		#/etc/init.d/nginx reload

		# Setup 3  create wordpress files
		if [ ! -e $DIR/$DOMAIN ]; then
				cp -Rf $DIR/wordpress $DIR/$DOMAIN
			fi
			sed -i -r "s/domain/${DOMAIN}/g" $DIR/${DOMAIN}/wp-config.php

			mv $DIR/${DOMAIN} $WEB_DIR/
			find $WEB_DIR/${DOMAIN} -name "footer.php" |xargs -I {} chmod 666 {} 2> /dev/null
			find $WEB_DIR/${DOMAIN} -name "header.php" |xargs -I {} chmod 666 {} 2> /dev/null
			chown -R nginx:nginx $WEB_DIR/${DOMAIN}
			if [ ! -e $WEB_DIR/${DOMAIN}/wp-content/uploads ];then
					mkdir -p $WEB_DIR/${DOMAIN}/wp-content/uploads
				fi
				chmod -R 777 $WEB_DIR/${DOMAIN}/wp-content/uploads
				echo "Create $DOMAIN wordpress files OK ^-^ "
