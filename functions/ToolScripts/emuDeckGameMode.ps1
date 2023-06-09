function game_mode_enable(){
	& $userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\enablegamemode.bat
	if($?){
		echo "true"
	}
}

function game_mode_disable(){
	& $userFolder\AppData\Roaming\EmuDeck\backend\tools\gamemode\disablegamemode.bat
	if($?){
		echo "true"
	}
}