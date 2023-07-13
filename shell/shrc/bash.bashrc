# Bash .bashrc -------------------------------------------------------------{{{

# --------------------------------------------------------------------------}}}

# If not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# PS1 ----------------------------------------------------------------------{{{

# Set a simple PS1
PS1='\[\e[07;40;37m\][\h \u \w]\[\e[00m\]\n[\$]: '

# --------------------------------------------------------------------------}}}

# keymode ------------------------------------------------------------------{{{

# Emacs/Readline keymode
set -o emacs
# Vi keymode
#set -o vi

# --------------------------------------------------------------------------}}}

# history ------------------------------------------------------------------{{{

# !!            expand to the last command
# !n            expand the command with history number 'n'
# !-n           expand to 'n' last command
# CTRL+R        search
# CTRL+S        search back (conflict with suspend the terminal session)
# CTRL+Q        unsuspend the session

# Turn off CTRL+S suspend session
stty -ixon

# ignoreboth=ignorespace, ignoredups
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# UP DOWN arrow search in history
#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'

# --------------------------------------------------------------------------}}}

# shopt --------------------------------------------------------------------{{{

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# autocd
shopt -s autocd

# --------------------------------------------------------------------------}}}

# some examples from bashrc.bfox -------------------------------------------{{{

# Don't make useless coredump files.  If you want a coredump,
# say "ulimit -c unlimited" and then cause a segmentation fault.
ulimit -c 0

# Set auto_resume if you want to resume on "emacs", as well as on
# "%emacs".
auto_resume=exact

# Set notify if you want to be asynchronously notified about background
# job completion.
set -o notify

# Make it so that failed `exec' commands don't flush this shell.
shopt -s execfail

# --------------------------------------------------------------------------}}}

# scripts_loaded -----------------------------------------------------------{{{

scripts_loaded=0
if [ $scripts_loaded -eq 1 ]; then
    uname -a
    uptime
    echo "bash $BASH_VERSION"
    echo "Scripts Loaded:"
fi

# _load_dotfiles_shell_shrc() ----------------------------------------------{{{

_load_dotfiles_shell_shrc() {
    if [ -d "$HOME/dotfiles/shell/shrc" ]; then
        local dotfiles_shrc_path="$HOME/dotfiles/shell/shrc"
    elif [ -d "/dotfiles/shell/shrc" ]; then
        local dotfiles_shrc_path="/dotfiles/shell/shrc"
    else
        echo -e >&2 "\e[31m[ERROR]\e[0m: dotfiles shrc path not found!\n"
        #exit 1
    fi

    if [ -d "$dotfiles_shrc_path" ]; then
        for i in "$dotfiles_shrc_path"/*.sh; do
            if [ -r "$i" ]; then
                . "$i"
                if [ $scripts_loaded -eq 1 ]; then
                    echo " $i"
                fi
            else
                echo -e >&2 "\e[31m[ERROR]\e[0m: failed to load $i\n"
            fi
        done
        unset i
    else
        echo -e >&2 "\e[31m[ERROR]\e[0m: $dotfiles_shrc_path is not a dir!\n"
    fi
}
_load_dotfiles_shell_shrc
#declare -F | grep _load
#unset -f _load_dotfiles_shell_shrc

# --------------------------------------------------------------------------}}}

# _load_shell_scripts() ----------------------------------------------------{{{

# recommand packages
# bash-doc bash-builtins bash-completion

_load_shell_scripts() {
    # some example from /etc/skel/.bashrc
    local newuser='/etc/skel/.bashrc'
    # bash-completion
    local bashcompletion='/etc/profile.d/bash_completion.sh'

    # scripts to load
    local shell_scripts=()
    # load scripts
    for script2load in "${shell_scripts[@]}"; do
        if [ -r "$script2load" ]; then
            . "$script2load"
            if [ $scripts_loaded -eq 1 ]; then
                echo " $script2load"
            fi
        fi
    done
    unset script2load
}
_load_shell_scripts
#declare -F | grep _load
#unset -f _load_shell_scripts

# --------------------------------------------------------------------------}}}

unset scripts_loaded

# --------------------------------------------------------------------------}}}
