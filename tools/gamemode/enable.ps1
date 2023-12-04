. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$newValue = "$env:APPDATA\EmuDeck\backend\tools\gamemode\login.exe"
Set-ItemProperty -Path $regPath -Name "Shell" -Value $newValue
confirmDialog -TitleText "Game Mode" -MessageText "Next time you restart your computer, Game Mode will be ON. Exit Steam to get back to your Desktop"