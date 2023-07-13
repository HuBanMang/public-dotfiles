#!/bin/bash

# Init Arch

# preconditions ------------------------------------------------------------{{{

# TTY中不能显示中文，尽量用英文
# `Arch Live ISO`中提供`archinstall`，可以简化安装过程，但是命令行安装稳定可控
#
# !!!Change [hostname] and [username] in this script!!!
# !!!Dual boot need to mount other EFI partition!!!
#
# Network[Wifi]
#   ip link
#   rfkill unblock wifi
#   ip link set [wlan0] up
#   iwctl
#       device list
#       station [wlan0] scan
#       station [wlan0] get-networks
#       station [wlan0] connect [wifi-ssid]
#       station [wlan0] show
#       exit
#   ping archlinux.org
# Partition / File system
#   lsblk
#   cfdisk /dev/[sda/nvme0n1]
#   fdisk -l
#   fdisk /dev/[sda/nvme0n1]
#       # gpt
#       > g
#       # EFI   /dev/[sda1/nvme0n1p1]
#       > n     # +2G
#       > t     # uefi  EFI system partition
#       # root  /dev/[sda2/nvme0n1p2]
#       > n     # +256G
#       > t     # 23    Linux root(x86-64)
#       # swap  /dev/[sda3/nvme0n1p3]
#       > n     # +2G/memory size
#       > t     # swap  Linux swap
#       # home  /dev/[sda4/nvme0n1p4]
#       > n     # +max
#       > t     # 20    Linux filesystem
#       > p
#       > w
#   lsblk
#   mkfs.vfat /dev/[sda1/nvme0n1p1]
#   mkfs.ext4 /dev/[sda2/nvme0n1p2]
#   mkfs.ext4 /dev/[sda4/nvme0n1p4]
#   mkswap /dev/[sda3/nvme0n1p3]
# Mount
#   mount /dev/[sda2/nvme0n1p2] /mnt
#   mount --mkdir /dev/[sda1/nvme0n1p1] /mnt/boot
#   mount --mkdir /dev/[sda4/nvme0n1p4] /mnt/home
#   swapon /dev/[sda3/nvme0n1p3]
# Change [hostname] and [username] in this script
# Dual boot need to mount other EFI partition

# --------------------------------------------------------------------------}}}

# dotfiles -----------------------------------------------------------------{{{

# sftp username@dotfiles-server
# >get -r dotfiles

if [ -d "/dotfiles" ]; then
    dotfiles_path="/dotfiles"
else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: dotfiles not found!\n"
    exit 1
fi
echo
echo "dotfiles path: $dotfiles_path"
echo

# Hostname, used by `/etc/hostname` `/etc/hosts`
hostname="ArchLinux"

# Users
# sudo user, id 1000
sudoname="sudo"
sudoid="1000"
# default user, id 1001
username="user"

download_link="https://mirrors.ustc.edu.cn/archlinux/iso/latest"
download_name="archlinux-x86_64.iso"

dotfiles_configsystem="$dotfiles_path/system/scripts/config-system.sh"
dotfiles_configsecurity="$dotfiles_path/security/scripts/config-security.sh"

# --------------------------------------------------------------------------}}}

# iso ----------------------------------------------------------------------{{{

echo
read -rp "Wget $download_name? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    pwd
    wget $download_link/$download_name

    echo
    read -rp " Verify $download_name? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        wget $download_link/$download_name.sig
        echo "Sleep"
        sleep 2
        echo
        gpg --keyserver-options auto-key-retrieve --verify archlinux-x86_64.iso.sig
    fi
fi

# --------------------------------------------------------------------------}}}

# check --------------------------------------------------------------------{{{

echo
read -rp "Verify the boot mode? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    ls /sys/firmware/efi/efivars
fi

echo
read -rp "Check internet and time? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    ip -br --color link
    ping archlinux.org -c 5
    timedatectl status
fi

# --------------------------------------------------------------------------}}}

# pacman -------------------------------------------------------------------{{{

echo
read -rp "pacman config? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo tee /etc/pacman.d/mirrorlist <<'EOF'
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
EOF

echo
EDITOR=vim sudo -e /etc/pacman.d/mirrorlist
EDITOR=vim sudo -e /etc/pacman.conf # color parallel
sudo pacman -Syy
sudo pacman -S --needed archlinux-keyring
#sudo pacman -Syu
fi

# --------------------------------------------------------------------------}}}

# bootstrap ----------------------------------------------------------------{{{

echo
read -rp "[LIVE] bootstrap? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    echo
    read -rp " [LIVE] PacStrap -K /mnt? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        pacstrap -K /mnt base base-devel \
            linux linux-firmware \
            sudo vim \
            #networkmanager
    fi

    echo
    read -rp " [LIVE] Genfstab -U /mnt? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        genfstab -U /mnt >> /mnt/etc/fstab
    fi

    echo
    read -rp " [LIVE] cp -rLu /dotfiles /mnt? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        cp -rLu /dotfiles /mnt
    fi

    echo
    read -rp " [LIVE] Arch-chroot /mnt? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        echo "arch-chroot /mnt manually"
        exit 1
    fi
fi

# --------------------------------------------------------------------------}}}

# system -------------------------------------------------------------------{{{

echo "Manual Installed:"
pacman -Qe | sudo tee "/root/showmanual-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null

# root passwd --------------------------------------------------------------{{{

echo
read -rp "Root Passwd? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo passwd
fi

# --------------------------------------------------------------------------}}}

# add user -----------------------------------------------------------------{{{

echo
read -rp "Add User: $sudoname $username? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    # add sudoname
    sudo groupadd \
        --gid "$sudoid" \
        $sudoname

    sudo useradd \
        --uid "$sudoid" \
        --gid "$sudoid" \
        --create-home \
        --shell /bin/bash \
        $sudoname

    echo "$sudoname passwd"
    sudo passwd "$sudoname"
    sudo usermod -aG wheel "$sudoname"
    sudo EDITOR=vim visudo
    id "$sudoname"
    # hide sudo user in gdm
    echo -e "[User]\nSystemAccount=true\n" | sudo tee /var/lib/AccountsService/users/"$sudoname"
    #
    # hide sudo user in sddm
    # setting --> login screen --> min uid ~ max uid

    # add username
    echo
    sudo useradd \
        --create-home \
        "$username"

    echo "$username passwd"
    sudo passwd "$username"
    id "$username"
fi

# --------------------------------------------------------------------------}}}

# hostname -----------------------------------------------------------------{{{

echo
read -rp "Hostname: $hostname? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    #sudo hostnamectl hostname $hostname
    #sudo hostnamectl

    echo "$hostname" | sudo tee /etc/hostname
fi

# --------------------------------------------------------------------------}}}

# locale -------------------------------------------------------------------{{{

echo
read -rp "Locale? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    #EDITOR=vim sudo -e /etc/locale.gen # C.UTF-8 en_US.UTF-8 zh_CN.UTF-8
    sudo sed -i -e 's/^#C.UTF-8/C.UTF-8/; s/^#en_US.UTF-8/en_US.UTF-8/; s/^#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
    sudo locale-gen

    echo
    echo 'LANG=C.UTF-8' | sudo tee /etc/locale.conf
    echo
    echo "/etc/locale.conf"
    tail --lines 5 /etc/locale.conf
    echo

    #sudo localectl list-locales
    #sudo localectl set-locale "C.UTF-8"
    #sudo localectl
fi

# --------------------------------------------------------------------------}}}

# timezone -----------------------------------------------------------------{{{

echo
read -rp "Timezone? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo ln -snfv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    sudo hwclock --systohc

    #sudo timedatectl set-timezone Asia/Shanghai
    #sudo timedatectl set-ntp true
    #sudo timedatectl
fi

# --------------------------------------------------------------------------}}}

# dkms ---------------------------------------------------------------------{{{

echo
read -rp "DKMS linux-hearders? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        dkms linux-headers
fi

# --------------------------------------------------------------------------}}}

# firmware -----------------------------------------------------------------{{{

echo
read -rp "Firmware and microcode? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed fwupd
    #sudo fwupdmgr get-devices
    #sudo fwupdmgr refresh
    #sudo fwupdmgr get-updates
    #sudo fwupdmgr update
    sudo pacman -S --needed linux-firmware
    sudo pacman -S --needed intel-ucode #amd-ucode
    sudo pacman -S --needed sof-firmware
    sudo pacman -S --needed bluez
fi

# --------------------------------------------------------------------------}}}

# grub ---------------------------------------------------------------------{{{

echo
read -rp "GRUB? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed grub efibootmgr
    EDITOR=vim sudo -e /etc/default/grub
    sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    echo
    read -rp " Dual Boot (other boot partitions should have mounted)? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo pacman -S --needed grub efibootmgr os-prober
        EDITOR=vim sudo -e /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
fi

# --------------------------------------------------------------------------}}}

# firewall -----------------------------------------------------------------{{{

echo
read -rp "Firewall? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        firewalld fail2ban

    sudo systemctl enable firewalld
    sudo systemctl enable fail2ban
fi

# --------------------------------------------------------------------------}}}

# shells -------------------------------------------------------------------{{{

echo
read -rp "Shells? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        openssh tmux \
        bash bash-completion \
        zsh zsh-completions \
        zsh-autosuggestions zsh-syntax-highlighting \
        zsh-lovers

    sudo systemctl enable sshd
fi

# --------------------------------------------------------------------------}}}

# terminal tools -----------------------------------------------------------{{{

echo
read -rp "Terminal Tools? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        curl git rsync vim wget

    echo
    read -rp " More Terminal Tools? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo pacman -S --needed \
            fzf fd ranger ripgrep \
            p7zip \
            tldr
    fi
fi

# --------------------------------------------------------------------------}}}

# doc ----------------------------------------------------------------------{{{

echo
read -rp "Linux/Arch Docs? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        linux-docs \
        arch-wiki-lite arch-wiki-docs
fi

# --------------------------------------------------------------------------}}}

# network manager ----------------------------------------------------------{{{

echo
read -rp "Network Manager? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed networkmanager
    sudo systemctl enable NetworkManager
fi

# --------------------------------------------------------------------------}}}

# cockpit ------------------------------------------------------------------{{{

echo
read -rp "Cockpit? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        cockpit

    echo
    read -rp " add cockpit pass firewalld? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo firewall-cmd --add-service=cockpit
    fi
fi

# --------------------------------------------------------------------------}}}

# multi-user.target --------------------------------------------------------{{{

echo
read -rp "set default to multi-user.target? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo systemctl get-default
    sudo systemctl set-default multi-user.target
    sudo systemctl get-default
fi

# --------------------------------------------------------------------------}}}

# gnome --------------------------------------------------------------------{{{

echo
read -rp "GNOME? <y/N> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        gnome gnome-tweaks gnome-themes-extra \
        ibus ibus-libpinyin \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-panel \
        noto-fonts noto-fonts-cjk noto-fonts-emoji \
        ttf-firacode-nerd ttf-sarasa-gothic

    sudo systemctl enable gdm
fi

# --------------------------------------------------------------------------}}}

# kde ----------------------------------------------------------------------{{{

echo
read -rp "KDE? <y/N> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        plasma-meta kde-system-meta kde-utilities-meta \
        fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki \
        noto-fonts noto-fonts-cjk noto-fonts-emoji \
        ttf-firacode-nerd ttf-sarasa-gothic

    sudo systemctl enable sddm

    echo
    echo "fcitx5 /etc/environment"
    sudo tee "/etc/environment" <<'EOF'
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
EOF
EDITOR=vim sudo -e /etc/environment
fi

# --------------------------------------------------------------------------}}}

# gui apps -----------------------------------------------------------------{{{

echo
read -rp "GUI APPs? <y/N> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        firefox firefox-developer-edition \
        chromium vlc
fi

# --------------------------------------------------------------------------}}}

# --------------------------------------------------------------------------}}}

# fortune ------------------------------------------------------------------{{{

echo
read -rp "Fortune? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed \
        fortune-mod cowsay

    fortune linux | cowsay
fi

# --------------------------------------------------------------------------}}}

# config system ------------------------------------------------------------{{{

echo
read -rp "Config system? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    $dotfiles_configsystem
fi

# --------------------------------------------------------------------------}}}

# config security ----------------------------------------------------------{{{

echo
read -rp "Config Security? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    $dotfiles_configsecurity
fi

# --------------------------------------------------------------------------}}}

# unset --------------------------------------------------------------------{{{

unset dotfiles_path
unset hostname
unset sudoname
unset sudoid
unset username

unset download_link
unset download_name

# --------------------------------------------------------------------------}}}

# The End. -----------------------------------------------------------------{{{

echo
read -rp "Show Manual? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    echo "Manual Installed:"
    pacman -Qe | sudo tee "/root/showmanual-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null
    echo "Manual Installed Count:"
    pacman -Qe | wc -l
fi

echo "The End." | cowsay -f dragon

# --------------------------------------------------------------------------}}}
