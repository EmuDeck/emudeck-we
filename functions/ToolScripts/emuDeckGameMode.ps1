function game_mode_enable(){
	& %USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\enablegamemode.bat
	if($?){
		echo "true"
	}
}

function game_mode_disable(){
	& %USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\disablegamemode.bat
	if($?){
		echo "true"
	}
}