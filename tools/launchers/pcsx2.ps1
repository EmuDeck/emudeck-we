$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/Emulators/PCSX2-Qt/pcsx2-qtx64.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}

emulatorInit $emulatorFile $scriptFileName ($formattedArgs -join ' ')