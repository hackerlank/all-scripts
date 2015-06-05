# -*- coding: utf-8 -*-

import urllib
import urllib2
import cookielib
import re
import sys
import datetime
from sgmllib import SGMLParser
import smtplib
import time
import imaplib

def checkData(data):
    if data:
    	for d in data:
      		if d: return True
    else: 
	return False

def delete_mail(email, password):
    limit = 60 #删除多久之前的邮件，单位为天
    sender = "notice" #邮件发送者
    i = 1;
    while (int(i) <= 10):
	print "第%s次连接"%i
        mail = imaplib.IMAP4_SSL('imap.gmail.com')
        r, data = mail.login(email, password)
        i += 1;
        if(r != 'OK'):
                print "Login mail error, try " + i + "time(s)"
        else:
                break
    
    mail.select("INBOX")
    date = (datetime.date.today() - datetime.timedelta(limit)).strftime("%d-%b-%Y")
    result, data = mail.uid('search', None, '(SENTBEFORE {date} FROM {sender})'.format(date=date, sender=sender))

    if checkData(data):
    	for e_uid in data[0].split():
                mail.uid('STORE', e_uid, '+FLAGS', '(\Deleted)')
        print "%s Deleteing emails on %s"%(len(data[0].split()),email)
        mail.expunge()
    mail.close()
    mail.logout()


x = 1
email = sys.argv[1] #Gmail邮箱
password = sys.argv[2] #Gmail密码
to_email = sys.argv[3] #接收邮箱
galx_value = '' #页面标记符
dsh_value = ''  #页面标记符

print email
 
cj=cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
urllib2.install_opener(opener)
headers=[('User-Agent','Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)')]
opener.addheaders=headers;
# Define URLs
loing_page_url = 'https://accounts.google.com/ServiceLogin?service=mail'
authenticate_url = 'https://accounts.google.com/ServiceLoginAuth'
authredirect_url = 'https://accounts.google.com/CheckCookie?chtml=LoginDoneHtml&amp;pstMsg=1'
gv_home_page_url = 'https://mail.google.com/mail/u/0/h/tvqkaufu9e72/?zy=e&f=1'

while (int(x) <= 10):
        print "第%s次连接"%x
        login_page_contents = opener.open(loing_page_url).read()
        galx_match_obj = re.search(r'name="GALX"\s*value="(\w+)"', login_page_contents, re.IGNORECASE)
        if(galx_match_obj == None):
                print "No GALX found!"
        else:
                galx_value = galx_match_obj.group(1) if galx_match_obj.group(1) is not None else ''

        dsh_match_obj = re.search(r'id="dsh" value="(\w+)"', login_page_contents, re.IGNORECASE)
        if(dsh_match_obj == None):
                print "No dsh found!"
        else:
                dsh_value = dsh_match_obj.group(1) if dsh_match_obj.group(1) is not None else ''

        if (galx_value != ''  and dsh_value != ''):
                break
	else:
		x+=1
		time.sleep(3)
 
print galx_value
print dsh_value 
# Set up login credentials
login_params = urllib.urlencode( {
   'Email' : email,
   'Passwd' : password,
   'continue' : 'https://mail.google.com/mail',
   'GALX': galx_value,
   'dsh':dsh_value,
   'service':'dfa',
   'cd':'_PDFA6N',
   'signIn':'Sign in',
   'rmShown':'1',
   'pstMsg':'1'
 
})
 
# Login
opener.open(authenticate_url, login_params)
opener.open(authredirect_url, login_params)
# Open GV home page
gv_home_page_contents = opener.open(gv_home_page_url).read()

mail_useage = re.search(r'<span style[\s\S]*您目前.*MB.*</span>', gv_home_page_contents, re.IGNORECASE).group(0)
mail_percent = re.search(r'\d*%', mail_useage, re.IGNORECASE).group(0)
num_percent = re.search(r'\d*', mail_percent, re.IGNORECASE).group(0)
print "%s 邮箱空间已使用: %s"%(email, mail_percent)

if(int(num_percent) >= 80):
   session = smtplib.SMTP('smtp.gmail.com', 587)
   session.ehlo()
   session.starttls()
   session.login(email, password)
   headers = "\r\n".join(["from: " + email , "subject: [Sev-2] %s 邮箱空间已使用: %s"%(email, mail_percent), "to: " + to_email, "mime-version: 1.0", "content-type: text/html"])
   content = headers + "\r\n\r\n" + email + " 邮箱空间已使用:" + mail_percent
   session.sendmail(email, to_email, content)
   delete_mail(email, password)
