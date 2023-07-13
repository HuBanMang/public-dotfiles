# .zshrc

# ~/.zshrc

dotfiles_shrc="dotfiles/shell/shrc/zsh.zshrc"
if [ -r "$HOME/$dotfiles_shrc" ]; then
    source "$HOME/$dotfiles_shrc"
elif [ -r "/$dotfiles_shrc" ]; then
    source "/$dotfiles_shrc"
else
    echo -e >&2 "\e[31m[ERROR]\e[0m: $dotfiles_shrc not found!\n"
fi
unset dotfiles_shrc

# [custom]
