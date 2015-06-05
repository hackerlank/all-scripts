#! /bin/bash
:<<EOF
By Zandy
EOF

case $1 in
	"start since" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'start since' | awk '{print $NF}'
		;;
	"accepted conn" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'accepted conn' | awk '{print $NF}'
		;;
	"idle processes" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'idle processes' | awk '{print $NF}'
		;;
	"active processes" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep '^active processes' | awk '{print $NF}'
		;;
	"total processes" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'total processes' | awk '{print $NF}'
		;;
	"max active processes" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'max active processes' | awk '{print $NF}'
		;;
	"max children reached" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'max children reached' | awk '{print $NF}'
		;;
	"slow requests" )
		/usr/bin/curl "http://127.0.0.1:89/php_fpm_status" 2>/dev/null | grep 'slow requests' | awk '{print $NF}'
		;;
	* )
		echo "usage: $0 [active|reading|writing|waiting|accepts|handled|requests]"
		;;
esac
