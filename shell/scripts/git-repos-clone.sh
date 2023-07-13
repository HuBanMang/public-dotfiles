#!/bin/bash

# 在当前目录内克隆列表内的git仓库

# git repos clone ----------------------------------------------------------{{{

_git_repos_clone() {
    DIR=$(pwd)

    echo
    echo "bare repos"
    cat git-repos-bare-remote.txt
    echo
    echo "work repos"
    cat git-repos-work-remote.txt
    echo
    read -rp " Clone ALL repos? <Y/n> " prompt
    if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
        if [ ! -r git-repos-bare-remote.txt ] && [ ! -r git-repos-work-remote.txt ]; then
            echo -e >&2 "\n\e[31m[ERROR]\e[0m: repos list not found!\n"
        else
            echo
            while read -r LINE
            do
                echo
                echo "$LINE"
                git clone --bare --mirror "$LINE" "$DIR/$(basename "$LINE")"
            done < git-repos-bare-remote.txt
            echo
            while read -r LINE
            do
                echo
                echo "$LINE"
                git clone "$LINE" "$DIR/$(basename "$LINE" .git)"
                cd "$DIR" || exit
            done < git-repos-work-remote.txt
        fi
    fi

    cd "$DIR" || exit
    echo
    unset DIR
    unset LINE
}
_git_repos_clone

# --------------------------------------------------------------------------}}}
