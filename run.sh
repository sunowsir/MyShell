#!/bin/bash

num=0
judgeshow=0
tarpath=`pwd`
compath=/home/sunowsir/Command

for arg in $@
do

    parameter[$num]=$arg
    ((num=$num+1))

done

for((i=0;i<$num;i++));
do

    case ${parameter[$i]} in

        "-p" | "-path")
            tarpath=${parameter[`expr "$i+1"`]}
            ((i=$i+1))
        ;;
        "-t" | "-time")
            judgeshow=1
        ;;
        *)
            fname=${parameter[$i]}
        ;;

    esac

done

if [[ $num == 0 ]];then
    exit;
fi

cd $tarpath

search=`ls -al | grep "$fname"`

if [[ "x"$search == "x" ]];then
    echo $fname"文件不存在"
    exit;
fi

chmod +x $fname


suffix=`echo $fname | cut -d "." -f2`

case $suffix in

    "c")
        echo "Compiling ... "
        gcc $fname
        echo "------------------"
        (time ./a.out) 2> $compath/run.info
    ;;
    "cpp")
        echo "Compiling ... "
        g++ -std=c++11 $fname 
        echo "------------------"
        (time ./a.out) 2> $compath/run.info

    ;;
    "py")
        (time python2.7 $fname) 2> $compath/run.info
    ;;
    "sh")
        (time ./$fname) 2> $compath/run.info
    ;;
    "html")
        chromium $fname
    ;;
    "*")
        echo "对不起!\n暂时无法识别"$suffix"类型文件\n"
    ;;

esac

echo "------------------"

lines=`cat $compath/run.info | wc -l`
((lines=$lines-4))
line=0

cat $compath/run.info | while read oneline
do 

    if [[ "$line" -lt "$lines" ]];then
        echo $oneline
    fi
    ((line=$line+1))

done

#处理time信息

if [[ $judgeshow == 1 ]];then
    tail -3 $compath/run.info 
fi

