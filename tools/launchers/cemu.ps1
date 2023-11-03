. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}
$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/Emulators/cemu/Cemu.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

emulatorInit $emulatorFile $scriptFileName ($formattedArgs -join ' ')