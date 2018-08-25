#!/bin/bash


while read -r word
do

    for usrs in `w -h | cut -d " " -f2`
    do
    
        usrn=`w -h | grep $usrs | cut -d " " -f1`
    
        echo "who am i" >> /dev/$usrs
        echo $word | write $usrn $usrs
    
    done

done
