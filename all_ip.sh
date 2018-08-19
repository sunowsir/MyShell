#!/bin/bash

for ip in `seq $1 $2`  ;
do

    ping -c 2 -t 1 192.168.1.$ip > /dev/null 2>&1

    if [[ $? == 0 ]];then
        echo 192.168.1.$ip
    fi

done
