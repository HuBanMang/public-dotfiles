# Shell environment.sh -----------------------------------------------------{{{

# 环境变量

# --------------------------------------------------------------------------}}}

# If not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# umask --------------------------------------------------------------------{{{

# -rw-r--r-- -rwxr-xr-x default
umask 0022

# -rw-r----- -rwxr-x---
#umask 0027

# --------------------------------------------------------------------------}}}

# path ---------------------------------------------------------------------{{{

# !!!应当在`.profile`中添加path而不是在`.*shrc`中添加!!!

_path_prepend() {
    #for ((i=$#; i>0; i--));
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

_path_append() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

# /etc/profile
#if [ "$(id -u)" -eq 0 ]; then
#    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#else
#    PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
#fi

# ~/.profile
# PATH=/path1:/path2${PATH:+:${PATH}}
#if [ -d "$HOME/.local/bin" ]; then
#    PATH="$HOME/.local/bin${PATH:+:${PATH}}"
#fi

# ~/.local/bin
if [ -d "$HOME/.local/bin" ]; then
    _path_prepend "$HOME/.local/bin"
fi
# 如果不在`.bash_profile`中添加`$HOME/.local/bin`PATH，
# 那么GNOME无法通过快捷键执行`$HOME/.local/bin`下的程序
# Debian默认添加该路径，Arch Linux默认不添加
#[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin${PATH:+":$PATH"}"

# dotfiles/shell/scripts/
if [ -d "$HOME/dotfiles/shell/scripts" ]; then
    _path_prepend "$HOME/dotfiles/shell/scripts"
elif [ -d "/dotfiles/shell/scripts" ]; then
    _path_prepend "/dotfiles/shell/scripts"
fi

#export PATH

# --------------------------------------------------------------------------}}}

# locale -------------------------------------------------------------------{{{

# - `LANG` 默认语言
#   - 所有未显式设置的 `LC_*` 变量会使用 `LANG` 的参数
#   - `C.UTF-8`: Computer bytes
# - `LANGUAGE` 缺省语言（桌面环境，图形界面等）
#   - 仅当 `LC_ALL` 和 `LANG` 没有被设置为 'C.UTF-8' 时生效
# - `LC_ALL` 格式（时间，单位等）
#   - `LC_ALL=C.UTF-8` 覆盖所有的 `LC_*` 设置

# !!!this is only for shell environment!!!
LANG='C.UTF-8'
LANGUAGE='C.UTF-8'
LC_ALL='C.UTF-8'

# --------------------------------------------------------------------------}}}

# color --------------------------------------------------------------------{{{

# real color depend on your terminal and theme
TERM=xterm-256color

# --------------------------------------------------------------------------}}}

# ssh ----------------------------------------------------------------------{{{

# Logout Timeout 1h
TMOUT=3600

# --------------------------------------------------------------------------}}}

# gpg ----------------------------------------------------------------------{{{

if [ -d "$HOME/.gnupg" ]; then
    export GPG_TTY=$(tty)
fi

# --------------------------------------------------------------------------}}}

# terminal proxy -----------------------------------------------------------{{{

# use aliases `proxyon`, `proxyoff`
#export http_proxy="socks5://127.0.0.1:1080"
#export https_proxy="socks5://127.0.0.1:1080"

# unset terminal proxy
#unset http_proxy
#unset https_proxy

# Proxychains
# sudo -e /etc/proxychains4.conf # socks5 127.0.0.1 1080
# proxychains git clone https://github.com/xxx/xxx.git
# proxychains curl/wget wikipedia.org
# proxychains ping google.com #(failed, ping ICMP proxychains TCP)

# curl
# vi ~/.curlrc # socks5="127.0.0.1:1080"
# curl -vx socks5://127.0.0.1:1080 https://google.com

# --------------------------------------------------------------------------}}}

# editors ------------------------------------------------------------------{{{

EDITOR='vim'
VISUAL='vim'
PAGER='less'
MANPAGER='nvim +Man!'

#export DOOMGITCONFIG=~/.gitconfig
#PATH+=:~/.config/emacs/bin

# --------------------------------------------------------------------------}}}

# ime ----------------------------------------------------------------------{{{

#GLFW_IM_MODULE=ibus

# --------------------------------------------------------------------------}}}

# rust ---------------------------------------------------------------------{{{

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# --------------------------------------------------------------------------}}}
