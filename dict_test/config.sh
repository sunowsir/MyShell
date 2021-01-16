#!/bin/bash
#
#	* File     : dict_test.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : 2021年01月15日 星期五 23时57分21秒

# 若您在windows上使用，盘符请修改为例如: /c、/d这样, 
# 路径分隔符请使用如下样式linux分隔符; 

declare -A G_file_pos

# SVN中策划的excel配置表路径
G_server_excel_config_path="./excel"

# SVN中程序使用的csv配置表路径
G_server_svn_csv_config_path="./config"

# 本地程序使用的csv配置表路径
G_server_local_csv_config_path="./local/config"

# 映射每个程序用的csv配置文件在config下的位置
G_file_pos["Monster.csv"]="/Monster"
G_file_pos["wave.csv"]="/new"

# 需要转换的excel配置表
G_excel_file[0]="Monster.in"
G_excel_file[1]="wave.in"


### check config path.

function Check_svn_excel() {
    if [[ ! -d ${G_server_excel_config_path} ]];
    then
        echo "${G_server_excel_config_path} is not assigned."
        exit 1;
    fi
    return "${?}"
}

# todo
