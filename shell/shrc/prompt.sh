# prompt.sh ----------------------------------------------------------------{{{

# 一个简单的prompt
# [hostname username dirs] (main *+>)
# [$]:

# 可以在git repo中显示仓库细节，但可能拖慢prompt速度，尤其是大仓库，如linux.git
# 使用_git_prompt_disable临时禁用git prompt
# 使用_git_prompt_enable临时启用git prompt

# 前置条件
#   git-prompt.sh

# --------------------------------------------------------------------------}}}

# If not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# _bash_simple_prompt() ----------------------------------------------------{{{

_bash_simple_prompt() {
    # Set a simple PS1
    unset PS1
    unset PROMPT_COMMAND
    PS1='\[\e[07;40;37m\][\h \u \w]\[\e[00m\]\n[\$]: '

    # Or use git-prompt
}
#_bash_simple_prompt

# --------------------------------------------------------------------------}}}

# _zsh_simple_prompt() -----------------------------------------------------{{{

_zsh_simple_prompt() {
    # prompt
    autoload -Uz promptinit
    promptinit
    # colors
    autoload -Uz colors && colors

    # Use builtin prompt
    #prompt clint

    # Or set a simple prompt
    setopt prompt_subst
    prompt restore
    unset PROMPT
    unset RPROMPT
    precmd() {
        PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k"$'\n'
        PROMPT+="[%#]: "
        RPROMPT="[%? %L]"
    }

    # Or use git-prompt or vcs-prompt
}
#_zsh_simple_prompt

# --------------------------------------------------------------------------}}}

# _git_prompt_setting() ----------------------------------------------------{{{

_git_prompt_setting() {
    # use git-prompt if have git-prompt
    # Arch: /usr/share/git/completion/git-prompt.sh
    # Debian: /usr/lib/git-core/git-sh-prompt
    # Fedora: /usr/share/git-core/contrib/completion/git-prompt.sh
    # Dotfiles: /dotfiles/shell/scripts/git-prompt.sh
    local git_prompt_sh_arch="/usr/share/git/completion/git-prompt.sh"
    local git_prompt_sh_debian="/usr/lib/git-core/git-sh-prompt"
    local git_prompt_sh_fedora="/usr/share/git-core/contrib/completion/git-prompt.sh"
    local git_prompt_sh_dotfiles="/dotfiles/shell/scripts/git-prompt.sh"

    local git_prompt_sh=""
    if [ -r "$git_prompt_sh_arch" ]; then
        git_prompt_sh="$git_prompt_sh_arch"
    elif [ -r "$git_prompt_sh_debian" ]; then
        git_prompt_sh="$git_prompt_sh_debian"
    elif [ -r "$git_prompt_sh_fedora" ]; then
        git_prompt_sh="$git_prompt_sh_fedora"
    elif [ -r "$git_prompt_sh_dotfiles" ]; then
        git_prompt_sh="$git_prompt_sh_dotfiles"
    else
        echo -e >&2 "\n\e[31m[ERROR]\e[0m: git-prompt.sh not found!\n"
        #exit 1
    fi

    if [ -n "$git_prompt_sh" ] && [ -r "$git_prompt_sh" ]; then
        . "$git_prompt_sh"
        # unstaged (*) staged (+)
        GIT_PS1_SHOWDIRTYSTATE=1
        # stashed ($)
        GIT_PS1_SHOWSTASHSTATE=1
        # untracked files (%)
        GIT_PS1_SHOWUNTRACKEDFILES=1
        # differ between HEAD and upstream
        # you are behind (<)
        # you are ahead (>)
        # you have diverged (<>)
        # no difference (=)
        GIT_PS1_SHOWUPSTREAM="auto"
        # more info
        GIT_PS1_DESCRIBE_STYLE=default
        # color
        GIT_PS1_SHOWCOLORHINTS=1
        # hide if ignored by git
        GIT_PS1_HIDE_IF_PWD_IGNORED=1
    else
        echo -e >&2 "\n\e[31m[ERROR]\e[0m: git-prompt.sh load failed!\n"
        #exit 1
    fi
}
#_git_prompt_setting

# --------------------------------------------------------------------------}}}

# _bash_git_prompt() -------------------------------------------------------{{{

# git-prompt will slow down prompt
_bash_git_prompt() {
    if _git_prompt_setting; then
        # color !only available by PROMPT_COMMAND in bash
        PROMPT_COMMAND='__git_ps1 '
        # string before git info
        PROMPT_COMMAND+='"\[\e[07;40;37m\][\h \u \w]\[\e[00m\]" '
        # string after git info
        PROMPT_COMMAND+='"\n[\$]: " '
        # git info
        PROMPT_COMMAND+='" (%s)"'
    else
        # simple-prompt to fallback
        _bash_simple_prompt
    fi
}
#_bash_git_prompt

# --------------------------------------------------------------------------}}}

# _zsh_git_prompt() --------------------------------------------------------{{{

# git-prompt will slow down prompt
_zsh_git_prompt() {
    if _git_prompt_setting; then
        prompt restore
        precmd() {
            PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k$(__git_ps1 " (%s)")"$'\n'
            PROMPT+="[%#]: "
            RPROMPT="[%? %L]"
        }
    else
        # simple-prompt for fallback
        _zsh_simple_prompt
    fi
}
#_zsh_git_prompt

# --------------------------------------------------------------------------}}}

# _zsh_vcs_prompt() --------------------------------------------------------{{{

# vcs-prompt will slow down prompt !!!not tested!!!
_zsh_vcs_prompt() {
    # simple-prompt for fallback
    _zsh_simple_prompt

    # version control system info
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git svn
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' unstagedstr ' *'
    zstyle ':vcs_info:*' stagedstr ' +'
    # %s    the vcs in use
    # %r    the repo name
    # %S    a subdir within a repo
    # %b    info about the current branch
    # %a    an identifier that describes the action(only in actionformats)
    # %m    misc
    # %u    the string from the unstagedstr
    # %c    the string from the stagedstr
    zstyle ':vcs_info:git*' formats "%s %r/%S %b%a %m%u%c"
    zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b|%a %m%u%c"
    # %b    the branch name
    # %r    the current revision number
    zstyle ':vcs_info:git*' branchformats "%b%r"
    # precmd
    precmd() {
        vcs_info
        if [[ -z ${vcs_info_msg_0_} ]]; then
            #PS1="%5~%# "
            PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k"$'\n'
            PROMPT+="[%#]: "
            RPROMPT="[%? %L]"
        else
            #PS1="%3~${vcs_info_msg_0_}%# "
            PROMPT="%K{white}%{$fg[black]%}[%m %n %1~]%{$reset_color%}%k${vcs_info_msg_0_}"$'\n'
            PROMPT+="[%#]: "
            RPROMPT="[%? %L]"
        fi
    }
}
#_zsh_vcs_prompt

# --------------------------------------------------------------------------}}}

# _login_info() ------------------------------------------------------------{{{

_login_info() {
    # "| Data 2000-01-01/01:01:00 "
    #echo -e "| Date $(date +%Y-%m-%d/%H:%M:%S) \c"
    echo "| Date   | $(date +%Y-%m-%d/%H:%M:%S)"
    # "| Up 10:00 | Users 1 | Load 0.01,0.01,0.01"
    # some error if up days
    #echo -e "$(uptime | awk '{print "| Up " $3 " | Users " $4 " | Load " $8$9$10 " | "}' | sed 's/,//') "
    #uptime | cut -f 3 -d ',' | cut -f 5 -d ' '
    #cat /proc/loadavg
    # very very very useful tips, life changing, XD
    if command -v fortune &>/dev/null && command -v cowsay &>/dev/null; then
        fortune | cowsay
    fi
}
# $(_login_info "%s")
#_login_info

# --------------------------------------------------------------------------}}}

# _git_prompt_enable() -----------------------------------------------------{{{

_git_prompt_enable() {
    #_login_info
    if [ -n "$BASH_VERSION" ]; then
        _bash_git_prompt
    elif [ -n "$ZSH_VERSION" ]; then
        _zsh_git_prompt
    else
        echo -e >&2 "\n\e[31m[ERROR]\e[0m: neither bash nor zsh, set shell prompt failed!\n"
        #exit 1
    fi
}
_git_prompt_enable

# --------------------------------------------------------------------------}}}

# _git_prompt_disable() ----------------------------------------------------{{{

_git_prompt_disable() {
    #_login_info
    if [ -n "$BASH_VERSION" ]; then
        _bash_simple_prompt
    elif [ -n "$ZSH_VERSION" ]; then
        _zsh_simple_prompt
    else
        echo -e >&2 "\n\e[31m[ERROR]\e[0m: neither bash nor zsh, set shell prompt failed!\n"
        #exit 1
    fi
}
#_git_prompt_disable

# --------------------------------------------------------------------------}}}
