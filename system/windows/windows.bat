@echo off

:CapsCtrl
echo "Caps Ctrl"
choice /m "Set Caps->Ctrl(y) or Reset(n)?"
if %errorlevel% equ 1 goto SetCapsCtrl
if %errorlevel% equ 2 goto ResetCapsCtrl

:SetCapsCtrl
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "0000000000000000020000001d003a0000000000"
goto UTCTime

:ResetCapsCtrl
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "0000000000000000000000000000000000000000"
goto UTCTime

:UTCTime
echo "UTC Time"
choice /m "Set UTC Time(y) or Reset(n)?"
if %errorlevel% equ 1 goto SetUTCTime
if %errorlevel% equ 2 goto ResetUTCTime

:SetUTCTime
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v "RealTimeIsUniversal" /t REG_DWORD /d 1
goto FastBoot

:ResetUTCTime
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v "RealTimeIsUniversal" /t REG_DWORD /d 0
goto FastBoot

:FastBoot
echo "FastBoot"
choice /m "Disable Fast Boot(y) or Enable(n)?"
if %errorlevel% equ 1 goto DisableFastBoot
if %errorlevel% equ 2 goto EnableFastBoot

:DisableFastBoot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
goto WFPLog

:EnableFastBoot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
goto WFPLog

:WFPLog
echo "WFPLog"
choice /m "Disable WFP Log(y) or Enable(n)?"
if %errorlevel% equ 1 goto DisableWFPLog
if %errorlevel% equ 2 goto EnableWFPLog

:DisableWFPLog
netsh wfp set options netevents=off
goto Tray

:EnableWFPLog
netsh wfp set options netevents=on
goto Tray

:Tray
echo "Clean Tray"
choice /m "Clean Tray(y) or exit(n)?"
if %errorlevel% equ 1 goto CleanTray
if %errorlevel% equ 2 goto exit

:CleanTray
reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "IconStreams" /f
reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "PastIconsStream" /f

pause
