$emulatorFile = "$env:USERPROFILE\AppData\Local\pegasus-frontend/pegasus-fe.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"

if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}
emulatorInit $scriptFileName $emulatorFile ($formattedArgs -join ' ')
