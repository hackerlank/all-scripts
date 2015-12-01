#!/usr/bin/env python
# coding: utf-8
#用于监控HP服务器的RAID阵列卡使用状态

import os
import sys
import re
import platform

reload(sys)
sys.setdefaultencoding('utf8')

def get_os_type():
    """判断当前操作系统(CYGWIN/Linux)来决定使用哪个命令来执行"""
    os_name = platform.system()

    if re.search('CYGWIN', os_name):
        cmd = "/cygdrive/c/Program\ Files/HP/hpssacli/bin/hpssacli.exe"
        if not os.path.isfile("/cygdrive/c/Program Files/HP/hpssacli/bin/hpssacli.exe"):
            print "WARN:hpssacli not installed!"
            sys.exit(1)
    elif re.search('Windows', os_name):
        cmd = '"C:\\Program Files\\hp\\hpssacli\\bin\\hpssacli.exe"'
        if not os.path.isfile("C:\\Program Files\\hp\\hpssacli\\bin\\hpssacli.exe"):
            print "WARN:hpssacli not installed!"
            sys.exit(1)			
    else:
        cmd = "sudo /usr/sbin/hpacucli"
        if not os.path.isfile("/usr/sbin/hpacucli"):
            print "WARN:hpacucli not installed!"
            sys.exit(1)
    return cmd

def get_slot_infos(cmd):
    """获取阵列卡的槽位"""
    slot_infos = os.popen('%s ctrl all show' % cmd).read()
    if len(slot_infos) == 0:
        print "WARN:no found any controller!"
        sys.exit(1)
    slot = slot_infos.split()[5]
    return slot

def get_ctrl_infos(cmd, slot, raid_info_dict):
    """获取raid阵列卡的控制器、电池、缓存器的状态"""
    ctrl_infos = os.popen('%s ctrl slot=%s  show' % (cmd, slot))
    ctrl_status = ''
    
    for line in ctrl_infos.readlines():
        if re.search(':', line):
            key = line.split(':')[0].strip('\n|\r').strip()
            val = line.split(':')[1].strip('\n|\r').replace(' ','')
            if re.search('Controller Status|Cache Status|Battery/Capacitor Status', key):
                ctrl_status += '%s:%s;' % (key, val)
                raid_info_dict[key] = val
    return ctrl_status

def get_disk_infos(cmd, slot, raid_info_dict):
    """获取raid阵列卡里硬盘使用状态"""
    disk_infos = os.popen('%s ctrl slot=%s pd all show' % (cmd, slot))
    disk_status = 'Disk Stauts:'
    
    for line in disk_infos.readlines():
        if re.search('physicaldrive', line, re.I):
            pos = line.split()[1]
            size = line.split(',')[2]
            status = line.split(',')[3].strip('\n|\r').strip().strip(')')
            disk_status += 'pos:%s,size:%s,status:%s;' % (pos, size, status)
            raid_info_dict['pos:%s,size:%s,status:%s' % (pos,size,status)] = status
    return disk_status

def get_raid_infos(cmd, slot, raid_info_dict):
    """获取raid卡使用状态"""
    raid_infos = os.popen('%s ctrl slot=%s ld all show' % (cmd, slot))
    raid_status = ''
    
    for line in raid_infos.readlines():
        if re.search('logicaldrive',line):
            info = line.strip().strip('\n|\r')
            status = line.strip().strip('\n|\r').split(',')[2].strip().strip(')')
            raid_status += '%s;' % (info)
            raid_info_dict[info] = status
    return raid_status

def main():
    """主程序执行部分"""
   
    raid_info_dict = {}     

    #获取操作系统类型
    cmd = get_os_type()
    #获取阵列卡的槽位
    slot = get_slot_infos(cmd)
    #获取raid阵列卡的控制器、电池、缓存器的状态
    ctrl_status = get_ctrl_infos(cmd, slot, raid_info_dict)
    #获取raid卡里硬盘使用状态
    disk_status = get_disk_infos(cmd, slot, raid_info_dict)
    #获取raid卡使用状态
    raid_status = get_raid_infos(cmd, slot, raid_info_dict)

    #判断raid阵列卡当前状态是否正常
    if raid_info_dict.values().count('OK') != len(raid_info_dict.values()):
       print "WARN:%s%s%s" %(ctrl_status, disk_status, raid_status)
       sys.exit(1)
    else:
       print "OK:%s%s%s" %(ctrl_status, disk_status, raid_status)
       sys.exit(0)
if __name__ == '__main__':
    main()
