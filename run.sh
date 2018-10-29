#!/bin/bash
#===============================================================
#	File Name:    run.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年10月08日 星期一 19时45分26秒
#===============================================================

if [[ $# -eq 0 ]];
then
    exit 0
fi

if [[ ! -e ./.StdERROR.info.run ]];
then
    touch ./.StdERROR.info.run
fi

per_nums=0
run_file="a.out"
out_time_info=0

for arg in $@
do
    ((per_nums++))
    
    if [[ ${arg} == "-t" || ${arg} == "--time" ]];
    then
        out_time_info=1
        continue
    fi

    if [[ ${arg} == "-o" ]];
    then
        ((per_nums++))
        run_file=${arg}
        continue
    fi

    # Get file name of need run code.
    if [[ ${per_nums} -eq $# ]];
    then
        need_code_file=${arg}
        break;
    fi

    other_per="${other_per} ${arg}"
done

# Get suffix of need run code file name.
ncf_suffix=$(echo "${need_code_file}" | awk -F '.' '{
    printf("%s", $(NR + 1));
}')

# Add file path .
if [[ $(echo "${need_code_file}" | cut -d '/' -f1) == $(echo "${need_code_file}" | cut -d '/' -f2 )  ]];
then
    need_code_file="./${need_code_file}"
fi

if [[ "x${other_per}" == "x" && ${ncf_suffix} == "c" ]];
then
    other_per="-std=c11 -g -Wall "
elif [[ "x${other_per}" == "x" && ${ncf_suffix} == "cpp" ]];
then
    other_per="-std=c++11 -g -Wall "
fi

case ${ncf_suffix} in
    "c")
        comp_comd="gcc ${other_per} ${need_code_file}"
        run_comd="./${run_file}"
    ;;
    "cpp")
        comp_comd="g++ ${other_per} ${need_code_file}"
        run_comd="./${run_file}"
    ;;
    "py")
        run_comd="python3 ${other_per} ${need_code_file}"
    ;;
    "sh")
        run_comd="bash ${other_per} ${need_code_file}"
    ;;
    *)
        echo -e "\033[1;31mSorry, this language \"${ncf_suffix}\" is not supported.\033[0m"
        exit 1
    ;;
esac

if [[ "x${comp_comd}" != "x" ]];
then
    echo -e "\033[1;32m\[Compiling.\]\033[0m"
    comp_comd="${comp_comd} 2> ./.StdERROR.info.run"
    eval ${comp_comd}
    chmod +x ${run_file}
fi

eval "grep -v '^$' ./.StdERROR.info.run"
echo "---------"

if [[ ${out_time_info} == 1 ]];
then
    run_comd="time ${run_comd}"
fi

run_comd="(${run_comd}) 2> ./.StdERROR.info.run"
eval ${run_comd}

echo "---------"

stderror=$(grep -v '^$' ./.StdERROR.info.run)
echo -e "\e[1;31${stderror}m\3[0m"

rm -rf ./.StdERROR.info.run
