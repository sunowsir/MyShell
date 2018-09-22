#!/bin/bash

#newloger=$(w | tail -1 | awk -v logtime=$(date +":%S") '{printf("%s|%s%s", $3, $4, logtime);}')
newloger=$(last | head -1 | awk -v num=$(who | wc -l) '{printf("%s|%s|%s", $3, $7, num);}')
lastloger=`cat $HOME/Command/logm.info | tail -1`

if [[ ! -e "$HOME/Command/logm.info" ]];then
    echo ${newloger} > $HOME/Command/logm.info
fi

case $1 in
    "login")

        logip=$(echo "${newloger}" | cut -d '|' -f 1)
        logtime=$(echo "${newloger}" | cut -d '|' -f 2)
        lognum=$(echo "${newloger}" | cut -d '|' -f 3)
        last_lognum=$(echo "${lastloger}" | cut -d '|' -f 3)

        if [[ ${lognum} != ${last_lognum} && ${logip} != ":0" ]];then
            notify-send -i gtk-dialog-info "${logip} logged in your computer at ${logtime}"
        fi
        echo ${newloger} > $HOME/Command/logm.info
    ;;
    "logout")
        last_logip=$(echo "${lastloger}" | cut -d '|' -f 1)
        notify-send -i gtk-dialog-info "${last_logip} logged out at $(date +"%H:%M:%S")"
        echo $(echo "${newloger}" | awk -F '|' '
        {
            printf("%s|%s|%d", $1, $2, $3 - 1);
        }
        ') > $HOME/Command/logm.info
    ;;
esac

