#!/bin/bash
#
#	* File     : install.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : Fri 18 Oct 2024 11:56:23 AM CST


# Exit on errors
set -e

# Set disk variable
DISK="/dev/nvme0n1"

function disk_setup() {

    # Partition the disk using GPT
    echo "Partitioning the disk..."
    sgdisk -o $DISK                                     # Create new GPT partition table
    sgdisk -n 1:0:+500M -t 1:EF00 $DISK                 # EFI System Partition (500MB)
    sgdisk -n 2:0:+8G -t 2:8200 $DISK                   # Swap Partition (8GB)
    sgdisk -n 3:0:0 -t 3:8300 $DISK                     # Root Partition (Remaining space)
    
    # Format partitions
    echo "Formatting partitions..."
    mkfs.vfat -F32 "${DISK}p1"                           # Format EFI partition as FAT32
    mkswap "${DISK}p2"                                   # Initialize swap partition
    mkfs.ext4 "${DISK}p3"                                # Format root partition as ext4

    # Mount partitions
    echo "Mounting partitions..."
    mount "${DISK}p3" /mnt                               # Mount root partition
    mkdir /mnt/boot                                     # Create boot directory
    mount "${DISK}p1" /mnt/boot                          # Mount EFI partition
    swapon "${DISK}p2"                                   # Enable swap partition

    return $?
}

function base_pkg_install() {
    # Install base system
    echo "Installing base system..."

    echo '##' > /etc/pacman.d/mirrorlist
    echo '## Arch Linux repository mirrorlist' >> /etc/pacman.d/mirr 
    echo '## Generated on 2024-10-18' >> /etc/pacman.d/mirr  
    echo '##' >> /etc/pacman.d/mirr  
    echo '' >> /etc/pacman.d/mirr    
    echo '## China' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr  
    echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.cqu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.hit.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.hust.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.jcut.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.jlu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.jxust.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr  
    echo 'Server = https://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.njupt.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr  
    echo 'Server = https://mirror.nyist.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.qlu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirrors.qvq.net.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr    
    echo 'Server = https://mirror.redrock.team/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.shanghaitech.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr 
    echo 'Server = https://mirrors.wsyu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   
    echo 'Server = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirr   

    pacstrap -K /mnt base linux linux-firmware base-devel

    return $?
}

function base_config_setup() {

    # Generate fstab
    echo "Generating fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab

    # Set localization
    echo "Configuring localization..."
    sed -i 's/^#[\ ]*en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g' /mnt/etc/locale.gen
    sed -i 's/^#[\ ]*zh_CN.UTF-8\ UTF-8/zh_CN.UTF-8\ UTF-8/g' /mnt/etc/locale.gen
    echo "LANG=zh_CN.UTF-8" > /mnt/etc/locale.conf

    # Set hostname
    echo "Setting hostname..."
    echo "matebook13" > /mnt//etc/hostname
    echo "127.0.0.1   localhost" >> /mnt/etc/hosts
    echo "::1         localhost" >> /mnt/etc/hosts
    echo "127.0.1.1   matebook13.localdomain matebook13" >> /mnt/etc/hosts
    
    return $?
}


function chroot_setup() {
    
    echo "Chroot to /mnt continue setup"
    cp ./install_chroot.sh /mnt/root/
    chmod +x /mnt/root/install_chroot.sh

    # Chroot into the installed system
    arch-chroot /mnt /root/install_chroot.sh

    return $?
}


function install_end() {

    # Unmount partitions and reboot
    # echo "Unmounting partitions and rebooting..."
    # umount -R /mnt
    # swapoff -a
    # reboot

    return $?
}

function main() {
     timedatectl set-ntp true

    disk_setup || exit $?
    base_pkg_install || exit $?
    base_config_setup || exit $?
    chroot_setup || exit $?
    install_end
}

main 
exit $?
