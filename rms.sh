#!/bin/bash

#功能预期
#１．删除单个文件
#２．删除多个文件
#３．删除匹配名称文件
#４．存储删除文件的路径
#５．恢复文件到原目录

#解析参数

num=0
dustpath=/home/sunowsir/.dustbin/
nowpath=`pwd`

#存储参数到数组中
for arg in $@ 
do

    parameter[num]=$arg
    let "num=$num+1"

done

#如果无参数直接退出脚本
if [[ $num == "0"  ]]; then
    exit;
fi

#解析参数
for((i=0;i<$num;i++)) 
do

    case ${parameter[$i]} in

        #删除匹配指定名称的文件
        "-n" | "-name")

            for arg in `ls -a ${parameter[$((i+1))]}* | tr ' ' '\n'`
            do

                echo $arg:$nowpath >> rms.info
                mv $arg $dustpath/

            done
            let "i=$i+1" 

        ;;
        #恢复删除的文件到原路径
        "-b" | "-back")

            cd $dustpath
            
            name=`cat /home/sunowsir/Command/rms.info | grep ${parameter[$((i+1))]} | cut -d ":" -f1`
            backpath=`cat /home/sunowsir/Command/rms.info | grep ${parameter[$((i+1))]} | cut -d ":" -f2`
            mv $dustpath/${parameter[$((i+1))]} $backpath/
            sed -i "/$name/d" /home/sunowsir/Command/rms.info 
            let "i=$i+1"

            cd $nowpath

        ;;
        #删除单个或多个指定文件
        *)

            echo $arg:$nowpath >> rms.info
            mv $arg $dustpath/

        ;;

    esac


done
