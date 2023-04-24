@echo off
set args=%*

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_downloadEmu xemu "}
C:\Emulation\tools\EmulationStation-DE\Emulators\xemu\xemu.exe %args%
cls

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_uploadEmu xemu "}