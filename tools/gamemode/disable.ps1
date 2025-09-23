. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

$winlogonCU = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
New-Item -Path $winlogonCU -Force | Out-Null
Set-ItemProperty -Path $winlogonCU -Name 'Shell' -Value 'explorer.exe'

if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) {
    Start-Process explorer.exe
}
