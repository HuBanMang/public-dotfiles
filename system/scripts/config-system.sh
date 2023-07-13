#!/bin/bash

# Config System
# TTY中不能显示中文，尽量用英文

# preconditions ------------------------------------------------------------{{{

#   System has installed
#   Operate locally, connection may be interrupted
#   dotfiles
# Config
#   sshd banner motd
#   vimrc.local
#   tmux.conf
#   hostname locales timezone
#   grub
#   fwupdmgr
#   network NetworkManager
#   firewalld
#   fail2ban sshd-jail.local

# --------------------------------------------------------------------------}}}

# config system ------------------------------------------------------------{{{

# dotfiles -----------------------------------------------------------------{{{

if [ -d "/dotfiles" ]; then
    dotfiles_path="/dotfiles"
else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: dotfiles not found!\n"
    exit 1
fi
echo
echo "dotfiles path: $dotfiles_path"
echo

dotfiles_vimrc="$dotfiles_path/shell/vim/vimrc"
dotfiles_tmuxconf="$dotfiles_path/shell/tmux/tmux.conf"

# --------------------------------------------------------------------------}}}

# sshd ---------------------------------------------------------------------{{{

echo
echo -e "\n\e[33m[WARNING]\e[0m\n"
read -rp "sshd? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    # [TODO] update sshd config
    #sudo sed -i -e 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    EDITOR=vim sudo -e /etc/ssh/sshd_config
    echo
    sudo systemctl restart sshd
    echo "Sleep"
    sleep 2
    echo
    sudo systemctl status sshd
fi

# --------------------------------------------------------------------------}}}

# banner -------------------------------------------------------------------{{{

echo
read -rp "Banner? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    figlet < "/etc/hostname" | sudo tee /etc/banner
    sudo sed -i -e 's/^#Banner none/Banner \/etc\/banner/' /etc/ssh/sshd_config
fi

# --------------------------------------------------------------------------}}}

# motd ---------------------------------------------------------------------{{{

echo
read -rp "Motd? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    # [TODO] Motd
    echo
fi

# --------------------------------------------------------------------------}}}

# vimrc.local --------------------------------------------------------------{{{

echo
read -rp "Vimrc? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [ -d /etc/vim/ ]; then
        # debian vim
        if [ -e /etc/vim/vimrc.local ]; then
            sudo cp -v /etc/vim/vimrc.local /etc/vim/vimrc.local.old
        fi
        sudo cp -v "$dotfiles_vimrc" "/etc/vim/vimrc.local"
        sudo chmod 644 -cv "/etc/vim/vimrc.local"
        EDITOR=vim sudo -e "/etc/vim/vimrc.local"
    elif [ -e /etc/vimrc ]; then
        # arch vim
        echo -e "if filereadable(expand(\"/dotfiles/shell/vim/vimrc\"))\n    source /dotfiles/shell/vim/vimrc\nendif" | sudo tee -a /etc/vimrc
        EDITOR=vim sudo -e "/etc/vimrc"
    fi
fi

# --------------------------------------------------------------------------}}}

# tmux.conf ----------------------------------------------------------------{{{

echo
read -rp "/etc/tmux.conf? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [ -e /etc/tmux.conf ]; then
        sudo cp -v /etc/tmux.conf /etc/tmux.conf.old
    fi
    sudo cp -v "$dotfiles_tmuxconf" "/etc/tmux.conf"
    sudo chmod 644 -cv "/etc/tmux.conf"
fi

# --------------------------------------------------------------------------}}}

# hostname -----------------------------------------------------------------{{{

echo
read -rp "Hostname? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    # type foo &>/dev/null
    # hash foo &>/dev/null
    # command -v foo &>/dev/null
    # which foo &>/dev/null
    if type hostnamectl; then
        hostnamectl
    else
        #cat /etc/hostname
        uname -a
    fi
fi

# --------------------------------------------------------------------------}}}

# locales ------------------------------------------------------------------{{{

echo
read -rp "Locales? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    #EDITOR=vim sudo -e /etc/locale.gen # C.UTF-8 en_US.UTF-8 zh_CN.UTF-8
    sudo sed -i -e 's/^# C.UTF-8/C.UTF-8/; s/^# en_US.UTF-8/en_US.UTF-8/; s/^# zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
    sudo sed -i -e 's/^#C.UTF-8/C.UTF-8/; s/^#en_US.UTF-8/en_US.UTF-8/; s/^#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
    sudo locale-gen

    echo "LANG=C.UTF-8" | sudo tee /etc/default/locale
    echo
    echo "/etc/default/locale"
    tail --lines 5 /etc/default/locale
    echo
    if type localectl; then
        sudo localectl list-locales
        sudo localectl set-locale "C.UTF-8"
        sudo localectl status
    fi

    #echo
    #echo "shell locale"
    #locale
fi

# --------------------------------------------------------------------------}}}

# timezone -----------------------------------------------------------------{{{

echo
read -rp "Timezone? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if command -v timedatectl; then
        sudo timedatectl set-timezone Asia/Shanghai
        sudo timedatectl set-ntp true
        sudo timedatectl set-local-rtc 0
        sudo timedatectl
    else
        sudo ln -snfv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        sudo hwclock --systohc
    fi
fi

# --------------------------------------------------------------------------}}}

# im env -------------------------------------------------------------------{{{

echo
read -rp "ime /etc/environment? <y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "y" ]]; then
    echo
    echo "/etc/environment"
    sudo tee "/etc/environment" <<'eof'
#GTK_IM_MODULE=fcitx
#QT_IM_MODULE=fcitx
#XMODIFIERS=@im=fcitx
#SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
eof
editor=vim sudo -e /etc/environment
fi

# --------------------------------------------------------------------------}}}

# grub ---------------------------------------------------------------------{{{

echo
read -rp "Update grub? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    # [TODO] grub config
    EDITOR=vim sudo -e /etc/default/grub
    #sudo update-grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# --------------------------------------------------------------------------}}}

# fwupdmgr -----------------------------------------------------------------{{{

echo
read -rp "FWupdmgr? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    sudo fwupdmgr get-devices
    sudo fwupdmgr refresh
    sudo fwupdmgr get-updates
    sudo fwupdmgr update
fi

# --------------------------------------------------------------------------}}}

# security -----------------------------------------------------------------{{{

echo
read -rp "Security? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    echo
fi

# --------------------------------------------------------------------------}}}

# unset --------------------------------------------------------------------{{{

unset dotfiles_path
unset dotfiles_vimrc
unset dotfiles_tmuxconf

# --------------------------------------------------------------------------}}}

# --------------------------------------------------------------------------}}}
