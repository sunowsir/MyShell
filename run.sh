#!/bin/bash
source $HOME/.bashrc

num=0
useshells="bash"
useweb="chromium"
judgeshow=0
tarpath=`pwd`
compath="$HOME/Command"

for arg in $@
do

    parameter[$num]=$arg
    ((num++))

done

for((i=0;i<$num;i++));
do

    case ${parameter[$i]} in

        "-p" | "--path")
            ((i++))
            tarpath=${parameter[$i]}
        ;;
        "-t" | "--time")
            judgeshow=1
        ;;
        "-u" | "--use")
            ((i++))
            useshells=${parameter[$i]}
        ;;
        "-w" | "--web")
            ((i++))
            useweb=${parameter[$i]}
        ;;
        "-help" | "--help")
            echo "Note: This script only works for single file code running a no link process."
            echo "run [-p/--path + ... , -t/--time , -u/--use + ... , -w/--web + ... , -help/--help] <filename>"
            echo "-p / --path :    run the file under the development path."
            echo "-t / --time :    display runtime infomation."
            echo "-w / --web :     when run an HTML code, open it with the specified browser."
            echo "-u / -use :      when run an linux script code, open it with the specified shell script language"
            echo "- help / --help: Git help "
            exit;
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
    $useshells $compath/run.sh -help
    exit;
fi

chmod +x $fname


suffix=`echo $fname | cut -d "." -f2`

case $suffix in

    "c")
        echo "Compiling ... "
        gcc -Wall $fname
        echo "------------------"
        (time ./a.out) 2> $compath/run.info
        echo "------------------"
    ;;
    "cpp")
        echo "Compiling ... "
        g++ -std=c++11 -Wall $fname 
        echo "------------------"
        (time ./a.out) 2> $compath/run.info
        echo "------------------"
    ;;
    "py")
        (time python2.7 $fname) 2> $compath/run.info
        echo "------------------"
    ;;
    "sh")
        (time $useshells  ./$fname) 2> $compath/run.info
    ;;
    "html")
        $useweb $fname
    ;;
    "*")
        echo "暂时无法识别"$suffix"类型文件"
        exit 1
    ;;

esac

lines=`cat $compath/run.info | wc -l`
((lines-=-4))
line=0

cat $compath/run.info | while read oneline
do 

    if [[ "$line" -lt "$lines" ]];then
        echo $oneline
    fi
    ((line++))

done

#处理time信息

if [[ $judgeshow == 1 ]];then
    tail -3 $compath/run.info 
fi

