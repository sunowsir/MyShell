#!/bin/bash
#
#	* File     : change_main.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : 2021年01月16日 星期六 00时03分48秒

Now_Dir="$(pwd)"

source "${Now_Dir}/config.sh"

# echo ${G_file_pos["wave.out"]}

# for key in ${!G_file_pos[*]}
# do
#     echo "${G_file_pos[${key}]}"
# done

# 将SVN中excel策划配置文件拷贝到当前目录
function copy_excel_to_now_dir() {
    echo "copy excel file to now directory."
    for key in "${!G_excel_file[@]}"
    do
        rm -rf "${Now_Dir}/${G_excel_file[${key}]}"
        cp "${G_server_excel_config_path}/${G_excel_file[${key}]}" "${Now_Dir}"
    done
}

# 将当前目录中所有的excel配表转换为程序用的csv表
function excel2csv() {
    # need command 
    echo "run the change func"
}

# 将转化完成的csv表拷贝到其对应的位置
function copy_csv_to_cfg_dir() {
    echo "copy csv file to svn and local config directory."
    
    for key in ${!G_file_pos[*]}
    do
        echo "${G_file_pos[${key}]}"
        local csv_cfg_file="${Now_Dir}/${key}"
    
        if [[ -f "${csv_cfg_file}" ]];
        then
            cp "${csv_cfg_file}" "${G_server_svn_csv_config_path}/${G_file_pos[${key}]}"
            cp "${csv_cfg_file}" "${G_server_local_csv_config_path}/${G_file_pos[${key}]}"
        fi
    
    done
}

function main() {
    copy_excel_to_now_dir "${@}"
    excel2csv "${@}"
    copy_csv_to_cfg_dir "${@}"
    return "${?}"
}

main "${@}"
exit "${?}"
