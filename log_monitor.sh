#!/bin/bash

if [[ ! -e "logm.info" ]];then
    info=`last -d  | grep "sunowsir" | grep -v "tty" | head -1 | tr -s ' ' ':'` 
    echo $info > /home/sunowsir/Command/logm.info
fi


while true;
do

    newloger=`last -d  | grep "sunowsir" | grep -v "tty" | head -1 | tr -s ' ' ':'`
    lastloger=`cat /home/sunowsir/Command/logm.info | tail -1`
    if [[ $newloger != $lastloger ]];then

        loger=`last -d  | grep "sunowsir" | grep -v "tty" | head -1 | tr -s ' ' ':' | cut -d ':' -f3`
    
        if [[ $loger == "bogon" ]];then
            loger=`last | grep "sunowsir" | grep -v "tty" | head -1 | tr -s ' ' ':' | cut -d ':' -f3`
        fi


        #echo $loger 刚刚登录您的电脑
        notify-send -i gtk-dialog-info "$loger 刚刚登录您的电脑"
        
        info=`last -d  | grep "sunowsir" | grep -v "tty" | head -1 | tr -s ' ' ':'` 
        echo $info > /home/sunowsir/Command/logm.info
    
    fi

done
