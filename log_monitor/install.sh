#!/bin/bash

#	File Name:    install.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年10月22日 星期一 21时40分13秒


mkdir -p ~/.local/scripts/log_monitor

cp ./log_monitor.sh ~/.local/scripts/log_monitor/ 

chmod u+x ~/.local/scripts/log_monitor/log_monitor.sh

cat <<DT>>  ${HOME}/.config/autostart/log_monitor.desktop
[Desktop Entry]
Name=log_monitor
Exec=${HOME}/.local/scripts/log_monitor/log_monitor.sh
Icon=bash
Terminal=false
Type=Application
Categories=GNOME;GTK;System;Utility
Comment[en_US.UTF-8]=Ssh stalker monitoring
DT

bash ~/.local/scripts/log_monitor/log_monitor.sh &

echo -e "\033[1;32mDone ! logout and login , or reboot.\033[0m"

