#!/bin/bash
# modifed JyServer T2 IP addr 
# config files is : HOME/jyserver/Hsconfig.ini

des_path="/cygdrive/d/jyserver"

a=0

# Server IP addr
IPs=(1 2 3 4 5 6 7 8)
# T2 IP addr
T2IPs=(192.168.81.55 192.168.81.56 192.168.81.57 192.168.81.58 192.168.81.59 192.168.81.60 192.168.81.61 192.168.81.62 192.168.81.63 192.168.81.64 192.168.81.65 192.168.81.55 192.168.81.56 192.168.81.57 192.168.81.58 192.168.81.59 192.168.81.60 192.168.81.61 192.168.81.62 192.168.81.63 192.168.81.64 192.168.81.65)

for ip in ${IPs[@]};do
    for t2ip in ${T2IPs[$a]};do
   	#不同机房用不通的F5地址
        echo "JyServer IP is: $ip"
        echo "Now T2 IP is: $t2ip"
        #sed -i "s/servers=aaaa/servers=172.16.9.30:19019;${j}:19019/g"  /cygdrive/d/yjserver/Hsconfig.ini
	ssh Administrator@${ip} -t -A "sed -i "s/servers=aaaa/servers=172.16.9.30:19019;${t2ip}:19019/g" $(des_path)/Hsconfig.ini; unix2dos.exe $(des_path)/Hsconfig.ini"
     done
     let a=$a+1
done
