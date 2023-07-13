#!/bin/bash

# 复制博客文件到新目录并推送

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
    local pubdir="$(pwd)/../public-blog"
    if [ -d "$pubdir" ]; then
        echo "rm -rf $pubdir"
        rm -rf "$pubdir"
    fi
    mkdir -pv "$pubdir"

    # cp
    cp -rLu * .* "$pubdir"

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
    git remote add github git@github:HuBanMang/HuBanMang.github.io.git
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
