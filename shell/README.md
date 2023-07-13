# Shell

基本的[终端/图形]交互环境

`User --> Shell --> Kernel --> Hardware`

- 终端交互环境(CLI/TUI)
  - shell
    - `shrc/bash.bashrc`
    - `shrc/zsh.zshrc`
  - 提示符prompt，显示git状态
    - `shrc/prompt.sh`
      - `[Hostname Username path] (branch *=)`
      - `[$]:`
      - 禁用git提示符 `_git_prompt_disable`
      - 启用git提示符 `_git_prompt_enable`
  - 命令补全
    - bash
      - `bash-completion`
    - zsh
      - `zsh-completion`
      - `zsh-autosuggestions`
  - 命令别名
    - `shrc/alias.sh`
  - 环境变量
    - `shrc/environment.sh`
  - 常用函数
    - `shrc/function.sh`
  - 常用脚本
    - `scripts/*`
  - 文本编辑
    - `vim/vimrc`
  - 远程连接
    - `ssh/lan.sshconfig`
    - `ssh/wan.sshconfig`
  - 终端复用
    - `tmux/tmux.conf`
  - git
    - `*.gitconfig`

- 图形交互环境(GUI)
  - 字体配置
    - `fontconfig/fonts.conf`
