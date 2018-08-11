#!/bin/bash

#功能预期：
#1.统计当前目录或者指定路径下的指定后缀的文件的个数:完成
#2.匹配指定名称:完成
#3.查找当前或指定路径下的文件中最长行和最大的文件

target_path=`pwd`

num=0
search_dir="no"

# storage parameters
for arg in $@ 
do
    parameter[num]=$arg
    let "num=num+1"
done

if [[ $num == "0"  ]];then
    exit;
fi

# parsing parameters
for((i=0;i<num;i++));
do
    case ${parameter[i]} in
        "-p" | "-path")
            target_path=${parameter[$((i+1))]}
            let "i=i+1"
        ;;
        "-n" | "-name")
            search_name=${parameter[$((i+1))]}
            let "i=i+1"
        ;;
        "-d" | "-dir")
            search_dir="yes"
        ;;
        *)
            search_suffix=${parameter[i]}
        ;;
    esac
done


#achieve function


cd $target_path

echo
echo "当前处于 "$target_path" 路径下:"
echo 

#count of number of dir
if [[ $search_dir == "yes" ]];then

    dir_num=`ls -al 2> /dev/null | grep "^d" | wc -l`
    if [[ $dir_num == "0"  ]];then
        echo "当前路径下下无文件夹"
        echo
    else
        echo "当前路径下有"$dir_num "个文件夹(包括\".\"和\"..\")"
        echo
        echo "--------------------------------->"
        ls -al 2> /dev/null | grep "^d"
        echo "<---------------------------------"
        echo
    fi
fi

#count of number of files matching string
if [[ "x"$search_name != "x" ]];then
    
    cd $target_path
    file_num=`ls -al $search_name* 2> /dev/null | wc -l`
    if [[ $file_num == "0"  ]];then
        echo "当前路径下无文件名称开头为 \"" $search_name "\" 的文件/文件夹"
        echo
    else
        echo "当前路径下有"$file_num "个名称开头为 \""$search_name"\" 的文件/文件夹"
        echo
        echo "--------------------------------->"
        ls -al $search_name* 2> /dev/null 
        echo "<---------------------------------"
        echo
    fi
fi

#count of number of specified suffix files 
if [[ "x"$search_suffix != "x"  ]];then
    
    suffix=`echo $search_suffix | cut -d "." -f2`
    su_file_num=`ls -al *.$search_suffix 2> /dev/null | wc -l`
    if [[ $su_file_num == "0"  ]];then
        echo "当前路径下无后缀为 \"."$search_suffix"\" 的文件"
        echo
    else
        echo "当前路径下有"$su_file_num "个后缀为 \"."$search_suffix"\" 的文件"
        echo
        echo "--------------------------------->"
        ls -al *.$search_suffix 2> /dev/null
        echo "<---------------------------------"
        echo
    fi
fi

