. "$($env:USERPROFILE)\AppData\Roaming\EmuDeck\backend\functions\all.ps1"
$steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
if ($steamRunning) {
    taskkill /IM steam.exe /F
}
RPCS3_renameFolders
Write-Host "Launching Steam Rom Manager, please stand by..." -ForegroundColor white
$emulatorFile = "$toolsPath/srm.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
Start-Process "$emulatorFile" -WindowStyle Maximized -Wait

if ($steamRunning) {
    startSteam
}
