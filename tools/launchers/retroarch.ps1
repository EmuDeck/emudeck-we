. $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1
$arguments = $args -join " "

cloud_sync_init "retroarch"

Start-Process "C:/Users/rsedano/EmuDeck/EmulationStation-DE/Emulators/RetroArch/retroarch.exe" -Args $arguments