@echo off
set args=%*
powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu dolphin "}
C:\Emulation\tools\EmulationStation-DE\Emulators\Dolphin-x64\Dolphin.exe %args%
cls
powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_uploadEmu dolphin "}