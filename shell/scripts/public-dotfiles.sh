#!/bin/bash

# 复制配置文件的公开部分到新目录并推送

# 前置条件
#   dotfiles

# dotfiles -----------------------------------------------------------------{{{

if [ -d "$HOME/dotfiles" ]; then
    dotfiles_path="$HOME/dotfiles"
elif [ -d "/dotfiles" ]; then
    dotfiles_path="/dotfiles"
else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: dotfiles not found!\n"
    exit 1
fi
echo
echo "dotfiles path: $dotfiles_path"
echo

# --------------------------------------------------------------------------}}}

# _deploy ------------------------------------------------------------------{{{

_deploy() {
    # mkdir
    local pubdir="$(pwd)/../public-dot"
    if [ -d "$pubdir" ]; then
        echo "rm -rf $pubdir"
        rm -rf "$pubdir"
    fi
    mkdir -pv "$pubdir"

    # cp
    local cp_dirs=("shell" "system" "README.md")
    for cp_dir in "${cp_dirs[@]}"; do
        if [ -r "$dotfiles_path/$cp_dir" ]; then
            echo
            echo "cp -rLu $dotfiles_path/$cp_dir $pubdir"
            echo
            cp -rLu "$dotfiles_path/$cp_dir" "$pubdir"
        else
            echo -e "\n\e[31m[ERROR]\e[0m: $dotfiles_path/$cp_dir unreadable!\n"
        fi
    done
    unset cp_dirs
    unset cp_dir

    # cd
    cd "$pubdir" || exit

    # git
    echo
    if [ -d ".git" ]; then
        echo "rm -rf .git"
        rm -rf ".git"
    fi
    git init
    git add --all
    if [ -d "$HOME/.gnupg" ]; then
        echo
        read -rp "git commit -S? <Y/n> " prompt
        if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
            git commit --all -S -m "."
        else
            git commit --all -m "."
        fi
    else
        git commit --all -m "."
    fi
    git remote add github git@github:HuBanMang/dot.git
    echo
    echo "git push github main -f -n"
    git push github main -f -n
    echo
    read -rp "git push github main -f? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        git push github main -f
    fi
    echo
    if [ -d "$pubdir" ]; then
        echo "rm -rf $pubdir"
        rm -rf "$pubdir"
    fi
}
_deploy

# --------------------------------------------------------------------------}}}
