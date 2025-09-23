. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"

function startSteam(){
    $steamRegPath = "HKCU:\Software\Valve\Steam"
    $steamInstallPath = (Get-ItemProperty -Path $steamRegPath -ErrorAction SilentlyContinue).SteamPath
    if (-not $steamInstallPath) { $steamInstallPath = "${env:ProgramFiles(x86)}\Steam" }
    $steamInstallPath = $steamInstallPath.Replace("/", "\")
    $steamExe = Join-Path $steamInstallPath 'Steam.exe'
    if (-not (Test-Path $steamExe)) { return $false }

	# Iniciar Steam en modo Big Picture
    Start-Process -FilePath $steamExe -ArgumentList '-bigpicture' -WindowStyle Hidden
    Wait-Process -Name steam -ErrorAction SilentlyContinue
    return $true
}

hideMe

if (startSteam) {
    if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) {
        Start-Process explorer.exe
    }
} else {
    confirmDialog -TitleText "Game Mode" -MessageText "There was an error running Steam. Returning to Desktop."
    if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) {
        Start-Process explorer.exe
    }
}
