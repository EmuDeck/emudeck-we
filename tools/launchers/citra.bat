@echo off
set args=%*
title EmuDeck Launcher
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$toolsPath"') do set "toolsPath=%%~a"
for /f "tokens=2 delims==" %%b in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "cloud_sync_status"') do set "cloud_sync_status=%%~b"
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist "%rcloneConfig%" (
	if "%cloud_sync_status%"=="true" (
		powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu citra "}		
	)
)
"ESDEPATH\Emulators\citra\citra-qt.exe" %args%
set lockFile="%userprofile%\EmuDeck\cloud.lock"

:search_lock
if not exist "%lockFile%" (		
	taskkill /FI "WINDOWTITLE eq CloudSync"
	exit
) else (
	echo "lock file detected, waiting..."
)
timeout /t 1 >nul
goto search_lock