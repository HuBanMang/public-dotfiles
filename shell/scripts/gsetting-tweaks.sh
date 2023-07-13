#!/bin/bash

# 设置微调 gnome-tweaks dconf-editor
# dconf dump / > dconf.conf
# cat dconf.conf | dconf load -f /

# _gsetting_tweaks() ----------------------------------------------{{{

_gsetting_tweaks() {
    # 重置应用列表排序
    gsettings set org.gnome.shell app-picker-layout \[\]
    gsettings set org.gnome.desktop.app-folders folder-children \[\]

    # 暗色模式
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

    # 光标主题
    gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
    # 图标主题
    gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
    # GTK主题
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

    # 标题栏按钮 最小化 最大化 关闭
    gsettings set org.gnome.desktop.wm.preferences button-layout "icon:minimize,maximize,close"
    # 标题字体
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Sans 12"

    # 界面字体
    gsettings set org.gnome.desktop.interface font-name "Sans 12"
    # 文档字体
    gsettings set org.gnome.desktop.interface document-font-name "Sans 16"
    # 等宽字体
    gsettings set org.gnome.desktop.interface monospace-font-name "Monospace 16"

    # 时钟格式 24h
    gsettings set org.gnome.desktop.interface clock-format "24h"
    # 时钟处显示日期
    gsettings set org.gnome.desktop.interface clock-show-date true
    # 时钟处显示秒数
    gsettings set org.gnome.desktop.interface clock-show-seconds true
    # 时钟处显示星期
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    # 日历处显示周数
    gsettings set org.gnome.desktop.calendar show-weekdate true

    # 显示电池百分比
    gsettings set org.gnome.desktop.interface show-battery-percentage true

    # 触控板 轻触点击
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
}
_gsetting_tweaks

# --------------------------------------------------------------------------}}}
