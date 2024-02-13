. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"
hideMe
fullScreenToast
function startSteam(){
	 $steamRegPath = "HKCU:\Software\Valve\Steam"
	 $steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	 $steamInstallPath = $steamInstallPath.Replace("/", "\")
	 $steamArguments = "-bigpicture"
	 Start-Process -FilePath "$steamInstallPath\Steam.exe" -Wait -ArgumentList $steamArguments
 }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:APPDATA\EmuDeck\backend\tools\gamemode\login.bat"
#We restart sihost to launch explorer and the desktop
Wait-Event -Timeout 5
Stop-Process -Name "sihost" -Force
Wait-Event -Timeout 5
Stop-Process -Name "explorer" -Force
& "C:\Windows\System32\sihost.exe"
startSteam