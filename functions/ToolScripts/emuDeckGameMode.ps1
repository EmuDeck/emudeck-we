function game_mode_enable(){
	#$source = "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\start_game_mode.exe"
	#$target =  "$userFolder\Desktop\Return to Gaming Mode.lnk"
	#$WScriptObj = New-Object -ComObject ("WScript.Shell")
	#$shortcut = $WscriptObj.CreateShortcut($target)
	#$shortcut.TargetPath = $source
	#$shortcut.WindowStyle = 7
	#$shortcut.IconLocation = "$env:APPDATA\EmuDeck\backend\tools\gamemode\icon.ico"
	#$shortcut.Save()

	. "$env:APPDATA\EmuDeck\backend\tools\gamemode\enable.ps1"
	if($?){
		Write-Output "true"
	}
}

function game_mode_disable(){
	#rm -fo -r "$env:USERPROFILE\Desktop\Return to Gaming Mode.lnk" -ErrorAction SilentlyContinue
	. "$env:APPDATA\EmuDeck\backend\tools\gamemode\disable.ps1"
	if($?){
		Write-Output "true"
	}
}