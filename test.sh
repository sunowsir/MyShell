#!/bin/bash
#===============================================================
#	File Name:    test.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年09月22日 星期六 10时13分01秒
#===============================================================

url="http://desk.zol.com.cn/bizhi/"

for i in $(seq 100 999)
do

    for j in $(seq 10000 99999)
    do
        for k in $(seq 0 10)
        do
            ./re_pic.sh ${url}${i}_${j}_${k}.html ~/Pictures/test/
        done

    done

done
