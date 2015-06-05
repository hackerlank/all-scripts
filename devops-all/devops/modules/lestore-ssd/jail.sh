#!/bin/bash  
#set +x  
#  
# jail -> shell script for sending mime email enclosures from command line  
#  
# Usage : jail [options] email-address file-to-be-sent  
#                             $1              $2  
#  
# John Roebuck - 11/08/97  
#  
# John Roebuck - 29/01/98 - Add options to allow optional subject and urgent.  
# John Roebuck - 18/03/98 - Get Hostname of machine and user.  
# John Roebuck - 26/05/98 - Allow multiple files to be sent.  
# John Roebuck - 11/12/98 - Remove all MTMS options and requirements,  
#                           also added -v for verbose (debug) sendmail option.  
# John Roebuck - 17/12/98 - Added -b option of uuencoding binary files.  
# John Roebuck - 22/12/98 - Added -r option of delivery receipt required.  
# yum install sharutils
  
version="jail 1.4 by John Roebuck 17/12/98"  
  
#  
# Get command line options  
#  
bflag=0  
rflag=0  
sflag=0  
uflag=0  
vflag=0  
  
while getopts "brs:uv" arg  
do  
    case $arg in  
    b)     bflag=1;;  
    r)     rflag=1;;  
    s)     sflag=1  
           sval="$OPTARG";;  
    u)     uflag=1;;  
    v)     vflag=1;;  
#  
# Display syntax if ? passed as an option in the command line  
#  
    ?)     echo " "  
           echo "Usage : jail [options] email-address files-to-be-set"  
           echo " "  
           echo "        options are  -b for binary files"  
           echo "                     -r delivery receipt required"  
           echo "                     -s (subject of mail message)"  
           echo "                     -u Urgent"  
           echo "                     -v Verbose sendmail (debug)"  
           echo "        ("$version")"  
           echo " "  
               exit 2;;  
        esac  
done  
  
#  
# Set urgent flag to 1 if urgent option is found  
#  
if [ $uflag = 1 ]; then urgent="urgent"  
           else urgent="normal"  
fi  
  
#  
# Include subject from command line if subject option is found  
#  
if [ $sflag = 1 ]; then subject=$sval  
                   else subject=" "  
fi  
  
shift $(($OPTIND -1))  
  
#  
# Display syntax if less than 2 command line parameters are found  
# after the command line options. Require email address and 1 file  
# as a minimum.  
#  
if [ $# -lt 2 ]  
   then echo " "  
    echo "Usage : jail [options] email-address files-to-be-sent"  
    echo " "  
    echo "        options are  -b for binary files"  
        echo "                     -r delivery receipt required"  
    echo "                     -s (subject of mail message)"  
    echo "                     -u Urgent"  
    echo "                     -v Verbose sendmail (debug)"  
    echo "        ("$version")"  
    echo " "  
        exit  
fi  
  
#  
# set -f stops * being expanded within the shell script. (ksh option)  
#  
set -f      
  
#  
# Now get the send to email address  
#  
sendto=$1  
shift  
  
#  
# Find out how many files to send as enclosures in this email message  
#  
attno=$#  
if [ $attno = 1 ]; then attmess="enclosure"  
                   else attmess="enclosures"  
fi  
  
#  
# Format the variable $now as "Friday 18 December 1998 16:22"  
#  
xday=`date +%a`  
xdayno=`date +%d`  
xmonth=`date +%b`  
xyear=`date +%Y`  
xtime=`date +%H:%M:%S`  
now=$xday", "$xdayno" "$xmonth" "$xyear" "$xtime  
  
#  
# Create message boundary number based on process id  
#  
boundary=JPR$$  
  
#  
# Create message id number based on date and process id  
#  
messid=`date +%d%m%y`$$  
  
#  
# Create temporary file based on date time and process id  
#  
tempfile=/tmp/jail-`date +%d%m%y%H%M%S`$$  
touch $tempfile  
  
#  
# Get sender details eg user name and description, machine hostname  
#  
# sender login is the login name of the current user account  
#  
senderlogin=`whoami`  
#  
# Domain is taken from the domain field in /etc/resolv.conf file  
#  
senderdomain=`grep domain /etc/resolv.conf | cut -f2`  
#  
# Sender address is login name @ machine hostname . domain  
#  
senderaddress=$senderlogin"@"`hostname`"."$senderdomain  
#  
# Sender name is taken from the login name description field in /etc/passwd  
#  
sendername=`grep $senderlogin /etc/passwd |cut -d: -f5`  
  
#  
# Create header part of email file  
#  
  
echo "From: /""$sendername"/" <"$senderaddress">" >> $tempfile  
echo "To: "$sendto >> $tempfile  
echo "Date: "$now >> $tempfile  
echo "Mime-Version: 1.0 "$version >> $tempfile  
echo "Content-Type: Multipart/Mixed; boundary=Message-Boundary-"$boundary >> $tempfile  
echo "Subject: "$subject>> $tempfile  
  
#  
# Is a delivery receipt required ?  
#  
if [ $rflag = 1 ]; then  
echo "Return-Receipt-To: /""$sendername"/" <"$senderaddress">" >> $tempfile  
fi  
  
echo "Priority: "$urgent >> $tempfile  
echo "Message-Id: <"$messid"."$senderdomain >> $tempfile  
echo "Status: RO" >> $tempfile  
echo "" >> $tempfile  
echo "" >> $tempfile  
echo "--Message-Boundary-"$boundary >> $tempfile  
echo "Content-type: text/plain; charset=US-ASCII" >> $tempfile  
echo "Content-transfer-encoding: 7BIT" >> $tempfile  
echo "Content-description: Read Me First" >> $tempfile  
echo "" >> $tempfile  
echo "" >> $tempfile  
  
#  
# Create mail message body part of email file  
#  
  
echo "Hello" >> $tempfile  
echo "" >> $tempfile  
echo "Please find "$attno" '"$attmess"' to this email message :- " >> $tempfile  
echo "" >> $tempfile  
  
#  
# Generate file information for each enclosure. The information is in the  
# format : File name 1  aix.doc  
#          Produced on  16 Dec at 18:59  
#          File size    33469 bytes.  
#  
messno=0  
while [ $attno -gt $messno ]  
do  
  
  messno=`expr $messno + 1`  
  filename[$messno]=$1  
  shift  
  
  report1="File name "$messno"  "${filename[$messno]}  
  report2=`ls -l "${filename[$messno]}" |awk '{print "" "Produced on  "$6 " "  $7 " at "  $8 "" }'`  
  report3=`ls -l "${filename[$messno]}" |awk '{print "" "File size    "$5" bytes." "" }'`  
  
  echo "$report1" >> $tempfile  
  echo "$report2" >> $tempfile  
  echo "$report3" >> $tempfile  
  
  echo "" >> $tempfile  
  
done  
  
echo "" >> $tempfile  
echo "" >> $tempfile  
echo "Regards "$sendername" ("$senderaddress")" >> $tempfile  
echo "" >> $tempfile  
  
#  
# For each file, create enclosure for the file.  
#  
messno=0  
while [ $attno -gt $messno ]  
do  
  
messno=`expr $messno + 1`  
  
#  
# Check from command line if files are ascii or binary  
#  
if [ $bflag = 0 ]; then  
  
#  
# Add extra chr$ to ascii files for unix to dos conversion. This  
# means reading in each line of the text file and writing it out to  
# the temp file with a charage return character added to the end of  
# each line.  
# Unforntunately ksh read will ignore leading spaces at the beginning  
# of each line.  
#  
echo "--Message-Boundary-"$boundary >> $tempfile  
echo "Content-type: Application/Octet-Stream; name=${filename[$messno]}; type=Text" >> $tempfile  
echo "Content-description: attachment; filename=${filename[$messno]}" >> $tempfile  
echo "" >> $tempfile  
  
{  
while read line_data  
do  
  echo "$line_data""  
" >> $tempfile  
done } < ${filename[$messno]}  
  
else  
  
#  
# uuencode binary mail  
#  
echo "--Message-Boundary-"$boundary >> $tempfile  
echo "Content-type: Application/Octet-stream; name=${filename[$messno]}; type=Binary" >> $tempfile  
echo "Content-disposition: attachment; filename=${filename[$messno]}" >> $tempfile  
echo "Content-transfer-encoding: X-UUencode" >> $tempfile  
echo "" >> $tempfile  
  
uuencode ${filename[$messno]} ${filename[$messno]} >> $tempfile  
  
fi  
done  
  
#  
#  Send email message straight to sendmail. Use -v option if debug  
#  option has been set at the command line.  
#  
if [ $vflag = 1 ]; then /usr/lib/sendmail -v $sendto < $tempfile  
                   else /usr/lib/sendmail $sendto < $tempfile  
fi  
  
#  
# Remove temp file  
#  
rm $tempfile  
