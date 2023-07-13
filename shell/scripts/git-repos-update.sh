#!/bin/bash

# 在当前目录内递归更新(fetch)git仓库
# 注意：
# 更新前应先生成仓库列表文件，更新后删除
# 更新仅执行fetch操作，工作仓库不会覆盖工作区，但裸仓库会覆盖索引区

# git repos update ---------------------------------------------------------{{{

_git_repos_update() {
    DIR=$(pwd)
    find -L "$DIR" -type d -name "*?.git" | sort > git-repos-bare.txt
    find -L "$DIR" -type d -name ".git" | sort | sed "s/\/.git/\//g" > git-repos-work.txt

    if [ ! -r git-repos-bare.txt ] || [ ! -r git-repos-work.txt ]; then
        echo -e >&2 "\n\e[31m[ERROR]\e[0m: repos list not found!\n"
        echo >&2 "use git-repos-list.sh to generate"
        exit 1
    fi

    #echo
    #echo "Refer Repos List:"
    #cat git-refer-bare.txt git-refer-work.txt
    #echo
    #read -rp "Update Refer repos? <Y/n> " prompt
    #if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
    #    while read LINE
    #    do
    #        echo
    #        echo $LINE
    #        cd "$LINE" || exit
    #        git remote -v
    #        git fetch
    #        cd "$DIR" || exit
    #    done < git-refer-bare.txt

    #    while read LINE
    #    do
    #        echo
    #        echo $LINE
    #        cd "$LINE" || exit
    #        git remote -v
    #        git fetch
    #        #git pull
    #        git submodule update
    #        cd "$DIR" || exit
    #    done < git-refer-work.txt
    #fi

    echo "ALL Repos List:"
    cat git-repos-bare.txt git-repos-work.txt
    echo
    read -rp "Update ALL repos? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        while read -r LINE
        do
            echo
            echo "$LINE"
            cd "$LINE" || exit
            git remote -v
            git fetch
            cd "$DIR" || exit
        done < git-repos-bare.txt

        while read -r LINE
        do
            echo
            echo "$LINE"
            cd "$LINE" || exit
            git remote -v
            git fetch
            #git pull
            git submodule update
            cd "$DIR" || exit
        done < git-repos-work.txt
    fi

    cd "$DIR" || exit
    echo
    rm -fv git-repos-bare.txt git-repos-work.txt
    #rm -fv git-refer-bare.txt git-refer-work.txt
    unset DIR
    unset LINE
}
_git_repos_update

# --------------------------------------------------------------------------}}}
