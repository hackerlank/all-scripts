echo off
w32tm /config /manualpeerlist:"197.1.1.104" /syncfromflags:manual
w32tm /config /update
w32tm /resync