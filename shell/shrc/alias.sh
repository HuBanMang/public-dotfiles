# Shell alias.sh -----------------------------------------------------------{{{

# 一些别名
# 别名尽可能不覆盖原名
# 别名命名尽可能贴近原命令参数
# 别名命名过长时尽可能方便使用<Tab>补全（首字母不同）
# 有一些别名并不使用，仅作备忘

# 根本想不起来用alias

# --------------------------------------------------------------------------}}}

# If not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# standard -----------------------------------------------------------------{{{

# system -------------------------------------------------------------------{{{

alias sudo='sudo '
alias sudoe='EDITOR=vim sudo -e '
alias sudo-update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# --------------------------------------------------------------------------}}}

# safe overwrite -----------------------------------------------------------{{{

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# --------------------------------------------------------------------------}}}

# enable color support -----------------------------------------------------{{{

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --color --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# --------------------------------------------------------------------------}}}

# some more ls aliases -----------------------------------------------------{{{

alias la='ls -AF'
alias ll='ls -lAF'
alias l='ls -CF'
alias lls='ll -sS'              # sort by size
alias llx='ll -XB'              # sort by extension
alias lln='ll -n'               # list numeric user/group id
alias lli='ll -i'               # list inode
alias llz='ll -Z'               # print security context
alias llt='ll -t --full-time'               # sort by modification time
alias llta='ll --time=atime --full-time'    # sort by access time
alias lltc='ll --time=ctime --full-time'    # sort by change time
alias lltb='ll --time=birth --full-time'    # sort by birth time
# find . -inum 12345 -exec vi {} \;

# --------------------------------------------------------------------------}}}

# short --------------------------------------------------------------------{{{

# cd ..
alias ..='cd ..'
alias ...='cd .. && cd ..'

alias e='exit'

# --------------------------------------------------------------------------}}}

# human output -------------------------------------------------------------{{{

# 人类易读的输出
alias echopath='echo -e ${PATH//:/\\n}'
# 
alias duh='du -hxd 1'
alias du1='du -mxd 1 | sort -n'
alias du2='du -mxd 2 | sort -n'
alias dfh='df -hT'
alias dfa='df -hTa'
alias dfi='df -hTi'
alias psf='ps -flyj --forest'
alias psfe='ps -flyj --forest -e'
alias ipa='ip -color a'
alias lessr='less -R'
# 一些更现代化的命令行工具
# btop(top) ripgrep(grep) fd-find(find) fzf tldr(man)
alias fd='fdfind'

# --------------------------------------------------------------------------}}}

# text ---------------------------------------------------------------------{{{

alias findin='f-find-in-files'
alias sedin='f-sed-in-files'

# --------------------------------------------------------------------------}}}

# --------------------------------------------------------------------------}}}

# GUI ----------------------------------------------------------------------{{{

# 设置系统启动时不启动到图形界面，手动启动(GDM/SDDM)
# sudo systemctl get-default
# sudo systemctl set-default multi-user.target

# GNOME
alias gdmstart='sudo systemctl start gdm'

# KDE startplasma-wayland
alias sddmstart='sudo systemctl start sddm'

alias xo='xdg-open'

# GIO
alias gtrash='gio trash'
alias gtree='gio tree'

# --------------------------------------------------------------------------}}}

# debian apt ---------------------------------------------------------------{{{

# aptitude
# 搜索输出格式
# %c    Current State Flag
#   i   package installed
#   p   package not installed
#   c   package was removed but config files not purged
#   v   virtual package
#   B   package has broken dependencies
#   u   package has been unpacked but not configured
#   C   package half-configured/interrupted
#   H   package half-installed/interrupted
#   W   triggers-awaited
#   T   triggers-pending
# %a    Action Flag
#   i   package will be installed
#   u   package will be upgraded
#   d   package will be deleted, removed but config remain
#   p   package will be purged
#   h   package will be held back
#   r   package will be reinstalled
#   F   package upgrade has been forbidden
#   B   package is broken
# %M    Automatic Flag
#   A   package was Automatically installed
# %S    Trust Status
# %p    Package Name
# %E    Architecture
# %R    Abbreviated Priority
# %s    Section
# %t    Archive
# %v    Current Version
# %V    Candidate Version
# %D    Package Size
alias aptitude-search='aptitude search -F "%c%a%M%S %p %E %R  %s  %t %v %V %D" '

# 搜索项
# Long form         Short form      Description
# ?=variable                        packages bound to `variable`
# ?not(pattern)     !pattern        packages not match `pattern
# ?and(pa1, pa2)    pa1 pa2         packages matches both `pattern1` and `pattern2`
# ?or(pa1, pa2)     pa1 | pa2
# ?architecture(a)  ~rarch          packages for given architecture (amd64, i386, all)
# ?archive(a)       ~Aarchive       packages from given archive (unstable, testing)
# ?automatic        ~M              packages automatically installed
# ?config-files     ~c              packages were removed but not purged
# ?garbage          ~g              packages not required by any manually installed package
# ?installed        ~i              packages installed
# ?obsolete         ~o              packages installed but can not be downloaded
# ?upgradable       ~U              packages installed and upgradable
# ?essential        ~E              essential packages
# ?virtual          ~v              virtual packages
# ?section(se)      ~ssection       packages in given `section`
# ?broken           ~b              packages have a broken dependency
# ?broken-depType   ~BdepType       packages have a broken dependency of the given `depType`
# ?depType(pa)                  ~D[depType:]pattern     列出符合条件的包的父节点
# ?reverse-depType(pa)          ~R[depType:]pattern     列出符合条件的包的子节点
# ?broken-depType(pa)           ~DB[depType:]pattern    列出符合条件的包缺失的父节点（手动安装的包不需要关注其父节点）
# ?reverse-broken-depType(pa)   ~RB[depType:]pattern    列出符合条件的包缺失的子节点
# 例如：gnome depends:gnome-core, gnome-core depends:gdm3, gnome --> gnome-core --> gdm3
# ~Ddepends:gnome-core          列出依赖gnome-core的包, gnome
# ~Rdepends:gnome-core          列出gnome-core依赖的包, gdm3
# ~DBrecommends:gnome-core      列出推荐gnome-core但缺失的包
# ~RBrecommends:gnome-core      列出gnome-core推荐但缺失的包

# 搜索手动安装的包 与apt-mark showmanual相比去掉了系统安装的包
alias aptitude-showmanual='aptitude-search "~i !~M !~E !~prequired !~pimportant !~pstandard"'
# apt-mark minimize-manual && apt-mark showmanual

# 搜索config未清理的包
alias aptitude-config-files='aptitude-search "~c"'
alias sudo-aptitude-purge-config-files='sudo aptitude purge "~c"'

# 搜索无用的/不再被手动安装的包所依赖的包
alias aptitude-garbage='aptitude-search "~g"'
alias sudo-aptitude-purge-garbage='sudo aptitude purge "~g"'

# 搜索无法再下载的包
alias aptitude-obsolete='aptitude-search "~o"'
alias sudo-aptitude-purge-obsolete='sudo aptitude purge "~o"'

# 搜索已安装的包所推荐但缺失的包
alias aptitude-missing-recommends='aptitude-search "~RBrecommends:~i"'
alias sudo-aptitude-install-missing-recommends='sudo aptitude install "~RBrecommends:~i"'

# 搜索某分支的包
alias aptitude-stable='aptitude-search "~i ~Astable"'
alias aptitude-testing='aptitude-search "~i ~Atesting"'
alias aptitude-unstable='aptitude-search "~i ~Aunstable !~Atesting"'

# 搜索某架构的包
alias aptitude-arch-i386='aptitude-search "~i ~ri386"'

# 警告
alias aptitude-warning='aptitude-search "~c | ~g | ~o | ~RBrecommends:~i"'

# 升级
# upgrade/safe-upgrade 更新时不会删除旧包或安装新包
alias sudo-aptitude-safeupgrade='w -i \
    && sudo aptitude update \
    && sudo aptitude safe-upgrade -vVDZ \
    && sudo aptitude autoclean \
    && sudo apt-mark minimize-manual \
    && aptitude-showmanual \
    | sudo tee /root/showmanual-$(date +%Y-%m-%d-%H-%M).txt \
    > /dev/null'

alias sas='sudo-aptitude-safeupgrade'

# full-upgrade 更新时会为了满足依赖删除旧包或安装新包
alias sudo-aptitude-fullupgrade='w -i \
    && sudo aptitude update \
    && sudo aptitude full-upgrade -vVDZ \
    && sudo aptitude autoclean \
    && sudo apt-mark minimize-manual \
    && aptitude-showmanual \
    | sudo tee /root/showmanual-$(date +%Y-%m-%d-%H-%M).txt \
    > /dev/null'

alias saf='sudo-aptitude-fullupgrade'

# unattended upgrade 无人值守更新 测试
alias sudo-unattended-upgrade-debug='sudo unattended-upgrade -d --dry-run'

# packagekit upgrade (cockpit)
alias sudo-pkcon-upgrade='uptime && who -a -H \
    && sudo pkcon refresh \
    && sudo pkcon get-updates \
    && sudo pkcon update'

# 其他一些更好看的apt前端
# nala

# --------------------------------------------------------------------------}}}

# arch pacman --------------------------------------------------------------{{{

alias pacman-search='pacman -Ss '
alias pacman-show='pacman -Si '
alias pacman-showmanual='pacman -Qe '
alias pacman-check='pacman -Dk '

alias sudo-pacman-search='sudo pacman -Syy && pacman -Ss '
alias sps='sudo-pacman-search'

alias sudo-pacman-upgrade='w -i \
    && sudo pacman -Syu \
    && pacman -Dk \
    && pacman -Qe \
    | sudo tee /root/showmanual-$(date +%Y-%m-%d-%H-%M).txt \
    > /dev/null'

alias spu='sudo-pacman-upgrade'

alias sudo-pacman-install='sudo pacman -Syu && sudo pacman --needed -S '
alias spi='sudo-pacman-install '

alias sudo-pacman-remove='sudo pacman -Rns '
alias spr='sudo-pacman-remove '

alias sudo-pacman-autoremove='sudo pacman -Qdqt | sudo pacman -Rns - '
alias sudo-pacman-clean='sudo pacman -Scc '

# --------------------------------------------------------------------------}}}

# proxy --------------------------------------------------------------------{{{

alias proxyc='proxychains'

alias proxyon='export http_proxy=http://127.0.0.1:1080; \
    export https_proxy=http://127.0.0.1:1080; \
    export all_proxy=socks://127.0.0.1:1080; \
    export no_proxy=127.0.0.1; \
    echo "Proxy ON 127.0.0.1:1080";'

alias proxyon-lan='export http_proxy=http://10.0.0.10:1080; \
    export https_proxy=http://10.0.0.10:1080; \
    export all_proxy=socks://10.0.0.10:1080; \
    export no_proxy=127.0.0.1; \
    echo "Proxy ON 10.0.0.10:1080";'

alias proxyoff='unset http_proxy; \
    unset https_proxy; \
    unset all_proxy; \
    unset no_proxy; \
    echo "Proxy OFF";'

# --------------------------------------------------------------------------}}}

# network ------------------------------------------------------------------{{{

# debian etherwake wakeonlan
#alias wol=wakeonlan

# --------------------------------------------------------------------------}}}

# monitor ------------------------------------------------------------------{{{

# temperature lm-sensors
alias watch-sensors='watch -d -n 2 sensors'
alias watch-fan='watch -d -n 2 "sensors | grep -E \"(Package|fan)\""'

# --------------------------------------------------------------------------}}}

# tmux ---------------------------------------------------------------------{{{

# tmux
alias tm='tmux'
# tmux ls
alias tml='tmux ls'
# tmux attach target
alias tma='tmux attach '
# tmux new target
alias tmn='tmux new '
# tmux new session and detach it, prefix (, prefix )
alias tmnd='tmux new -d '

# --------------------------------------------------------------------------}}}

# editors ------------------------------------------------------------------{{{

alias vi='vim'
alias viu='vim -Nu NONE'
alias vix='vim -x'
alias vitodo='vim ./TODO'
alias vireadme='vim ./README.md'
alias nv='nvim'
alias em='emacs'
alias emq='emacs -Q'
alias en='emacs -nw'
alias es='emacs --daemon'
alias ec='emacsclient -t -a ""'
alias ec-kill-server='emacsclient --eval "(save-buffers-kill-emacs)"'
alias sec='sudo emacsclient -t -a ""'
alias doom='export DOOMGITCONFIG=~/.gitconfig \
    && ~/.config/emacs/bin/doom'

# --------------------------------------------------------------------------}}}

# virtualization  ----------------------------------------------------------{{{

alias vm='virt-manager'
alias vv='virt-viewer'
#alias docker='podman'

# --------------------------------------------------------------------------}}}

# gpg ----------------------------------------------------------------------{{{

# gpg --full-gen-key
alias gpg-ll='gpg --list-secret-keys --keyid-format=long'
# gpg --armor --export <sec ID>

# --------------------------------------------------------------------------}}}

# git ----------------------------------------------------------------------{{{

# add
alias gad='git add .'
# status
alias gst='git status -bs'
# switch
alias gsw='git switch'
# commit add
alias gca='git commit -a'
# commit sign
alias gcs='git commit -S'
# remote
alias grv='git remote -v'
# fetch
alias gfe='git fetch'
# pull
alias gpl='git pull'
# push
alias gps='git push'
# clean untracking files and folders
alias gcl='git clean -fdx'
# diff Working dir and Staging area
alias gdf='git diff'
# diff Staging area and Repo
alias gdfs='git diff --staged'
# diff HEAD~1
alias gdf1='git diff HEAD~1'
# diff HEAD~2
alias gdf2='git diff HEAD~2'
# view a commit
alias gsh='git show'
# reflog
alias gref='git reflog'
# log graph
alias glg='git log --graph --text'
# log oneline
alias glgo='git log --oneline --graph --text'
# log all
alias glga='git log --oneline --graph --text --all'
# log diff line numbers
alias glgs='git log --oneline --graph --stat'
# log diff line numbers all commits
alias glgsa='git log --oneline --graph --stat --all'
# log diff detail
alias glgp='git log --oneline --graph --patch'
# more aliases
# git config --global include.path /path/to/alias.gitconfig
# enable/disable git prompt
alias git-prompt-enable='_git_prompt_enable'
alias git-prompt-disable='_git_prompt_disable'

# --------------------------------------------------------------------------}}}

# rsync --------------------------------------------------------------------{{{

# rsync                         同步 源目录/ --> 目标目录/ 是将两个目录下内容同步
#                               同步 源目录 --> 目标目录 是同步源目录到目标目录下
# -a                            --archive, = -rlptgoD(no -AXUNH), 存档模式同步
# 注：只有拥有修改权限才能同步源文件所有权等信息到目标文件
# --acls, -A                    保存ACLs
# --xattrs, -X                  保存extended attributes
# --atimes, -U                  保存access (use) times
# --crtimes, -N                 保存create times (newness)
# --hard-links, -H              保存hard links
# --sparse, -S                  turn sequences of nulls into sparse blocks
# --append-verify               从中断处继续传输，完成后校验
# -b                            --backup, 如果删除或更新目标目录中文件，备份
# --backup-dir                  备份路径
# -c                            --checksum, 检查校验和，而非文件大小和日期
# --delete                      删除，如果文件在源目录中不存在而目标目录存在
# --delete-during               同步时删除，可以配合增量递归减少内存使用，默认
# --exclude                     指定排除不进行同步的文件
# -h                            --human-readable, 人类可读的输出
# -i                            --itemize-changes, 输出文件差异详细情况
# --ignore-non-existing         忽略目标目录中不存在的文件，只更新已存在的文件
# --include                     指定同步的文件
# --link-dest                   指定增量备份的基准目录
# -m                            --prune-empty-dirs, 不同步空目录
# --mkpath                      创建多级目标目录
# -n                            --dry-run, 模拟执行，-v查看
# --progress                    显示进度
# -P                            --partial --progress, 断点续传并显示进度
# -r                            --recursive, 默认增量递归，减少内存使用
# --remove-source-files         传输完成后，删除源目录文件
# -u                            --update, 更新，即跳过目标目录中修改时间更新的文件
# -v -vv -vvv                   显示输出信息，更详细，最详细的信息
# -x                            --one-file-system，不备份挂载文件系统
# -z                            --compress, 同步时压缩数据

# 测试同步 (a^,b^,c^_old) --> (a,b,c_new,d) = (a^,b^,c_new,d)
alias rsync-test-update='rsync -n -acuzP --mkpath -hi'
# 测试同步 (a^,b^,c^) --> (a,b,d) = (a^,b^,c^)
alias rsync-test-update-delete='rsync -n -acuzP --delete --mkpath -hi'
# 测试同步 (a^,b^,c^) --> (a,b,d) = (a^,b^,d)
alias rsync-test-update-ignore='rsync -n -acuzP --ignore-non-existing --mkpath -hi'
# 测试同步 (a^_old,b^,c^) --> (a_new,b,d) = (a^_old,b^,c^,d)
alias rsync-test-override='rsync -n -aczP --mkpath -hi'
# 测试备份当前目录(pwd)到
alias rsync-test-backup-pwd-to='rsync -n -aczP --delete --mkpath -hi $(pwd) '

# 实施同步
alias rsync-update='rsync -acuzP --mkpath -hi'
alias rsync-update-delete='rsync -acuzP --delete --mkpath -hi'
alias rsync-update-ignore='rsync -acuzP --ignore-non-existing --mkpath -hi'
alias rsync-override='rsync -aczP --mkpath -hi'

# backup
alias rsync-backup-pwd-to='rsync -acuzP --delete --mkpath -hi $(pwd) '
alias rsync-backup-system-to='rsync -acuxzPAXUNHS --delete --mkpath -hi --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / '
alias rsync-restore-system-to='rsync -acuxzPAXUNHS --delete --mkpath -hi --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} '

# sudo 测试同步
alias sudo-rsync-test-update='sudo rsync -n -acuzP --mkpath -hi'
alias sudo-rsync-test-update-delete='sudo rsync -n -acuzP --delete --mkpath -hi'
alias sudo-rsync-test-update-ignore='sudo rsync -n -acuzP --ignore-non-existing --mkpath -hi'
alias sudo-rsync-test-override='sudo rsync -n -aczP --mkpath -hi'
alias sudo-rsync-test-backup-pwd-to='sudo rsync -n -aczP --delete --mkpath -hi $(pwd) '

# sudo 实施同步
alias sudo-rsync-update='sudo rsync -acuzP --mkpath -hi'
alias sudo-rsync-update-delete='sudo rsync -acuzP --delete --mkpath -hi'
alias sudo-rsync-update-ignore='sudo rsync -acuzP --ignore-non-existing --mkpath -hi'
alias sudo-rsync-override='sudo rsync -aczP --mkpath -hi'
alias sudo-rsync-backup-pwd-to='sudo rsync -aczP --delete --mkpath -hi $(pwd) '

# --------------------------------------------------------------------------}}}

# Backup -------------------------------------------------------------------{{{

alias backup-pwd='echo "Backup $(pwd) to $HOME/.backup/" \
    && rsync -aczP --delete --mkpath -hi \
    $(pwd) \
    $HOME/.backup/$(basename $(pwd))-$(date +%Y-%m-%d-%H-%M)'

alias backup-pwd-to='rsync-backup-pwd-to'
alias backup-list='ll $HOME/.backup'

# 按更细分的时间备份
alias backup-by-year='echo "Backup $(pwd) by year" \
    && rsync -aczP --delete --mkpath -hi \
    $(pwd) \
    $HOME/.backup/$(basename $(pwd))-$(date +%Y)'

alias backup-by-month='echo "Backup $(pwd) by month" \
    && rsync -aczP --delete --mkpath -hi \
    $(pwd) \
    $HOME/.backup/$(basename $(pwd))-$(date +%Y-%m)'

alias backup-by-day='echo "Backup $(pwd) by day" \
    && rsync -aczP --delete --mkpath -hi \
    $(pwd) \
    $HOME/.backup/$(basename $(pwd))-$(date +%Y-%m-%d)'

alias backup-by-hour='echo "Backup $(pwd) by hour" \
    && rsync -aczP --delete --mkpath -hi \
    $(pwd) \
    $HOME/.backup/$(basename $(pwd))-$(date +%Y-%m-%d-%H)'

alias backup-by-minute='echo "Backup $(pwd) by minute" \
    && rsync -aczP --delete --mkpath -hi \
    $(pwd) \
    $HOME/.backup/$(basename $(pwd))-$(date +%Y-%m-%d-%H-%M)'

# --------------------------------------------------------------------------}}}

# date ---------------------------------------------------------------------{{{

alias date-day="date +%Y-%m-%d"
alias date-min="date +%Y-%m-%d-%H-%M"
alias date-sec="date +%Y-%m-%d-%H-%M-%S"

# --------------------------------------------------------------------------}}}

# gcc/g++ ------------------------------------------------------------------{{{

alias gcc-s='gcc -S '
alias gcc-asan='gcc -fsanitize=address -fno-omit-frame-pointer '
alias g++-s='g++ -S '
alias g++-asan='g++ -fsanitize=address -fno-omit-frame-pointer '

# --------------------------------------------------------------------------}}}

# make ---------------------------------------------------------------------{{{

alias make-menuconfig='make-menuconfig'
alias make-mrproper='make mrproper'

# --------------------------------------------------------------------------}}}

# cmake --------------------------------------------------------------------{{{

alias cmake-compile-commands='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1'

# --------------------------------------------------------------------------}}}

# valgrind -----------------------------------------------------------------{{{

alias valgrind-leak-all='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes '
alias valgrind-cachegrind='valgrind --tool=cachegrind '
alias valgrind-massif='valgrind --tool=massif --stacks=yes '

# --------------------------------------------------------------------------}}}

# format -------------------------------------------------------------------{{{

alias clang-format-file-test='clang-format --style=file --dry-run '
alias clang-format-file-inplace='clang-format --style=file -i '

# --------------------------------------------------------------------------}}}

# python -------------------------------------------------------------------{{{

# python3 is the default option after debian11
alias python='python3'

# --------------------------------------------------------------------------}}}

# pandoc -------------------------------------------------------------------{{{

#eval "$(pandoc --bash-completion)"
alias pandoc-pdf='pandoc --pdf-engine=xelatex \
    -V mainfont="Noto Serif CJK SC" \
    -V sansfont="Noto Sans CJK SC" \
    -V monofont="Noto Sans Mono" \
    -V CJKmainfont="Noto Serif CJK SC" \
    -V CJKsansfont="Noto Sans CJK SC" \
    -V CJKmonofont="Noto Sans Mono" '

# --------------------------------------------------------------------------}}}

# Latex Clean --------------------------------------------------------------{{{

alias xelatex-clean='rm -rfv *.toc *.vrb *.aux *.log *.nav *.out *.snm *.synctex.gz'

# --------------------------------------------------------------------------}}}
