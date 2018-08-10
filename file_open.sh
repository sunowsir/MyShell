#!/bin/bash

num=0
tarpath=`pwd`

#parsing parameter
for arg in $@
do
    parameter[$num]=$arg
    ((num=$num+1))

done

#read parameter
for((i=0;i<$num;i++));
do

    case ${parameter[$i]} in
        "-p" | "-path")
            tarpath=${parameter[`expr "$i+1"`]}
            ((i=$i+1))
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

if [[ "x"$search == "x"  ]];then
    touch $fname
    chmod 700 $fname
fi

suffix=`echo $fname | cut -d "." -f2`

case $suffix in

    "md")
        echo "正在打开"$fname
        typora $fname > /dev/null 2>&1 &
    ;;
    "txt")
        echo "正在打开"$fname
        gedit $fname 2> /dev/null 2>&1 &
    ;;
    "docx")
        echo "正在打开"$fname
        /usr/bin/wps $fname > /dev/null 2>&1 &
    ;;
    "ppt")
        echo "正在打开"$fname
        /usr/bin/wpp $fname > /dev/null 2>&1 &
    ;;
    "xls")
        echo "正在打开"$fname
        /usr/bin/et $fname > /dev/null 2>&1 &
    ;;
    "pdf")
        echo "正在打开"$fname
        /opt/Foxitreader/FoxitReader.sh $fname > /dev/null 2>&1 &
    ;;
    *)
        echo "对不起！其他类型文件：" $suffix "将默认采用gedit打开"
        echo "将采用gedit打开"
        sleep 1
        gedit $fname > /dev/null 2>&1 &
    ;;

esac

