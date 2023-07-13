# Dotfiles

在家目录或系统中统一维护一份dotfiles模板（如创建或软链目录`~/dotfiles` `/dotfiles`）并**按需加载**，这样可以在集中维护配置文件的同时不影响一些自定义或临时配置

- 将仓库内的配置文件复制或软链到`/etc`或`/home/username/`中等需要的位置
  - 如`sudo cp /dotfiles/pathto/vimrc /etc/vim/vimrc.local`
  - 如`ln -snfv ~/dotfiles/pathto/.bashrc ~/.bashrc`
- 或者在需要的配置文件中加载仓库内的配置
  - 如在`~/.bashrc`中加载（`source`）`~/dotfiles/pathto/alias.sh`
  - 如在`~/.config/git/config`中加载（`include.path`）`~/dotfiles/pathto/gitconfig`
  - 详见[`dotfiles/shell/home`](shell/home)
- 修改`dotfiles`的所有者、属组等权限，使其仅所有者可改（755/644）

## 更简单或更复杂的方法

- `github.io`上的[dotfiles](https://dotfiles.github.io/)页面
- `arch wiki`中的[dotfiles](https://wiki.archlinux.org/title/Dotfiles)页面

## 2022.10

- 汇总配置文件，作为`dotfiles`统一管理

## 2023.05

- 公开部分配置文件，方便在陌生机器上使用
