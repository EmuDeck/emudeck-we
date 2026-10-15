$env:GIT_TERMINAL_PROMPT = "0"
$null | git -C "$env:APPDATA\EmuDeck\backend" fetch --depth=1 origin (git -C "$env:APPDATA\EmuDeck\backend" rev-parse --abbrev-ref HEAD)
if ($?) { $null | git -C "$env:APPDATA\EmuDeck\backend" reset --hard FETCH_HEAD } else { $null | git -C "$env:APPDATA\EmuDeck\backend" reset --hard }
$null | git -C "$env:APPDATA\EmuDeck\backend" clean -fd

. "$($env:USERPROFILE)\AppData\Roaming\EmuDeck\backend\functions\all.ps1"
launcherInit

emulatorCheckAndInstall "SRM"

$steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
if ($steamRunning) {
    killSteam
}
RPCS3_renameFolders
SRM_checkParsers
Write-Host "Launching Steam Rom Manager, please stand by..." -ForegroundColor white
$emulatorFile = "$toolsPath/srm.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
Start-Process "$emulatorFile" -WindowStyle Maximized -Wait

if ($steamRunning) {
    startSteam
}
