#!/usr/bin/env python
# coding=utf-8

import sys
import time
import smtplib
from email.header import Header
from email.mime.text import MIMEText

print "Please wait..."

mail_host = 'smtp.xxx.com' # smtp 服务器
mail_user = 'xxx@xxx.com' # 发送者邮箱
mail_pass = 'xxx'# 发送者邮箱密码

if len(sys.argv) > 1 :
    
    if sys.argv[1] == "" : 
        sys.argv[1] = "Unidentified person"

    mail_word = sys.argv[1]
    mail_word = """
    有人登录您的电脑，具体信息如下：
    登录人员："""
    mail_word = mail_word + sys.argv[1]
    mail_word = mail_word + """
    登录者IP："""
    mail_word = mail_word + sys.argv[2]
    mail_word = mail_word + """
    登陆用户："""
    mail_word = mail_word + sys.argv[3]
    mail_word = mail_word + """
    登录终端："""
    mail_word = mail_word + sys.argv[4]
    mail_word = mail_word + """
    登录时间："""
    mail_word = mail_word + sys.argv[5]

else :
    mail_word = 'Error send ! Please check the script !'

sender = 'xxx@xxx.com' # 发送者邮箱
receiver = 'xxx@xxx.com' # 接收者邮箱

# mail_word：邮件内容
message = MIMEText(mail_word, 'plain', 'utf-8')
message['From'] = Header("xxx<xxx@xxx.com>", 'utf-8') # 邮件中From那一栏
message['To'] = Header("xxx@xxx.com", 'utf-8') # 邮件中To那一栏

subject = 'SSH Log Information.' # 邮件主题
message['Subject'] = Header(subject, 'utf-8')

try:
    
    smtpObj = smtplib.SMTP()
    smtpObj.connect(mail_host, 25) # 25：smtp 服务器端口
    smtpObj.login(mail_user, mail_pass)
    smtpObj.sendmail(sender, receiver, message.as_string())
    print ""

except smtplib.SMTPException:
    print ""
