#!/bin/bash

# 配置家目录

# 前置条件
#   dotfiles

# dotfiles -----------------------------------------------------------------{{{

if [ -d "$HOME/dotfiles" ]; then
    dotfiles_path="$HOME/dotfiles"
elif [ -d "/dotfiles" ]; then
    #cp -rLuv "/dotfiles" "$HOME/"
    ln -snfv "/dotfiles" "$HOME/dotfiles"
    dotfiles_path="$HOME/dotfiles"
else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: dotfiles not found!\n"
    exit 1
fi
echo
echo "dotfiles path: $dotfiles_path"
echo

dotfiles_home_path="$dotfiles_path/shell/home"

# --------------------------------------------------------------------------}}}

# home dirs ----------------------------------------------------------------{{{

_home_dirs() {
    local home_dirs=(".backup" ".config" ".local" "archive" "devel" "note" "refer")
    for home_dir in "${home_dirs[@]}"; do
        if [ ! -e "$HOME/$home_dir" ]; then
            mkdir -pv "$HOME/$home_dir"
            chmod -cv 700 "$HOME/$home_dir"
        fi
    done
}
_home_dirs

# --------------------------------------------------------------------------}}}

# _deploy ------------------------------------------------------------------{{{

_deploy() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\n\e[31m[ERROR]\e[0m: string is empty!\n"
        exit 1
    fi
    if [ -e "$2.old" ]; then
        echo -e "\n\e[33m[WARNING]\e[0m: remove $2.old!\n"
        rm -v -rfv "$2.old"
    fi
    if [ -e "$2" ]; then
        mv -v "$2" "$2.old"
    fi

    cp -Lruv "$1" "$2"
    chmod -cv 600 "$2"

    echo -e "\n\e[32m[custom]\e[0m $2"
    if [ -e "$2.old" ]; then
        awk '/\[custom\]/ {i=1;next};i' "$2.old" >> "$2"
    fi
    awk '/\[custom\]/ {i=1;next};i' "$2"
    echo
}

# --------------------------------------------------------------------------}}}

# shrc ---------------------------------------------------------------------{{{

echo
read -rp "$HOME/.bashrc? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    _deploy "$dotfiles_home_path/.bashrc" "$HOME/.bashrc"
else
    rm -v "$HOME/.bashrc.old"
    rm -v "$HOME/.bashrc"
    cp -v "/etc/skel/.bashrc" "$HOME/.bashrc"
fi

echo
read -rp "$HOME/.zshrc? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    _deploy "$dotfiles_home_path/.zshrc" "$HOME/.zshrc"
else
    rm -v "$HOME/.zshrc.old"
    rm -v "$HOME/.zshrc"
fi

# --------------------------------------------------------------------------}}}

# ssh ----------------------------------------------------------------------{{{

echo
read -rp "$HOME/.ssh/config? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [[ ! -d "$HOME/.ssh" ]]; then
        mkdir -p "$HOME/.ssh"
        chmod -cv 700 "$HOME/.ssh"
    fi
    _deploy "$dotfiles_home_path/.sshconfig" "$HOME/.ssh/config"
else
    rm -v "$HOME/.ssh/config.old"
    rm -v "$HOME/.ssh/config"
fi

# --------------------------------------------------------------------------}}}

# git ----------------------------------------------------------------------{{{

echo
read -rp "$HOME/.config/git/config? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [[ ! -d "$HOME/.config/git" ]]; then
        mkdir -p "$HOME/.config/git"
        chmod -cv 700 "$HOME/.config/git"
        rm -v "$HOME/.gitconfig.old"
        mv -v "$HOME/.gitconfig" "$HOME/.config/git/config"
    fi
    _deploy "$dotfiles_home_path/.gitconfig" "$HOME/.config/git/config"
else
    rm -v "$HOME/.gitconfig.old"
    rm -v "$HOME/.gitconfig"
    rm -v "$HOME/.config/git/config.old"
    rm -v "$HOME/.config/git/config"
fi

# --------------------------------------------------------------------------}}}

# vim ----------------------------------------------------------------------{{{

echo
read -rp "$HOME/.vimrc? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [[ ! -d "$HOME/.vim" ]]; then
        mkdir -p "$HOME/.vim"
        chmod -cv 700 "$HOME/.vim"
        rm -v "$HOME/.vimrc.old"
        mv -v "$HOME/.vimrc" "$HOME/.vim/vimrc"
    fi
    _deploy "$dotfiles_home_path/.vimrc" "$HOME/.vim/vimrc"
else
    rm -v "$HOME/.vim/vimrc.old"
    rm -v "$HOME/.vim/vimrc"
    rm -v "$HOME/.vimrc.old"
    rm -v "$HOME/.vimrc"
fi

# --------------------------------------------------------------------------}}}

# tmux ---------------------------------------------------------------------{{{

echo
read -rp "$HOME/.config/tmux/tmux.conf? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [[ ! -d "$HOME/.config/tmux" ]]; then
        mkdir -p "$HOME/.config/tmux"
        chmod -cv 700 "$HOME/.config/tmux"
        rm -v "$HOME/.tmux.conf.old"
        mv -v "$HOME/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
    fi
    _deploy "$dotfiles_home_path/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
else
    rm -v "$HOME/.tmux.conf.old"
    rm -v "$HOME/.tmux.conf"
    rm -v "$HOME/.config/tmux/tmux.conf.old"
    rm -v "$HOME/.config/tmux/tmux.conf"
fi

# --------------------------------------------------------------------------}}}

# fontconfig ---------------------------------------------------------------{{{

echo
read -rp "$HOME/.config/fontconfig/fonts.conf? <Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    if [[ ! -d "$HOME/.config/fontconfig" ]]; then
        mkdir -p "$HOME/.config/fontconfig"
        chmod -cv 700 "$HOME/.config/fontconfig"
        rm -v "$HOME/.fonts.conf.old"
        mv -v "$HOME/.fonts.conf" "$HOME/.config/fontconfig/fonts.conf"
    fi
    _deploy "$dotfiles_home_path/.fonts.conf" "$HOME/.config/fontconfig/fonts.conf"
else
    rm -v "$HOME/.fonts.conf.old"
    rm -v "$HOME/.fonts.conf"
    rm -v "$HOME/.config/fontconfig/fonts.conf.old"
    rm -v "$HOME/.config/fontconfig/fonts.conf"
fi

# --------------------------------------------------------------------------}}}

# unset --------------------------------------------------------------------{{{

unset dotfiles_path
unset dotfiles_home_path

# --------------------------------------------------------------------------}}}
