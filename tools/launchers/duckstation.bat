@echo off
set args=%*
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$toolsPath"') do set toolsPath=%%~a
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist %rcloneConfig% (
	powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu duckstation "}
)
ESDEPATH\Emulators\duckstation\duckstation-qt-x64-ReleaseLTCG.exe %args%
cls
if exist %rcloneConfig% (
	powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_uploadEmu duckstation "}
)