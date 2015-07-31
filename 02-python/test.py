#!/usr/bin/python


f=open("/tmp/test.txt")
r=f.readlines()
for i in r:
	if "OKT" in i:
		print "test"
	else: 
		print "NO"
f.close()
