# MyShell
> Some small scripts

* Contains some useful small scripts written during the learning process.

### CPU_info.sh
* 采集**CPU**信息
### Disk_info.sh
* 采集磁盘信息
### Linear_sieve.sh
* 用`bash`脚本实现素数线性筛
### Malicious_ps_info.sh
* 采集恶意进程
* 本脚本对恶意进程的定义：`CPU`或内存占用超过**50%**５秒以上
### Mem_info.sh
* 采集内存信息
### Sys_info.sh
* 采集系统信息
### User_info.sh
* 采集登陆者信息
### all_ip.sh
* 采集局域网内已被占用的内网ip
### file_open.sh
* 根据文件不同后缀用不同应用打开文件
### files.h
* 根据指定后缀，指定路径等输出相应路径下的文件信息
### isprime.sh
* 判断一个数是否为素数
### log_monitor.sh
* 有人用ssh登录本机或退出登录会有弹窗提示，通知采用桌面弹出式通知的系统API
* 用法：
  * cd $HOME
  * mkdir Command
  * 把该脚本拷贝到Command目录下
  * 在`.bashrc` 中添加:`bash $HOME/Command/log_monitor.sh login` 
  * 在`.bash_logout`中添加`bash $HOME/Command/log_monitor.sh logout`
  * 其他shell请查询man手册找到对应的用户退出登录加载文件
  * 按照个人情况酌情更改脚本
### re_pic.sh
* 利用正则表达式爬取指定URL的图片到指定路径
### rms.sh
* 简单实现安全`rm`
### run.sh
* 单文件代码编译运行脚本。
### wall.sh
* 给其他登录用户发送消息

