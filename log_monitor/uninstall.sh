#!/bin/bash

#	File Name:    uninstall.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年10月22日 星期一 21时44分23秒


rm -rf ~/.local/scripts/log_monitor/
ps -aux | grep ./log_monitor.sh | cut -d ' ' -f2 | xargs -I {} kill -9 {} > /dev/null 2>&1
echo -e "\033[1;32mBye. \033[0m"
