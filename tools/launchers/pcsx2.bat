@echo off
set args=%*
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\emudeck\settings.ps1" ^| find "$toolsPath"') do set toolsPath=%%~a
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist %rcloneConfig% (
	powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu pcsx2 "}
)
C:\Emulation\tools\EmulationStation-DE\Emulators\PCSX2-Qt\pcsx2-qtx64-avx2.exe %args%
cls
if exist %rcloneConfig% (
	powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_uploadEmu pcsx2 "}
)
