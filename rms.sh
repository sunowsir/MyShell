#!/bin/bash

#功能预期
#１．删除单个文件
#２．删除多个文件
#３．删除匹配名称文件
#４．存储删除文件的路径
#５．恢复文件到原目录

#解析参数

Icom=0
rnum=0
num=0
dustpath=/home/sunowsir/.dustbin/
nowpath=`pwd`
rcom=0
fcom=0

#存储参数到数组中
for arg in $@ 
do

    parameter[$num]=$arg
    ((num++))

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
        "-c")
            cd $dustpath
            rm -rf *
        ;;
        "-n" | "-name")

            ((i++))
            for arg in `ls -a ${parameter[$i]}* | tr ' ' '\n'`
            do

                echo $arg:$nowpath >> rms.info
                mv $arg $dustpath/

            done
            let "i=$i+1" 

        ;;
        #显示已删除文件
        "-s" | "-show")
            cat $HOME/Command/rms.info
        ;;
        #恢复删除的文件到原路径
        "-b" | "-back")

            cd $dustpath
            
            ((i++))
            name=`cat $HOME/Command/rms.info | grep ${parameter[$i]} | cut -d ":" -f1`
            for bname in $name
            do

                backpath=`cat $HOME/Command/rms.info | grep $bname | cut -d ":" -f2`
                mv $dustpath/$bname $backpath/
                sed -i "/$bname/d" $HOME/Command/rms.info 
            
            done 

            cd $nowpath

        ;;
        '*')

            echo "Danger!"
            echo -n  " 是否删除该路径下所有的文件和文件夹(yes/no)?"
            read judge
            if [[ $judge == "yes" ]];then
                
                for $file in `ls`
                do

                    $HOME/Command/rms.sh $nowpath/$file

                done

            fi
            
        ;;
        '/')
            echo "禁止该操作(删除根目录)！"
        ;;
        #删除文件夹选项
        "-r")
            rcom=1
        ;;
        #不询问选项
        "-f")
            fcom=1
        ;;
        #存储单个或多个指定文件
        *)
            rmfile[$rnum]=${parameter[$i]}
        ;;

    esac


done

rms() {

    arg=$1
    fpath=$2


    #询问选项实现
    if [[ $fcom != 1 ]];then 
        echo $fpath:
        echo -n "是否删除"$arg"(yes/no)?"
        read input
        if [[ $input == "no" ]];then
            return
        fi

    fi

    echo $arg:$fpath >> $HOME/Command/rms.info
    mv $arg $dustpath/

}

rmss() {

    path=$1
    arg=$2
    
    judge=`ls -l | grep "$arg" | grep "^d"`

    # dir
    if [[ x$judge != x ]];then

        if [[ $rcom != 1 ]];then
            echo "无法删除：\" $arg \"是一个目录"
        else
            rms $arg $nowpath
        fi
        
    #file
    else
        
        rms $arg $nowpath
        
    fi
}

for arg in ${rmfile[@]}
do

    rmss $nowpath $arg

    search=`ls | grep "$arg"`

    if [[ x$search == x ]];then
        continue
    fi

done
