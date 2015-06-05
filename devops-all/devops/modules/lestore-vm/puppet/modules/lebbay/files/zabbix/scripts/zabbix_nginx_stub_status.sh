#! /bin/bash
:<<EOF
By Zandy
EOF

case $1 in
	active )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | grep 'Active' | awk '{print $NF}'
		;;
	reading )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | grep 'Reading' | awk '{print $2}'
		;;
	writing )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | grep 'Writing' | awk '{print $4}'
		;;
	waiting )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | grep 'Waiting' | awk '{print $6}'
		;;
	accepts )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | awk NR==3 | awk '{print $1}'
		;;
	handled )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | awk NR==3 | awk '{print $2}'
		;;
	requests )
		/usr/bin/curl "http://127.0.0.1:88/nginx_stub_status" 2>/dev/null | awk NR==3 | awk '{print $3}'
		;;
	* )
		echo "usage: $0 [active|reading|writing|waiting|accepts|handled|requests]"
		;;
esac
