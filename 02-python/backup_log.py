#!/usr/local/python27/bin/python
# coding:utf-8
# datetime: 2016-02-29
# author: chengxiaochao
# use: backup java log by day

from __future__ import division
import os
import sys
import time
import datetime
import re
import subprocess
import logging
import pymysql

################### variable ##############################
now=time.strftime('%Y%m%d')
year_month=time.strftime('%Y-%m')
backup_path='/data/backup/ordercenter'
iplist_path='/data/scripts/project_list'
passwd='/etc/rsyncd.secrets'
username='rsyncuser'
log='/data/logs/backup/log_stats/backup_stats_%s.csv' % (now)
yes_time=str(datetime.date.today() + datetime.timedelta(days=-1)).replace('-','')
# log 
logging.basicConfig(level=logging.DEBUG,
    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
    datefmt='[%a, %d %b] %Y %H:%M:%S',
    filename='/data/logs/compress_ip.log',
    filemode='w')               

def dir_exists(path):
    '''判断一个目录是否存在,不存在就创建'''
    #去除首尾空格
    path=path.strip()
    #去除尾部\符号
    path=path.rstrip("\\")
    #判断路径是否存在，存在是True,不存在Flase
    is_exists=os.path.exists(path)
    if not is_exists:
        os.makedirs(path)
        print "%s 目录创建成功" % path
        return True
    else:
        print "%s 目录已存在" % path
        return False
     

def compress_log(path):
    ''' auto compress log
     # print '*' * 100
     # print fpath #所有目录,一级目录，二级目录，三级目录路径列表
     # print '-' * 100
     # print dirs #会列出所有的目录列表，非路径列表
     # print '#' * 100
     #print fs   # list all file
    '''
    for fpath,dirs,fs in os.walk(path):
      for file in fs:
          if os.path.splitext(file)[1] == '.log':
              #print f
              #print os.path.join(fpath,f)
              path_file=os.path.join(fpath,file)
              cmd='/bin/gzip -f %s' % path_file
              compress_result = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
              out = compress_result.communicate()
              out_val = compress_result.wait()
              if out_val == 0:
                  #print "%s gzip compress successful!" % path_file
                  logging.info('%s gzip compress successful!',path_file)
          else:
              #pass
              logging.info('%s no compress file',fpath)

def module_names(module_name,iplist):
    module_name=[]
    with open('%s/%s' % (iplist_path,iplist),'r') as f:
        for rip in f.readlines():
            print rip.strip()
            module_name.append(rip.strip())
    return module_name

def write_title(log_stat):
    ''' record transferred result log'''
    file_log=open(log_stat,'a')
    file_log.write('start_time,end_time,rip,module,Number of files,Number of files transferred,Total file size(bytes),Total transferred file size(bytes)\n')
    file_log.close()

def write_notes(module_name,iplist,log_stat=log,port=873):
    db_conn=pymysql.connect(host='10.104.33.219',user='synclog',passwd='synclog!@#',db='backup_log')
    db_curs=db_conn.cursor()
    fle=open(log_stat,'a')
    for rip in iplist:
        dir_exists('%s/%s/%s'%(backup_path,year_month,rip))
        cmd='/usr/bin/rsync -trp --exclude=order_debug*.log --stats --port=%s --password-file=%s %s@%s::%s/order_*.%s.log %s/%s/%s/' \
% (port,passwd,username,rip,module_name,yes_time,backup_path,year_month,rip)
        try:
            s_time=time.strftime('%H:%M:%S')
            cmd_put=os.popen(cmd)
            #print cmd_put
            list_tmp=[]
            #正则匹配rsync同步输出结果
            re_p=re.compile('(Number of files:|Number of files transferred:|Total file size:|Total transferred file size:) (\d+)?')
            for each_line1 in cmd_put: #遍历rsync同步结果
                for each_line2 in re_p.finditer(each_line1): #正则查找匹配的行
            ##        print each_line2.group()
                    if each_line2 is not None: #如果不为None 放入列表中
                        val = each_line2.group(2)
                        #list_tmp.append(each_line2.group(2))
                        list_tmp.append(val)
                    else:
                        pass
            e_time=time.strftime('%H:%M:%S')
            cmd_stat='%s,%s,%s,%s,%s,%s,%s,%s,%s' % (s_time,e_time,rip,module_name,list_tmp[0],list_tmp[1],list_tmp[2],list_tmp[3],os.linesep)
            cmd_put.close()
            fle.write(cmd_stat)
            #t_size=(int(list_tmp[2])//1024)/1024
            #total_size='%.2f' % t_size
            #trans_size=(int(list_tmp[3])/1024)/1024
            #filesize_traned='%.2f' % trans_size
            #print total_size+'m',filesize_traned
            compress_log(backup_path)
            db_curs.execute("INSERT INTO bak_stat \
            (ipaddr,mod_name,date_ymd,s_time,e_time,files,files_traned,filesize,filesize_traned,a_error) \
            VALUES('%s','%s','%s','%s','%s','%s','%s','%s','%s','')" \
            % (rip,module_name,now,s_time,e_time,list_tmp[0],list_tmp[1],list_tmp[2],list_tmp[3]) )
            db_conn.commit()
        except Exception as e:
            #print e
            #error=e
            #with open('error.txt','w') as fo:
            #     fo.writer(e)
            #     fo.close()
            cmd_stat='%s,%s,%s,%s,%s,%s,%s,%s' % (s_time,e_time,rip,module_name,'error','error','error','error'+os.linesep)
            fle.write(cmd_stat)
            db_curs.execute("INSERT INTO bak_stat (ipaddr,mod_name,date_ymd,s_time,e_time,mod_name,a_error) \
            VALUES('%s','%s','%s','%s','%s','error')" % (rip,module_name,now,s_time,e_time) )
    #db_conn.commit()
    db_curs.close()
    db_conn.close()
    fle.close()

if __name__ == "__main__":

    if len(sys.argv) < 3:
        print '''No action specified,Please use the following actions
        python scirpt_name [moduble name] [module iplist] example:
             module iplist path :/data/scripts/project_list
             backup scripts path :/data/scripts
             python backup_log.py ordercenter ordercenter_iplist
             python backup_log.py orderfollowup orderfollowup_iplist'''
        sys.exit()
    write_title(log)
    iplist=module_names(sys.argv[1],sys.argv[2])
    write_notes(sys.argv[1],iplist)
