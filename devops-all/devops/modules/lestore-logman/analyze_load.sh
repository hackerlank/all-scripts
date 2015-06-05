#!/bin/bash

if [[ -z $1 ]]
then
   	 date1=`date +%Y%m%d --date='1 days ago'`
else
   	 date1=$1
fi

projects=("JS JE DF AM MJS MJE PH VB MULTI")

#####################################################################################################

log_root=/opt/data1/monitor_log
cd ${log_root}
Message=".content.tmp"
>$Message

##################################################################################################### 邮件正文内容

echo "To: bcheng@i9i8.com,hwang@i9i8.com                                                 " >> $Message
echo "Content-type: text/html                                                           " >> $Message
echo "Subject: [R_R] Load Availability Daily Report $date1                              " >> $Message
echo "<title>Report</title>                                                             " >> $Message
echo "</head>                                                                           " >> $Message
echo "<body>                                                                            " >> $Message
echo "<table border="1" cellspacing="0" cellpadding="0">                                " >> $Message
echo "  <tr style="text-align:center">                                                  " >> $Message
echo "    <td width="90">Project</td>                                                   " >> $Message
echo "    <td width="140">Peak</td>                                                     " >> $Message
echo "    <td width="110">Sev-2</td>                                                    " >> $Message
echo "  </tr>                                                                           " >> $Message
for project in ${projects[@]}
do
    cd $log_root
    logfiles=`find . -ipath "./${project}-*" -and -name "check_uptime.${date1}.log" -print | tr $'\n' ' '`
    echo "$logfiles"
    sort -m -t " " -T /tmp -k 4 -o ${log_root}/${project}-all-${date1}.log $logfiles
    sev2=0
    peak=`awk -F',' '{print $1, $4}' ${log_root}/${project}-all-${date1}.log |awk  '{print $NF,"("$1")"}'|sort -nr |head -1`
    #sev2=`awk -F':' '{print $5}' ${log_root}/${project}-all-${date1}.log |awk -F',' '{if($1>=8) print $1}'|wc -l`
    sev2=`grep 'send Sev-2 mail' ${log_root}/${project}-all-${date1}.log |wc -l`
    echo "<tr style="text-align:center">                                                " >> $Message
    echo "  <td>${project}</td>                                                         " >> $Message
    echo "  <td>${peak}</td>                                                            " >> $Message
    echo "  <td>${sev2}</td>                                                            " >> $Message
    echo "</tr>                                                                         " >> $Message
done
echo "</table>                                                                          " >> $Message
echo "<br>                                                                              " >> $Message
echo "</body>                                                                           " >> $Message

#####################################################################################################

/usr/sbin/sendmail -f noreply@leqee.com -F noreply -t < $Message
rm -f $Message
