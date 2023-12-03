function game_mode_enable(){
	$source = "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\start_game_mode.exe"
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
	$shortcut.Save() -ErrorAction SilentlyContinue

	& "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\enable.exe"
	if($?){
		Write-Output "true"
	}
}

function game_mode_disable(){
	 rm -fo -r "$env:USERPROFILE\Desktop\Return to Gaming Mode.lnk" -ErrorAction SilentlyContinue
	& "$userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\disable.exe"
	if($?){
		Write-Output "true"
	}
}
