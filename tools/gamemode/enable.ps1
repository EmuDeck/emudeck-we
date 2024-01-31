. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"
$scriptContent = @"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:APPDATA\EmuDeck\backend\tools\gamemode\login.bat"
"@
startScriptWithAdmin -ScriptContent $scriptContent
confirmDialog -TitleText "Game Mode" -MessageText "Next time you restart your computer, Game Mode will be ON. Exit Steam to get back to your Desktop"