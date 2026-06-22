. "$($env:USERPROFILE)\AppData\Roaming\EmuDeck\backend\functions\all.ps1"

function SRM_checkParsers {
    $userConfig = "$toolsPath\userData\userConfigurations.json"
    $parsers = Get-Content $userConfig -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue

    if (!$parsers -or $parsers.Count -eq 0) {
        Write-Host "Steam ROM Manager has no parsers, restoring configuration..."
        SRM_createParsers
    }
}

$steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
if ($steamRunning) {
    taskkill /IM steam.exe /F
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
