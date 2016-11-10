#!/bin/bash

DEV=$2
if [ $3 ] 
        then
        rate=$( expr $3 \* 1024 )
fi

if [ $4 ]
        then
        uprate=$( expr $4 \* 1024 )
fi

usage() {
echo "(usage): `basename $0` [start | stop | status ] DEVNAME rate uprate"
echo "argument effect"
echo "start   :start traffic control"
echo "stop    :stop traffic control"
echo "status  :show traffic control"
echo "DEVNAME  :network card name"
echo "rate              :download rate"
echo "uprate    :upload rate"
}


if [ $# -lt 2 ] || [ $# -gt 4 ]
        then
        echo "$@"
        usage
        exit 1
fi

ifconfig $DEV >/dev/null 2>&1
if [ $? -ne 0 ]
        then
        echo "$DEV:device not found"
        exit 1
fi
echo $rate
echo $uprate

start() {
if [ ! $DEV ] || [ ! $rate ] || [ ! $uprate ]
        then
        usage
        exit 1
fi


## clear all qdisc
tc qdisc del dev $DEV root 2>/dev/null
tc qdisc del dev $DEV ingress 2>/dev/null
##define traffic control
tc qdisc add dev $DEV  handle ffff:  ingress 
tc filter add dev $DEV parent ffff: protocol ip prio 49153 u32 match ip src 0.0.0.0/0 police rate ${uprate}kbit burst 50k mtu 64k drop flowid :1
tc qdisc add dev $DEV root handle 1: htb default 1
tc class add dev $DEV parent 1: classid 1:1  htb rate "$rate"kbit
tc qdisc add dev $DEV parent 1:1  handle 2: sfq
#tc filter add dev $DEV parent 1:0 protocol ip pref 49153 fw 
#tc filter add dev $DEV parent 1:0 protocol ip pref 49153  handle 0x1 fw  flowid :1 
}

stop(){

if [ ! $DEV ]
        then
        echo "$@"
        usage
        exit 1
fi

echo -n "(clear all qdisc)"
( tc qdisc del dev $DEV root &&  tc qdisc del dev $DEV  ingress && echo "ok.delete success!" ) || echo "error."
}
#show status
status() {

if [ ! $DEV ]
        then
        echo "$@"
        usage
        exit 1
fi

echo "1.show qdisc $DEV  (show download qdisc):----------------------------------------------"
tc -s qdisc show dev $DEV
echo "2.show class $DEV  (show download filter):----------------------------------------------"
tc class show dev $DEV
}

case "$1" in
start)
( start && echo "$DEV TC started!" ) || echo "error."
exit 0
;;

stop)
( stop && echo "$DEV TC stopped!" ) || echo "error."
exit 0
;;
status)
status
;;

*) usage
exit 1
;;
esac
