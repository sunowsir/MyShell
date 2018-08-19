#!/bin/bash

cd $HOME

# 登录
if [[ $1 == 1 ]];then
    
    logininfo="`who | tail -1` login"
    echo `date +"%s"` > ~/logtimes.log
    echo $logininfo >> ~/loginfo.log

# 登出
else

    nowtimes=`date + "%s"` 
    logintime=`cat logtimes.log | tail -1`
    ((logts=$nowtimes-$logintime))
    logoutinfo="`whoami` `cat who | cat -d " " -f2` logout $logts"
    echo $logoutinfo >> ~/loginfo.log
fi
