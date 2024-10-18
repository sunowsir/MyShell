#!/bin/bash
#
#	* File     : install_chroot.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : Fri 18 Oct 2024 01:50:53 PM CST


#!/bin/bash

# Exit on errors
set -e

# Set disk variable
DISK="/dev/nvme0n1"

# Set root password
ROOT_PWD="wwxinyang"

# Set sun password
SUN_PWD="wxinyang"

function root_passwd_setup() {
    echo "root:${ROOT_PWD}" | chpasswd
}

function time_zone_setup() {
    # Set time zone
    echo "Setting time zone to Shanghai..."
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc

    # Set localization
    echo "Gen localization..."
    locale-gen

    echo "Add user sun"
    useradd sun -m -s /bin/zsh
    echo "sun:${SUN_PWD}" | chpasswd

    return $?
}

function base_pkg_install() {

    echo "Install base package"
    pacman -Syyu --noconfirm 
    pacman -Sy --noconfirm pacman-mirrorlist

    echo "[archlinuxcn]" >> /etc/pacman.conf
    echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

    pacman -Sy --noconfirm archlinuxcn-keyring
    pacman-key --lsign-key "farseerfc@archlinux.org"
    pacman -Sy --noconfirm archlinuxcn-keyring

    pacman -S --noconfirm sudo neovim zsh git curl wget man-db efibootmgr intel-ucode patch paru networkmanager openssh dhcpcd cockpit cockpit-files cockpit-machines cockpit-packagekit cockpit-podman cockpit-storaged qemu libvirt ovmf virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat podman podman-compose

    usermod -a -G libvirt sun

    return $?
}

function service_setup() {
    echo "Enabling services..."
    systemctl enable sshd
    systemctl enable NetworkManager 
    systemctl enable dhcpcd
    systemctl enable cockpit
    systemctl enable cockpit.socket

    return $?
}

function bootloader_setup() {
    echo "Cconfigure boot loader"
    efibootmgr --create --disk ${DISK} --part 1 --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=/dev/nvme0n1p3  resume=/dev/nvme0n1p2 rw initrd=\initramfs-linux.img quiet splash'

    return $?
}


function main() {
    root_passwd_setup || exit $?
    time_zone_setup || exit $?
    base_pkg_install || exit $?
    service_setup || exit $?
    bootloader_setup
}

main
exit $?
