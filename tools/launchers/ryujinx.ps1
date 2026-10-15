$env:GIT_TERMINAL_PROMPT = "0"
$null | git -C "$env:APPDATA\EmuDeck\backend" fetch --depth=1 origin (git -C "$env:APPDATA\EmuDeck\backend" rev-parse --abbrev-ref HEAD)
if ($?) { $null | git -C "$env:APPDATA\EmuDeck\backend" reset --hard FETCH_HEAD } else { $null | git -C "$env:APPDATA\EmuDeck\backend" reset --hard }
$null | git -C "$env:APPDATA\EmuDeck\backend" clean -fd

$emulatorFile = "$env:APPDATA/emudeck/Emulators/Ryujinx/ryujinx.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
launcherInit
if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}

emulatorInit $scriptFileName $emulatorFile ($formattedArgs -join ' ')