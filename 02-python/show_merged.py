#!/usr/bin/python
#coding:utf-8

#import types
#import os
import sys
import urllib2
import json
import subprocess

token='BzFG4snwkmZrK9z'
domain_name='gitlab.intra.xxx.com'
branch_name='pre'
class BaseProject():

    def __init__(self):

        self.project_url = "http://%s/api/v3/projects?private_token=%s" % (domain_name,token)
        self.project_url_data = urllib2.urlopen(self.project_url).read()
    #def get_project_id(self):
    #    """get project id"""
    #    try:
    #        self.project_url_data = urllib2.urlopen(self.project_url).read()
    #        return self.project_url_data
    #    except Exception,e:
    #        print e

    #def project_name_id(self,project_url_data):
    def project_name_id(self):
        """get project name and project id"""
        #self.project_id_data = json.loads(project_url_data) 
        project_id_data = json.loads(self.project_url_data) 
        project_id = []
        project_name = []
        for v in project_id_data:
            name = v['name']
            project_name.append(name)
            id = v['id']
            project_id.append(id)
            name_id = dict(zip(project_name,project_id))
        return name_id
        #print  'project name is [%s] project id is [%s]' % (name,id)
    def merge_opend_url(self,project_id):
        try:
            self.merge_url = "http://%s/api/v3/projects/%s/merge_requests?state=opened&private_token=%s" % (domain_name,project_id,token)
            self.merge_url_data = urllib2.urlopen(self.merge_url).read()
            return self.merge_url_data
        except Exception,e:
            print e
    def get_merge_url(self):
        '''return project id and request id value'''
        name_id = self.project_name_id()
        request_id = []
        opend_project_id = []
        for project_name in name_id:
           project_id = name_id[project_name]
           merge_url_data = json.loads(self.merge_opend_url(project_id))
           for v in merge_url_data:
               merge_request_id=v['id']  # merge request id
               source_branch=v['source_branch']
               target_branch=v['target_branch']
               branch_status=v['state']
               if source_branch == 'pre' and target_branch == 'master':
                   opend_project_id.append(project_id)
                   request_id.append(merge_request_id)
               else:
                   print '%s merge branch error ,please order exec' % project_name
                   sys.exit(1)
               #print 'project name [%s] source branch is %s,target branch is %s status is %s' % (proName,sourceBranch,targetBranch,branchStatus)
        return dict(zip(opend_project_id,request_id))

    def print_merge_url(self):
        '''print merge url addreess'''
        project_req_id = self.get_merge_url()
        merge_url = []
        for project_id in project_req_id:
            merge_request_id = project_req_id[project_id]
            accept_url = "http://%s/api/v3/projects/%s/merge_request/%s/merge?private_token=%s" % (domain_name,project_id,merge_request_id,token)
            merge_url.append(accept_url)
        return  merge_url
          
    def protect_branch(self,option):
        """protect pre branch and unprotect pre branch"""

        name_id = self.project_name_id()
        for project_name in name_id:
            project_id = name_id[project_name]
            protect_branch_url = "http://%s/api/v3/projects/%s/repository/branches/%s/%s?private_token=%s" % (domain_name,project_id,branch_name,option,token)  
            accepet_merge_cmd = 'curl -s -X PUT %s' % protect_branch_url #接受请求
            exec_merge_req = subprocess.Popen(accepet_merge_cmd, shell=True, stdout=subprocess.PIPE)
            return_data = exec_merge_req.communicate()
            return_info = json.loads(return_data[0]) #return info
            for k in return_info:
                if k == 'message':
                    print 'project name [%s]' % project_name,return_info['message']
                elif k == 'protected':
                    if return_info['protected'] == True:
                        print '[%s] branch pre protected ok' % project_name
                    elif return_info['protected'] == False:
                        print '[%s] branch pre unprotected ok' % project_name
                else:
                    pass
    
    def exec_merge(self):
        merge_url = self.print_merge_url()
        name_id = self.project_name_id()
        for url in merge_url: 
            accepet_merge_cmd = 'curl -s -X PUT %s' % url #接受请求
            exec_merge_req = subprocess.Popen(accepet_merge_cmd, shell=True, stdout=subprocess.PIPE)
            return_data = exec_merge_req.communicate()
            return_info = json.loads(return_data[0]) #return info
            #print returnInfo
            merge_status = return_info['state']
            project_id_value = return_info['project_id'] #合并请求的工程id
            for project_name in name_id:
                project_id = name_id[project_name]
                for k in return_info:
                    if k == 'message':
                        print return_info['message']
                    elif k == 'state':
                        #如果返回信息中'state' 为 merged提交状态，表示合并成功
                        if project_id == project_id_value and merge_status == 'merged':
                            print '[%s] merged successfull' % project_name

if __name__ == "__main__":
   p = BaseProject()
   #project_url_data = p.project_url_data
   #k=p.project_name_id(project_url_data)
   #print p.name_id
   #print  p.project_url_data
   #print p.project_name_id()
   #print p.get_merge_url()
   #print p.print_merge_url()
   #p.protect_branch('protect')
   #p.exec_merge()
   if len(sys.argv) < 2:
       print 'No action specified,Please use the following actions'
       sys.exit()
   option = sys.argv[1]
   if option == 'merge':
       if not p.print_merge_url():
           print 'No merged branch url'
       else:
           p.exec_merge()
   elif option == 'protect':
       p.protect_branch(option)
   elif option == 'unprotect':
       p.protect_branch(option)
   elif option == 'preview':
       if not p.print_merge_url():
           print 'No merged branch url'
       else:
           name_id = p.project_name_id()
           project_req_id = p.get_merge_url()
           for project_name in name_id:
               project_id = name_id[project_name]
               for id in project_req_id:
                   if project_id == id:
                       print 'merge project name: [%s]' % project_name
   elif option == 'nameid':
        print p.project_name_id
   elif option == 'version':
        print 'version 0.1'
   elif option == 'help':
        print '\033[1;31;40m'
        print '*' * 60
        print '''This program merge request from pre branch to master branch.
        Options include:
              merge : merge request from pre to master
            protect : protect branch pre
          unprotect : unprotect branch pre
            preview : view opend branch
            version : prints the version number             
               help : display this help'''
        print '*' * 60
        print '\033[0m'
   else:
        print '\033[1;32;40m'
        print '*' * 60
        print 'please check parameter or branch merge order'
        print '*' * 60
        print '\033[0m'
