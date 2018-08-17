#!/bin/bash
source /home/sunowsir/.backuprc
source /home/sunowsir/.zshrc

flog="/home/sunowsir/Command/backup.log"
now_date=`date +"%Y%m%d%H%M%S"`

for path in `echo ${backup_path} | tr ":" "\n"`
do

    if [[ ! -e ${path} ]];then
        echo -e "${now_date} backup ${path} --> \033[31mERROR: the path doesn\'t exist\033[0m" >> ${flog}
        continue;
    fi

    names=`echo $path | tr -s '/' '_'`

    tar cvfP ${now_date}${names}.tar ${path} > /dev/null

    if [[ $? == 0 ]];then

        # tar size 
        psize=`du -k ${now_date}${names}.tar | cut -d " " -f1`
        psize=`echo $psize | cut -d " " -f1`

        # move tar to target path
        mv ${now_date}${names}.tar ${target_path}

        echo "${now_date} backup ${path} --> ${now_date}${names}.tar +${psize}k" >> ${flog}

    else

        
        echo -e "${now_date} backup ${path} --> \033[31mERROR:Package failure\033[0m" >> ${flog}

    fi

done

# delete package before three days 

cd ${target_path}

for package in `find ./ -name "*.tar" -mtime +3`
do


    psize=`du -k ${package} | cut -d " " -f1`
    psize=`echo $psize | cut -d " " -f1`

    echo "${now_date} delete ${package} --> -${psize}k" >> ${flog}
    
    rm -rf ${package}

done
