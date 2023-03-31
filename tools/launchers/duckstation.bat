@echo off
set args=%*
echo "Syncing from the cloud, please stand by"
powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_downloadEmu duckstation "}
C:\Emulation\tools\EmulationStation-DE\Emulators\duckstation\duckstation-qt-x64-ReleaseLTCG.exe %args%
cls
echo "Syncing to the cloud, please stand by"
powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_uploadEmu duckstation "}