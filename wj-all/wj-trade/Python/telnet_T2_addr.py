#encoding=utf-8
import sys
import telnetlib
import time

HOSTS=['192.168.81.54','192.168.81.55','192.168.81.56','192.168.81.57','192.168.81.58','192.168.81.59','192.168.81.60','192.168.81.61','192.168.81.62','192.168.81.63','192.168.81.64','192.168.81.65']
time.sleep(3)
for HOST in HOSTS:
    try:
        tn = telnetlib.Telnet(HOST,port=19019,timeout=3)
        print HOST+" is OK "
    	tn.close()
    except:
        print HOST+" ******* NO *******"

#JENKINS 分发所有到script cygwin 执行 python /cygdrive/d/script/Python/telnet_T2_addr.py
