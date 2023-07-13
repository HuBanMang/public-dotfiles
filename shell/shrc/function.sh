# Shell functions.sh -------------------------------------------------------{{{

# 常用函数

# --------------------------------------------------------------------------}}}

# If not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# aptitude search ----------------------------------------------------------{{{

f-aptitude-search-installed() {
    aptitude-search "~i ?name($1)"
}

# --------------------------------------------------------------------------}}}

# find in files ------------------------------------------------------------{{{

f-find-in-files() {
    find ./* -type f | xargs grep --color=always "$1" | less -R
}

# --------------------------------------------------------------------------}}}

# sed in files -------------------------------------------------------------{{{

f-sed-in-files() {
    sed -i "s/$1/$2/g" "$(grep "$1" -rl "*")"
}

# --------------------------------------------------------------------------}}}

# chmod format -------------------------------------------------------------{{{

f-chmod-format-755-644() {
    echo "chmod format: dir 755, file 644"
    find ./* -type d -exec chmod -c 755 {} \;
    find ./* -type f -exec chmod -c 644 {} \;
    #setfacl -bR .
}

f-chmod-format-750-640() {
    echo "chmod format: dir 750, file 640"
    find ./* -type d -exec chmod -c 750 {} \;
    find ./* -type f -exec chmod -c 640 {} \;
    #setfacl -bR .
}

f-chmod-format-700-600() {
    echo "chmod format: dir 700, file 600"
    find ./* -type d -exec chmod -c 700 {} \;
    find ./* -type f -exec chmod -c 600 {} \;
    #setfacl -bR .
}

# --------------------------------------------------------------------------}}}

# bookmark -----------------------------------------------------------------{{{

# firefox备份书签格式化，去除日期及无用链接等
f-bookmark-format() {
    unset ARG
    for ARG in "$@"
    do
        echo "python3 -m json.tool $ARG $ARG"
        python3 -m json.tool "$ARG" "$ARG"
        echo "sed -i '/guid\|dateAdded\|lastModified\|iconUri/d' $ARG"
        sed -i '/guid\|dateAdded\|lastModified\|iconUri/d' "$ARG"
    done
    unset ARG
}

# --------------------------------------------------------------------------}}}

# backup -------------------------------------------------------------------{{{

# rsync aliases 可以实现简单快速的备份

# backup-it
f-backup-it() {
    unset ARG
    for ARG in "$@"
    do
        echo "Backup $ARG to $HOME/.backup/"
        rsync -acrzP --delete-during --mkpath -hi "$ARG" "$HOME/.backup/$ARG-$(date +%Y-%m-%d-%H-%M)"
    done
    unset ARG
}

f-backup-find() {
    unset ARG
    for ARG in "$@"
    do
        #find "$HOME/.backup/" -type d -name "$ARG"
        #find "$HOME/.backup/" -type f -name "$ARG"
        find "$HOME/.backup/" -name "$ARG"
    done
    unset ARG
}

# --------------------------------------------------------------------------}}}

# printf -------------------------------------------------------------------{{{

# printf [WARING] [ERROR]
# Black         0;30    Dark Gray       1;30
# Red           0;31    Light Red       1;31
# Green         0;32    Light Green     1;32
# Orange        0;33    Yellow          1;33
# Blue          0;34    Light Blue      1;34
# Purple        0;35    Light Purple    1;35
# Cyan          0;36    Light Cyan      1;36
# Light Gray    0;37    White           1;37

f-printf-info() {
    echo -e "\e[32m[INFO]\e[0m\n"
    unset ARG
    for ARG in "$@"
    do
        echo -e "$ARG\n"
    done
    unset ARG
}
f-printf-warning() {
    echo -e "\e[33m[WARNING]\e[0m\n"
    unset ARG
    for ARG in "$@"
    do
        echo -e "$ARG\n"
    done
    unset ARG
}

f-printf-error() {
    echo -e >&2 "\e[31m[ERROR]\e[0m\n"
    unset ARG
    for ARG in "$@"
    do
        echo -e >&2 "$ARG\n"
    done
    unset ARG
}

# --------------------------------------------------------------------------}}}

# --------------------------------------------------------------------------{{{

# 测试shell加载时间，100ms/0.10s以上会有非常明显的延迟
f-time-shell() {
    echo
    echo "time /bin/bash --norc -i -c exit"
    time /bin/bash --norc -i -c exit
    echo
    echo "time /bin/bash -i -c exit"
    time /bin/bash -i -c exit
    echo
    echo "time /bin/zsh --norcs -i -c exit"
    time /bin/zsh --norcs -i -c exit
    echo
    echo "time /bin/zsh -i -c exit"
    time /bin/zsh -i -c exit
    echo
}

# --------------------------------------------------------------------------}}}
