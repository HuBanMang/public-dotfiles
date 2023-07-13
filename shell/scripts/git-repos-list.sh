#!/bin/bash

# 在当前目录内递归寻找git仓库，并分类输出到仓库列表文件
# 根据仓库类型分为bare裸仓库(reponame.git)和work工作仓库(reponame/.git)

# git repos list -----------------------------------------------------------{{{

_git_repos_list() {
    DIR=$(pwd)
    echo
    echo "$DIR"
    find -L "$DIR" -type d -name "*?.git" | sort > git-repos-bare.txt
    find -L "$DIR" -type d -name ".git" | sort | sed "s/\/.git/\//g" > git-repos-work.txt

    echo
    read -rp " List bare repos? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        while read -r LINE
        do
            echo
            echo "$LINE"
            cd "$LINE" || exit
            git remote -v
            cd "$DIR" || exit
        done < git-repos-bare.txt
        echo
    fi

    echo
    read -rp " List work repos? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        while read -r LINE
        do
            echo
            echo "$LINE"
            cd "$LINE" || exit
            git remote -v
            cd "$DIR" || exit
        done < git-repos-work.txt
        echo
    fi

    cd "$DIR" || exit
    echo
    #rm -fv git-repos-bare.txt git-repos-work.txt
    unset DIR
    unset LINE
}
_git_repos_list

# --------------------------------------------------------------------------}}}
