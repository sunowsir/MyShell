#!/bin/bash

# logfile="/run/log_monitor.d/log_monitor.info"
path="$(dirname $0)"
cd ${path}
logfile="${path}/log_monitor.info"
touch ${logfile}

# TEST START
# echo "path : ${path}"
# TEST END

echo "$(who | tr -s ' ')" > ${logfile}


while true;
do
    
    now_info="$(who | tr -s ' ')"
    if [[ "${now_info}" == "$(cat ${logfile})" ]];then
        sleep 1
        continue
    fi
    
    # 判断是否有人下线
    logout_info="$(grep -vn "${now_info}" ${logfile})"
    line=$(echo "${logout_info}" | cut -d ':' -f 1)
    temp=$(echo "${logout_info}" | cut -d ':' -f 3)
    if [[ "x${temp}" != "x" ]];then
        temp=":${temp}"
    fi
    logout_info="$(echo "${logout_info}" | cut -d ':' -f 2)${temp}"
    if [[ "x${logout_info}" != "x" ]];then
        notify-send -i gtk-dialog-info "${logout_info}" "status : logout \!"
        echo "$(cat ${logfile} | sed "${line}d")" > ${logfile}
    fi

    # 判断是否有人上线
    info_file="$(cat ${logfile})"
    login_info="$(echo "${now_info}" | grep -v "${info_file}")"
    if [[ "x${login_info}" != "x" ]];then
        notify-send -i gtk-dialog-info "${login_info}" "status : login \!"
        echo "${login_info}" >> ${logfile}
    fi
    
    # TEST START
    # echo "now_info : "
    # echo "${now_info}"
    # echo -e "login_info : \033[1;31m${login_info}\033[0m"
    # echo -e "logout_info : \033[1;31m${logout_info}\033[0m"
    # echo 
    # TEST END

    sleep 1

done

