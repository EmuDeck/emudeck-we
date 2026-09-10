$env:GIT_TERMINAL_PROMPT = "0"
$null | git -C "$env:APPDATA\EmuDeck\backend" pull

cd "$env:APPDATA/EmuDeck/Emulators/Supermodel"
$emulatorFile = "$env:APPDATA/EmuDeck/Emulators/Supermodel/Supermodel.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
launcherInit
if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}

emulatorInit $scriptFileName $emulatorFile ($formattedArgs -join ' ')