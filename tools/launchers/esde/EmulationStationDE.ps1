$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/EmulationStation.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$NewTitle = "EmuDeck Launcher - $scriptFileName"
[Console]::Title = $NewTitle
. $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1
. $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/EmuScripts/emuDeckRPCS3.ps1
RPCS3_renameFolders
cloud_sync_init($scriptFileName)
Start-Process $emulatorFile -Wait -Args ($args -join " ")
rm -fo "$savesPath/.watching" -ErrorAction SilentlyContinue
rm -fo "$savesPath/.emulator" -ErrorAction SilentlyContinue
