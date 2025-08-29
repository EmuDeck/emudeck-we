. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

$appData  = [Environment]::GetFolderPath('ApplicationData')
$loginPs1 = Join-Path $appData 'EmuDeck\backend\tools\gamemode\login.ps1'

$shellCmd = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$loginPs1`""

$winlogonCU = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
New-Item -Path $winlogonCU -Force | Out-Null
Set-ItemProperty -Path $winlogonCU -Name 'Shell' -Value $shellCmd
