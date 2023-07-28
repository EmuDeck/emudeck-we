function game_mode_enable(){
	$source = "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\gamemode.bat"
	$test=Test-Path -Path "$userFolder\OneDrive\Desktop"
	if(-not($test)){
		$target =  "$userFolder\Desktop\Return to Gaming Mode.lnk"
	}else{
		$target =  "$userFolder\OneDrive\Desktop\Return to Gaming Mode.lnk"
	}
	
	$WScriptObj = New-Object -ComObject ("WScript.Shell")
	$shortcut = $WscriptObj.CreateShortcut($target)
	$shortcut.TargetPath = $source
	$shortcut.WindowStyle = 7	
	$shortcut.IconLocation = "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\icon.ico"
	$shortcut.Save()

	& $userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\enablegamemode.bat
	if($?){
		Write-Output "true"
	}
}

function game_mode_disable(){
	 rm -fo "$env:USERPROFILE\Desktop\Return to Gaming Mode.lnk" -ErrorAction SilentlyContinue
	& $userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\disablegamemode.bat
	if($?){
		Write-Output "true"
	}
}