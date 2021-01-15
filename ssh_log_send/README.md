# ssh登录时发送登录者信息邮件给指定邮箱

> 本脚本参考了网络上的一些博客

* 根据自身情况自行修改脚本
* (管理员权限)把`sshrc`和`sendmail_test.py`两个文件放到`/etc/ssh/`下
* (管理员权限)使用`chmod 755 sshrc sendmail_test.py`命令给两个文件赋予权限
* 发送邮件需要`smtp`服务器，具体请自行搜索
