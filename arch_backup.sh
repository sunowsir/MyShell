#!/bin/bash
#
#	* File     : arch_backup.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : 2021年01月03日 星期日 14时38分47秒


# sudo tar --use-compress-program=pigz -cvpf arch-backup.tgz --exclude=/proc --exclude=/lost+found --exclude=/arch-backup.tgz --exclude=/mnt --exclude=/sys --exclude=/run/media --exclude=/boot --exclude=/home/sunowsir/Download --exclude=/home/sunowsir/Nextcloud --exclude=/home/sunowsir/     /

# tar --use-compress-program=pigz -xvpf /f/sysbackup/arch-backup-20160331.tgz -C /mnt

tool="tar"

tool_args

function checkout() {

    if eval "pacman h 2>&1 /dev/null"; then
        echo "package mannager is pacman."
    else
        echo "pacman manager is not pacman"
        return 1
    fi

    # judge pigz .
    if eval "pigz -h 2>&1 /dev/null"; then
        echo "pigz already installed.";
    else 
        echo "pigz is not installed."
        sudo pacman -S pigz
    fi

    return 0
}

function run_packup() {
}
