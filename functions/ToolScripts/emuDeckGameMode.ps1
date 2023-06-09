function game_mode_enable(){
	$source = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\gamemode\gamemode.bat"
	$target =  "$env:USERPROFILE\Desktop\Return to Gaming Mode.lnk"
	createLink($source, $target)	
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