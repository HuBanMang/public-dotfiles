# ZSh .zshrc ---------------------------------------------------------------{{{

# --------------------------------------------------------------------------}}}

# If not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

#zmodload zsh/zprof

# --------------------------------------------------------------------------}}}

# prompt -------------------------------------------------------------------{{{

autoload -Uz promptinit
promptinit
# colors
autoload -Uz colors && colors
#prompt clint

# set a simple prompt
prompt restore
setopt prompt_subst
PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%}%k"$'\n'
PROMPT+="[%#]: "
RPROMPT="[%? %L]"

# --------------------------------------------------------------------------}}}

# key mode -----------------------------------------------------------------{{{

# Turn off CTRL+S suspend session
stty -ixon
# Emacs/Readline keymode
bindkey -e

# vi keymode ---------------------------------------------------------------{{{

#bindkey -v
#KEYTIMEOUT=1
#zmodload zsh/complist
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-backward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#autoload -Uz surround
#zle -N delete-surround surround
#zle -N add-surround surround
#zle -N change-surround surround
#bindkey -M vicmd cs change-surround
#bindkey -M vicmd ds delete-surround
#bindkey -M vicmd ys add-surround
#bindkey -M vicmd S  add-surround

# --------------------------------------------------------------------------}}}

# --------------------------------------------------------------------------}}}

# history ------------------------------------------------------------------{{{

setopt histignorealldups sharehistory
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# search history
#[[ -n "${key[Up]}"      ]] && bindkey "${key[Up]}"      history-search-backward
#[[ -n "${key[Down]}"    ]] && bindkey "${key[Down]}"    history-search-forward

# --------------------------------------------------------------------------}}}

# completion ---------------------------------------------------------------{{{

autoload -Uz compinit
compinit

# comlete aliases
setopt completealiases

# newuser
#zstyle ':completion:*' auto-description '# %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format '# %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
#
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
#
## auto load $PATH
#zstyle ':completion:*' rehash true

# --------------------------------------------------------------------------}}}

# scripts_loaded -----------------------------------------------------------{{{

scripts_loaded=0
if [ $scripts_loaded -eq 1 ]; then
    uname -a
    uptime
    echo "zsh $ZSH_VERSION"
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
# zsh-autosuggestions zsh-syntax-highlighting
# autojump command-not-found

_load_shell_scripts() {
    # some example
    local newuser='/etc/zsh/newuser.zshrc.recommended'
    # zsh-autosuggestions
    if [ -r '/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' ]; then
        local zshautosug='/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
    elif [ -r '/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ]; then
        local zshautosug='/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    fi
    # zsh-syntax-highlighting
    if [ -r '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then
        local zshsyntax='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    elif [ -r '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then
        local zshsyntax='/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    fi
    # autojump
    local autojump='/usr/share/autojump/autojump.sh'
    # command-not-found     only zsh need source
    local commandnot='/etc/zsh_command_not_found'

    # scripts to load
    local shell_scripts=("$zshautosug" "$zshsyntax") # "$autojump" "$commandnot"
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
