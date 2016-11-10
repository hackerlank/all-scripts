#!/usr/bin/python
#coding:utf-8
#author weibo.com/killingwolf

import os
import sys


def main():

    role_dirs=['files', 'templates', 'tasks', 'handlers',
              'vars', 'defaults', 'meta']
    main_dirs=['tasks', 'handlers', 'vars', 'defaults', 'meta']

    if len(sys.argv) == 1:
        print "%s role_name" % sys.argv[0]
        sys.exit(1)
    
    role_name=sys.argv[1]
    
    if not os.path.exists(role_name):
        os.makedirs(role_name)

    for dir in role_dirs:
        if not os.path.exists("%s/%s" % (role_name,dir)):
            os.mkdir("%s/%s" % (role_name,dir))

    for dir in main_dirs:
        if not os.path.exists("%s/%s/main.yml" % (role_name,dir)):
            os.mknod("%s/%s/main.yml" % (role_name,dir))


if __name__ == '__main__':
    main()
