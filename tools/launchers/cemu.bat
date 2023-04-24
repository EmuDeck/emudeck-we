@echo off
set args=%*

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_downloadEmu cemu "}
C:\Emulation\tools\EmulationStation-DE\Emulators\cemu\Cemu.exe %args%
cls

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_uploadEmu cemu "}