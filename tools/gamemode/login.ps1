. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"

function startSteam(){
	 $steamRegPath = "HKCU:\Software\Valve\Steam"
	 $steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	 $steamInstallPath = $steamInstallPath.Replace("/", "\\")
	 $steamArguments = "-bigpicture"
	 Start-Process -FilePath "$steamInstallPath\Steam.exe" -Wait -ArgumentList $steamArguments
 }

hideMe
fullScreenToast
startSteam
if($?){
	#Back to desktop
	#We set the good old explorer.exe as shell
$scriptContent = @"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "explorer.exe"
	#We restart sihost to launch explorer and the desktop
	Wait-Event -Timeout 5
	Stop-Process -Name "sihost" -Force
	Wait-Event -Timeout 5
	& "C:\Windows\System32\sihost.exe"
	#We set the next restart to be on game mode.
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:APPDATA\EmuDeck\backend\tools\gamemode\login.exe"
"@
	startScriptWithAdmin -ScriptContent $scriptContent
	#We don't restart sihost since we don't want to go to game mode now.
}else{
	#Disable game mode in case of fail, we set explorer.exe and restart the desktop with sihost
$scriptContent = @"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "explorer.exe"
	Wait-Event -Timeout 5
	#We restart sihost to launch explorer and the desktop
	Stop-Process -Name "sihost" -Force
	Wait-Event -Timeout 5
	& "C:\Windows\System32\sihost.exe"
"@
	confirmDialog -TitleText "Game mode failed to start" -MessageText "Going back to your Desktop"
	startScriptWithAdmin -ScriptContent $scriptContent
}
