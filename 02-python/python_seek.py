#!/bin/env python


fo = open("/tmp/test.txt","r")
print "Name:", fo.name

line = fo.readline()
print "Read line: %s" % (line)

fo.seek(1, 2)
line = fo.readline()
print "Read line: %s" % (line)

fo.close()


