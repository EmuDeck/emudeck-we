. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"
$scriptContent = @"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "$env:APPDATA\EmuDeck\backend\tools\gamemode\login.bat"
"@
startScriptWithAdmin -ScriptContent $scriptContent