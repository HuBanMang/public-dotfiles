#!/bin/bash

# Init debian
# TTY中不能显示中文，尽量用英文

# preconditions
#   The Base system has been installed

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

download_link="https://mirrors.ustc.edu.cn/debian-cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-dvd"
download_name="firmware-11.6.0-amd64-DVD-1.iso"

dotfiles_sourceslist="$dotfiles_path/system/debian/sources.list"
dotfiles_vimrc="$dotfiles_path/shell/vim/vimrc"
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
        wget $download_link/SHA512SUMS.sign
        wget $download_link/SHA512SUMS
        echo "Sleep"
        sleep 2
        echo
        gpg --keyserver-options auto-key-retrieve --verify SHA512SUMS.sign
        echo
        sha512sum -c SHA512SUMS
    fi
fi

# --------------------------------------------------------------------------}}}

# sources.list -------------------------------------------------------------{{{

echo
read -rp "[ROOT] Override sources.list? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    cp -v "$dotfiles_sourceslist" "/etc/apt/sources.list"
    chmod 644 -cv "/etc/apt/sources.list"
    # apt edit-sources
    nano /etc/apt/sources.list
fi

# --------------------------------------------------------------------------}}}

# sudo apt ------------------------------------------------------------{{{

echo
read -rp "[ROOT] install sudo? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    apt update
    apt upgrade
    apt install sudo
fi

echo
read -rp "Full upgrade? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt update
    sudo apt full-upgrade
fi

# --------------------------------------------------------------------------}}}

# showmanual ---------------------------------------------------------------{{{

echo
read -rp "ShowManual? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt-mark minimize-manual
    echo "apt-mark showmanual > /root/showmanual.txt"
    #aptitude search -F '%c%a%M%S %p %E %R  %s  %t %v %V %D' '~i !~M !~E !~prequired !~pimportant !~pstandard' | sudo tee /root/showmanual-$(date +%Y-%m-%d-%H-%M).txt > /dev/null
    apt-mark showmanual | sudo tee "/root/showmanual-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null
    echo "apt-mark showmanual | wc -l"
    #aptitude search -F '%c%a%M%S %p %E %R  %s  %t %v %V %D' '~i !~M !~E !~prequired !~pimportant !~pstandard' | wc -l
    apt-mark showmanual | wc -l
fi

# --------------------------------------------------------------------------}}}

# task ---------------------------------------------------------------------{{{

echo
read -rp "Tasksel install standard? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install tasksel
    sudo tasksel install standard
fi

echo
read -rp "Tasksel install english/chinese-s? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install tasksel task-english task-chinese-s
    sudo tasksel install english
    sudo tasksel install chinese-s
fi

echo
read -rp "Tasksel install laptop? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install tasksel task-laptop
    sudo tasksel install laptop
fi

# --------------------------------------------------------------------------}}}

# firmware -----------------------------------------------------------------{{{

echo
read -rp "Firmware? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install firmware-linux

    echo
    read -rp " intel-microcode? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo apt install intel-microcode

    fi

    echo
    read -rp " amd64-microcode? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo apt install amd64-microcode
    fi

    echo
    read -rp " iwlwifi/realtek? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo apt install firmware-iwlwifi firmware-realtek
    fi

    echo
    read -rp " bluez? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo apt install bluez-firmware
    fi

    echo
    read -rp " sof? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo apt install firmware-sof-signed firmware-intel-sound
    fi
fi

# --------------------------------------------------------------------------}}}

# hardware probe -----------------------------------------------------------{{{

echo
read -rp "Hardware Probe? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        hw-probe \
        lm-sensors smartmontools
fi

# --------------------------------------------------------------------------}}}

# unattended upgrade -------------------------------------------------------{{{

echo
read -rp "Unattended upgrade? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        unattended-upgrades \
        needrestart

    sudo dpkg-reconfigure unattended-upgrades
    sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
    echo
    read -rp " Test unattended upgrade? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo unattended-upgrade -d --dry-run
    fi
fi

# --------------------------------------------------------------------------}}}

# dkms ---------------------------------------------------------------------{{{

echo
read -rp "DKMS Build-essential? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        dkms \
        build-essential
fi

# --------------------------------------------------------------------------}}}

# firewall -----------------------------------------------------------------{{{

echo
read -rp "Firewall? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        firewalld fail2ban

    sudo systemctl enable firewalld
    sudo systemctl enable fail2ban
fi

# --------------------------------------------------------------------------}}}

# shell --------------------------------------------------------------------{{{

echo
read -rp "Shells? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        bash bash-completion \
        zsh zsh-autosuggestions zsh-syntax-highlighting \
        curl git rsync ssh tmux vim

    echo
    read -rp " Copy vimrc.local? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo cp -v "$dotfiles_vimrc" "/etc/vim/vimrc.local"
        sudo chmod 644 -cv "/etc/vim/vimrc.local"
    fi
fi

# --------------------------------------------------------------------------}}}

# tools --------------------------------------------------------------------{{{

echo
read -rp "Terminal Tools? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        fzf fd-find ripgrep \
        p7zip-full p7zip-rar \
        proxychains4 \
        tldr
fi

# --------------------------------------------------------------------------}}}

# docs ---------------------------------------------------------------------{{{

echo
read -rp "Linux/Debian Docs? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        linux-doc \
        debian-reference debian-handbook \
        #debian-kernel-handbook
fi

# --------------------------------------------------------------------------}}}

# cockpit ------------------------------------------------------------------{{{

echo
read -rp "Cockpit? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        cockpit cockpit-pcp tuned

    echo
    read -rp " add cockpit pass firewalld? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        sudo firewall-cmd --add-service=cockpit
    fi
fi

# --------------------------------------------------------------------------}}}

# network manager ----------------------------------------------------------{{{

echo
echo "[TODO] ERROR!!! LOST INTELNET CONNECTION!!!"
read -rp "NetworkManager? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install network-manager systemd-resolved
    sudo sed -i '/.*managed=*/c\managed=true' /etc/NetworkManager/NetworkManager.conf
    EDITOR=vim sudo -e /etc/NetworkManager/NetworkManager.conf
    echo
    sudo systemctl restart systemd-resolved
    sudo systemctl restart NetworkManager
    echo "Sleep"
    sleep 5
    echo
    ip --color a
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
read -rp "GNOME Core? <y/N> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" ]]; then
    sudo apt install \
        gnome-core \
        task-chinese-s-gnome-desktop \
        ibus-libpinyin ibus-table-wubi \
        gnome-tweaks \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-panel \
        fonts-noto fonts-firacode

        #papirus-icon-theme
fi

# --------------------------------------------------------------------------}}}

# kde ----------------------------------------------------------------------{{{

echo
read -rp "KDE Standard? <y/N> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" ]]; then
    sudo apt install \
        kde-standard \
        task-chinese-s-kde-desktop \
        fcitx5 fcitx5-chinese-addons kde-config-fcitx5 \
        yakuake \
        fonts-noto fonts-firacode

        #plasma-firewall \
        #plasma-calendar-addons \
        #plasma-workspace-wallpapers
fi

# --------------------------------------------------------------------------}}}

# gui apps -----------------------------------------------------------------{{{

echo
read -rp "GUI APPs? <y/N> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" ]]; then
    sudo apt install \
        firefox webext-ublock-origin-firefox \
        chromium vlc
fi

# --------------------------------------------------------------------------}}}

# fortune ------------------------------------------------------------------{{{

echo
read -rp "Fortune? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt install \
        fortunes fortunes-zh cowsay

    /usr/games/fortune | /usr/games/cowsay
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

# showmanual ---------------------------------------------------------------{{{

echo
read -rp "ShowManual? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo apt-mark minimize-manual
    echo "apt-mark showmanual > /root/showmanual.txt"
    #aptitude search -F '%c%a%M%S %p %E %R  %s  %t %v %V %D' '~i !~M !~E !~prequired !~pimportant !~pstandard' | sudo tee /root/showmanual-$(date +%Y-%m-%d-%H-%M).txt > /dev/null
    apt-mark showmanual | sudo tee "/root/showmanual-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null
    echo "apt-mark showmanual | wc -l"
    #aptitude search -F '%c%a%M%S %p %E %R  %s  %t %v %V %D' '~i !~M !~E !~prequired !~pimportant !~pstandard' | wc -l
    apt-mark showmanual | wc -l
fi

# --------------------------------------------------------------------------}}}

# unset --------------------------------------------------------------------{{{

unset dotfiles_path

unset download_link
unset download_name

unset dotfiles_sourceslist
unset dotfiles_vimrc
unset dotfiles_configsystem

# --------------------------------------------------------------------------}}}

# The End. -----------------------------------------------------------------{{{

echo "The End." | /usr/games/cowsay -f dragon

# --------------------------------------------------------------------------}}}
