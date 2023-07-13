#!/bin/bash

# 在当前目录内递归寻找git仓库，并将remote链接分类输出到仓库列表文件

# git repos remote ---------------------------------------------------------{{{

_git_repos_remote() {
    DIR=$(pwd)
    find -L "$DIR" -type d -name "*?.git" | sort > "$DIR"/git-repos-bare.txt
    find -L "$DIR" -type d -name ".git" | sort | sed "s/\/.git/\//g" > "$DIR"/git-repos-work.txt

    echo
    read -rp " Get bare repos links? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        rm -fv "$DIR"/git-repos-bare-remote.txt
        while read -r LINE
        do
            echo
            echo "$LINE"
            cd "$LINE" || exit
            git remote -v
            git remote get-url origin >> "$DIR"/git-repos-bare-remote.txt
            cd "$DIR" || exit
        done < "$DIR"/git-repos-bare.txt
        echo
    fi

    echo
    read -rp " Get work repos links? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        rm -fv "$DIR"/git-repos-work-remote.txt
        while read -r LINE
        do
            echo
            echo "$LINE"
            cd "$LINE" || exit
            git remote -v
            git remote get-url origin >> "$DIR"/git-repos-work-remote.txt
            cd "$DIR" || exit
        done < "$DIR"/git-repos-work.txt
        echo
    fi

    cd "$DIR" || exit
    echo
    unset DIR
    unset LINE
}
_git_repos_remote

# --------------------------------------------------------------------------}}}
