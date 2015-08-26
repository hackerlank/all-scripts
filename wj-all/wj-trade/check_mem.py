import psutil
import re
import sys

def processinfo(processName):
                    pids = psutil.get_process_list()
                    for pid in pids:
                        strPid = str(pid)
                        f = re.compile(processName,re.I)
                        if f.search(strPid):
                            zabbixPid = strPid.split('pid=')[1].split(',')[0]  
                            return zabbixPid
                             
zabbixPID = int(processinfo(sys.argv[1]))            
p = psutil.Process(zabbixPID)
a, b = p.memory_info()
print a
