$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/Emulators/RPCS3/rpcs3.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$NewTitle = "EmuDeck Launcher - $scriptFileName"
[Console]::Title = $NewTitle
. $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1
cloud_sync_init($scriptFileName)
if($args){
	Start-Process $emulatorFile -Wait -Args ($args -join " ")
}else{
	Start-Process $emulatorFile
}
rm -fo "$savesPath/.watching" -ErrorAction SilentlyContinue
rm -fo "$savesPath/.emulator" -ErrorAction SilentlyContinue