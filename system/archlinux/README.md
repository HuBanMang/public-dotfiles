# Arch Linux

**注意**：现在使用脚本[`setup-system-arch.sh`](../scripts/setup-system-arch.sh)初始化系统，本文件可能未更新

## Nvidia

```sh
lspci -k | grep -A 2 -E "(VGA|3D)"

sudo pacman -S --needed dkms linux-headers lib32-nvidia-utils # multlib

sudo pacman -S --needed nvidia nvidia-prime nvidia-settings nvidia-utils # nvidia-open

EDITOR=vim sudo -e /etc/mkinitcpio.conf # HOOKS=(kms) remove `kms`; MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# modesetting mode
cat /sys/module/nvidia_drm/parameters/modeset

EDITOR=vim sudo -e /etc/default/grub # GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1"
# or
echo options nvidia_drm modeset=1 | sudo tee /etc/modprobe.d/nvidia_drm.conf

# pacman hook
sudo cp /dotfiles/system/archlinux/nvidia-linux.hook /etc/pacman.d/hooks/nvidia.hook

sudo mkinitcpio -P

# arch wiki nvidia nvidia/tips_and_tricks
# pacman hook
# preserve video memory
# enable nvidia-suspend.service nvidia-hibernate.service
```
