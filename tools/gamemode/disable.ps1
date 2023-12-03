. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$newValue = "explorer.exe"
Set-ItemProperty -Path $regPath -Name "Shell" -Value $newValue
confirmDialog -TitleText "Desktop Mode" -MessageText "Next time you restart your computer, Game Mode will be OFF"