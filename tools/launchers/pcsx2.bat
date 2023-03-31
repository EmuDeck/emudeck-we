@echo off
set args=%*
echo "Syncing from the cloud, please stand by"
powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_downloadEmu PCSX2 "}
C:\Emulation\tools\EmulationStation-DE\Emulators\PCSX2\pcsx2-qtx64-avx2.exe %args%
cls
echo "Syncing to the cloud, please stand by"
powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; rclone_uploadEmu PCSX2 "}