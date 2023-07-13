#!/bin/bash

# 设置GNOME常用快捷键

# _gsetting_customkeys() ---------------------------------------------------{{{

_gsetting_customkeys() {
    # 大写锁定键作为<CTRL>键使用
    gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

    # 截屏
    gsettings set org.gnome.shell.keybindings screenshot "['<Super>p']"
    gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt><Super>p']"
    gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>p']"

    # 保留<Super>Tab切换应用程序，但去除<Alt>Tab给切换窗口使用
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"

    # 保留<Super>Above_Tab切换同一应用程序窗口，但去除<Alt>Above_Tab留作他用
    gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>Above_Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Shift><Super>Above_Tab']"

    # 使用<Alt>Tab切换窗口
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

    # 关闭窗口 <Alt>F4
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']"

    # 显示桌面
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

    # 全屏 F11
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>Return']"

    # 应用程序快捷键 <Control><Alt>[]
    # 0Quake 1Terminal 2File 3Web 4Browser 5Proxy 6Editor 7Monitor 8Dictionary
    gcustomkeys="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
    gsetcustomkeys="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$gcustomkeys"
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[
    '$gcustomkeys/custom0/',
    '$gcustomkeys/custom1/',
    '$gcustomkeys/custom2/',
    '$gcustomkeys/custom3/',
    '$gcustomkeys/custom4/',
    '$gcustomkeys/custom5/',
    '$gcustomkeys/custom6/',
    '$gcustomkeys/custom7/',
    '$gcustomkeys/custom8/',
    '$gcustomkeys/custom9/'
    ]"

    # custom0 0Quake mode Terminal
    gsettings set $gsetcustomkeys/custom0/ name '0Quake'
    gsettings set $gsetcustomkeys/custom0/ command ''
    gsettings set $gsetcustomkeys/custom0/ binding '' #'<Alt>Above_Tab'
    # custom1 1Terminal
    gsettings set $gsetcustomkeys/custom1/ name '1Terminal'
    gsettings set $gsetcustomkeys/custom1/ command 'gnome-terminal'
    gsettings set $gsetcustomkeys/custom1/ binding '<Control><Alt>t'
    # custom2 2File
    gsettings set $gsetcustomkeys/custom2/ name '2File'
    gsettings set $gsetcustomkeys/custom2/ command 'nautilus'
    gsettings set $gsetcustomkeys/custom2/ binding '<Control><Alt>f'
    # custom3 3Web Browser
    gsettings set $gsetcustomkeys/custom3/ name '3Web'
    gsettings set $gsetcustomkeys/custom3/ command 'firefox-dev'
    gsettings set $gsetcustomkeys/custom3/ binding '<Control><Alt>w'
    # custom4 4Browser default
    gsettings set $gsetcustomkeys/custom4/ name '4Browser'
    gsettings set $gsetcustomkeys/custom4/ command 'firefox'
    gsettings set $gsetcustomkeys/custom4/ binding '<Control><Alt>b'
    # custom5 5Proxy
    gsettings set $gsetcustomkeys/custom5/ name '5Proxy'
    gsettings set $gsetcustomkeys/custom5/ command 'proxy-gui'
    gsettings set $gsetcustomkeys/custom5/ binding '<Control><Alt>p'
    # custom6 6Editor
    gsettings set $gsetcustomkeys/custom6/ name '6Editor'
    gsettings set $gsetcustomkeys/custom6/ command 'gnome-text-editor'
    gsettings set $gsetcustomkeys/custom6/ binding '<Control><Alt>e'
    # custom7 7Monitor
    gsettings set $gsetcustomkeys/custom7/ name '7Monitor'
    gsettings set $gsetcustomkeys/custom7/ command 'gnome-system-monitor'
    gsettings set $gsetcustomkeys/custom7/ binding '<Control><Alt>m'
    # custom8 8Dictionary
    gsettings set $gsetcustomkeys/custom8/ name '8Dictionary'
    gsettings set $gsetcustomkeys/custom8/ command 'goldendict'
    gsettings set $gsetcustomkeys/custom8/ binding '<Control><Alt>d'
    # custom9 Virt Manager
    gsettings set $gsetcustomkeys/custom9/ name 'Virt'
    gsettings set $gsetcustomkeys/custom9/ command 'virt-manager'
    gsettings set $gsetcustomkeys/custom9/ binding '<Control><Alt>v'
}
_gsetting_customkeys

# --------------------------------------------------------------------------}}}
