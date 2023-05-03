@echo off
set args=%*

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu xenia "}
C:\Emulation\tools\EmulationStation-DE\Emulators\xenia\xenia.exe %args%
cls

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_uploadEmu xenia "}