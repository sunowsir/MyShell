#!/bin/bash

while true;
do
    
    read i

    flag=1

    for((j=2;j*j<=$i;j++));
    do

        if [[ `expr $i % $j` == 0 ]];then
            flag=0
            echo "no"
            break;
        fi

    done

    if [[ $flag == 1 ]];then
        echo "yes"
    fi

done


