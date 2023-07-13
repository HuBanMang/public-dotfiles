#!/bin/bash

# 禁用`gnome-software`的自动更新

# _gsetting_software_disable() ---------------------------------------------{{{

_gsetting_software_disable() {
    # /etc/xdg/autostart/org.gnome.Software.desktop
    # gnome-shell search-providers
    echo -e "\ngsetting get:\n"
    echo -n " gnome-software allow-updates:         "
    gsettings get org.gnome.software allow-updates
    echo -n " gnome-software download-updates:      "
    gsettings get org.gnome.software download-updates
    echo -n " search-providers disable-external:    "
    gsettings get org.gnome.desktop.search-providers disable-external

    echo -e "\ngsetting set:\n"
    gsettings set org.gnome.software allow-updates false
    gsettings set org.gnome.software download-updates false
    gsettings set org.gnome.desktop.search-providers disable-external true
    echo -n " gnome-software allow-updates:         "
    gsettings get org.gnome.software allow-updates
    echo -n " gnome-software download-updates:      "
    gsettings get org.gnome.software download-updates
    echo -n " search-providers disable-external:    "
    gsettings get org.gnome.desktop.search-providers disable-external

    #echo -e "\ndisable gnome-software autostart\n"
    #echo "$ mkdir -pv ~/.config/autostart"
    #mkdir -pv ~/.config/autostart
    #echo "$ cp /etc/xdg/autostart/org.gnome.Software.desktop ~/.config/autostart/"
    #cp /etc/xdg/autostart/org.gnome.Software.desktop ~/.config/autostart/
    #echo '$ echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/org.gnome.Software.desktop'
    #echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/org.gnome.Software.desktop
    #echo "$ tail ~/.config/autostart/org.gnome.Software.desktop"
    #tail ~/.config/autostart/org.gnome.Software.desktop

    # just `sudo apt-get purge gnome-software && sudo aptitude purge`
}
_gsetting_software_disable

# --------------------------------------------------------------------------}}}
