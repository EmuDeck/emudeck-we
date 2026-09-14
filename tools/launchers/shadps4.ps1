$env:GIT_TERMINAL_PROMPT = "0"
$null | git -C "$env:APPDATA\EmuDeck\backend" pull

cd "$env:APPDATA/emudeck/Emulators/shadps4-qt/"
$emulatorFile = "$env:APPDATA/emudeck/Emulators/shadps4-qt/shadPS4QtLauncher.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
launcherInit
if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
	if ($args -match '\.lnk$') {
		$emulatorFile = "$formattedArgs"
	}
}

emulatorInit $scriptFileName $emulatorFile ($formattedArgs -join ' ')