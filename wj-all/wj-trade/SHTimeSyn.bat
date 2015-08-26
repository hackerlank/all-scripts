echo off
w32tm /config /manualpeerlist:"172.16.1.18" /syncfromflags:manual
w32tm /config /update
w32tm /resync