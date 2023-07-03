function game_mode_enable(){
	$source = "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\gamemode.bat"
	$target =  "$userFolder\Desktop\Return to Gaming Mode.lnk"
	
	$WScriptObj = New-Object -ComObject ("WScript.Shell")
	$shortcut = $WscriptObj.CreateShortcut($target)
	$shortcut.TargetPath = $source
	$shortcut.WindowStyle = 1	
	$shortcut.IconLocation = "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\icon.ico"
	$shortcut.Save()

	& $userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\enablegamemode.bat
	if($?){
		echo "true"
	}
}

function game_mode_disable(){
 	rm -fo "$env:USERPROFILE\Desktop\Return to Gaming Mode.lnk" -ErrorAction SilentlyContinue
	& $userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\disablegamemode.bat
	if($?){
		echo "true"
	}
}