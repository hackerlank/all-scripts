#!/usr/bin/python
#coding:utf-8

import sys
import json

from keystoneclient import utils
from keystoneclient.v2_0 import client as ks_client

reload(sys)
sys.setdefaultencoding('utf8')


def get_tenant_id(token, auth_url, tenant):
    """get tenant uuid by tenant name"""
    keystone = ks_client.Client(
        token = token,
        endpoint = auth_url,
        timeout = 10)
     
    try:
        return utils.find_resource(keystone.tenants, unicode(tenant)).id
    except:
        pass

if __name__ == "__main__":
    if len(sys.argv) == 4:
        token = sys.argv[1]
        auth_url = sys.argv[2]
        tenant = sys.argv[3]
        tenant_id = get_tenant_id(token, auth_url, tenant)
        if tenant_id:
            print tenant_id
