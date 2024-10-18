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

    sed -i 's/^#[\ ]*Color/Color/g' /etc/pacman.conf
    sed -i 's/^#[\ ]*CheckSpace/CheckSpace/g' /etc/pacman.conf
    sed -i 's/^#[\ ]*VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

    pacman -Syyu --noconfirm 
    pacman -Sy --noconfirm pacman-mirrorlist

    echo "[archlinuxcn]" >> /etc/pacman.conf
    echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

    pacman -Sy --noconfirm archlinuxcn-keyring
    pacman-key --lsign-key "farseerfc@archlinux.org"
    pacman -Sy --noconfirm archlinuxcn-keyring

    pacman -S --noconfirm sudo neovim zsh git curl wget man-db efibootmgr intel-ucode patch paru networkmanager openssh dhcpcd 
    pacman -S --noconfirm cockpit cockpit-files cockpit-machines cockpit-packagekit cockpit-podman cockpit-storaged 
    pacman -S --noconfirm qemu libvirt ovmf virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat podman podman-compose 
    pacman -S --noconfirm wayland xorg-xwayland 
    pacman -S --noconfirm sddm plasma kde-applications 
    pacman -S --noconfirm kdegraphics-thumbnailers ffmpegthumbs print-manager cups kdenetwork-filesharing powerdevil power-profiles-daemon
    pacman -S --noconfirm sonnet sddm-kcm plymouth-kcm kde-pim akonadi kdepim-addons sshfs kscreen colord-kde kio-admin kio-extras kio-fuse kio-zeroconf kde-gtk-config 
    pacman -S --noconfirm libappindicator-gtk2 libappindicator-gtk3 alsa-utils plasma-pa 

    pacman -S --noconfirm fcitx5-im fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-lua
    echo 'XMODIFIERS=@im=fcitx' >> /etc/environment


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
    systemctl enable sddm

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
