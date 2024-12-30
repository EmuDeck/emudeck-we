function game_mode_enable(){
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