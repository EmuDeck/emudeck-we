$gameModeFolder = "$env:APPDATA\EmuDeck\gamemode"
$loginPs1 = "$gameModeFolder\login.ps1"
New-Item -ItemType Directory -Path $gameModeFolder -Force | Out-Null
Copy-Item -Path "$env:APPDATA\EmuDeck\backend\tools\gamemode\login.ps1" -Destination $loginPs1 -Force

$shellCmd = "$env:windir\System32\conhost.exe --headless powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$loginPs1`""

$winlogonCU = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
if (-not (Test-Path $winlogonCU)) {
	New-Item -Path $winlogonCU -Force | Out-Null
}
Set-ItemProperty -Path $winlogonCU -Name 'Shell' -Value $shellCmd
