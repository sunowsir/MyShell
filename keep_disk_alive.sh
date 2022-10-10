#!/bin/bash
#
#	* File     : keep_disk_alive.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : Mon 10 Oct 2022 10:19:34 AM CST

# 磁盘列表
KDA_DISK_ARR=(
    "/dev/sdc1" 
    "/dev/sdd1"
)

# 检查间隔时间
KDA_CHECK_INV=60

function keep_alive_proc() {
    for ((i = 0; i < ${#KDA_DISK_ARR[@]}; i++));
    do
        local now_uuid="$(blkid ${KDA_DISK_ARR[${i}]} | grep -Eo ' UUID="[^"]*' | sed 's/ UUID="//g')"
        if [[ $(df -h | grep "^${KDA_DISK_ARR[${i}]}") ]]; 
        then
            sudo date > "/run/media/${now_uuid}/.keep_disk_alive"
            continue;
        fi
        sudo mkdir -p "/run/media/${now_uuid}"
        sudo mount ${KDA_DISK_ARR[${i}]} "/run/media/${now_uuid}"
        sudo date > "/run/media/${now_uuid}/.keep_disk_alive"
    done
}

function main() {
    while true;
    do
        keep_alive_proc
        
        sleep ${KDA_CHECK_INV}
    done
}

main 
exit $?
