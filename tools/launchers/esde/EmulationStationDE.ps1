$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/EmulationStation.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/EmuScripts/emuDeckRPCS3.ps1"
RPCS3_renameFolders

if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}
emulatorInit $emulatorFile $scriptFileName ($formattedArgs -join ' ')
