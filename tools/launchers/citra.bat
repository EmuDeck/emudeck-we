@echo off
set args=%*
if "%args%" NEQ "--emudeck" (
	powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; $result = confirmDialog -TitleText "Steam not detected" -MessageText "In order to use EmuDeck's automatic controller config you need to launch this system from Steam" -OKButtonText "OK" -CancelButtonText "NO" "}
	exit
)
title EmuDeck Launcher
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$toolsPath"') do set "toolsPath=%%~a"
for /f "tokens=2 delims==" %%b in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "cloud_sync_status"') do set "cloud_sync_status=%%~b"
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist "%rcloneConfig%" (
	if "%cloud_sync_status%"=="true" (
		powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu citra "}
		start /min "CloudSync Monitor" cscript //nologo "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloud_sync_monitor.vbs" citra
	)
)
"ESDEPATH\Emulators\citra\citra-qt.exe" %args%