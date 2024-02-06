. "$env:APPDATA\EmuDeck\backend\functions/all.ps1"
$scriptContent = @"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value "explorer.exe
"@
startScriptWithAdmin -ScriptContent $scriptContent
confirmDialog -TitleText "Desktop Mode" -MessageText "Next time you restart your computer, Game Mode will be OFF"
