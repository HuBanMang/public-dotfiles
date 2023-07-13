# Windows

## Init

```sh
runas /user:administrator cmd
```

## Privacy

[privacy.sexy](https://github.com/undergroundwires/privacy.sexy)

## Multi IP

```sh
netsh int ipv4 set interface "WLAN" dhcpstaticipcoexistence=enabled
netsh int ipv4 add interface "WLAN" 10.0.1.2 255.0.0.0
```

## 修复

```sh
DISM修复：
PS ~~ DISM /Online /Cleanup-Image /ScanHealth
PS ~~ DISM /Online /Cleanup-Image /RestoreHealth [/Source:C:\RepairSource\Windows /LimitAccess]
sfc /scannow

Microsoft Store：
Win+R wsreset
C:\Windows\SoftwareDistribution\Download

引导：
cmd(admin)
bcdedit
```
