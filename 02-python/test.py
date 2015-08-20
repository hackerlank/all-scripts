#!/usr/bin/python

import re

f=open("/tmp/test.txt", 'r')
fd=open("/tmp/test01.txt", 'r')

count=0

for i in f.readlines():
	print  str(i)
	for j in fd.readlines():
		ms=re.findall(str(i), j)
		if len(ms) > 0:
			print j
		else:
			print Failed
f.close()
fd.close()

