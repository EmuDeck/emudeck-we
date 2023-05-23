function emuDeckInstallHomebrewGame($system, $gameName, $game){
	$gameNameUrl=$gameName.replace(' ','%20')
	$gameUrl=$game.replace(' ','%20')

	mkdir $romsPath/$system/homebrew -ErrorAction SilentlyContinue ;
	mkdir $toolsPath/downloaded_media/$system/screenshots/homebrew -ErrorAction SilentlyContinue ;
	mkdir $toolsPath/downloaded_media/$system/titlescreens/homebrew -ErrorAction SilentlyContinue ;
	curl "$gameUrl" -o "$romsPath/$system/homebrew/$gameName.zip" ;
	curl "https://raw.githubusercontent.com/EmuDeck/emudeck-homebrew/main/downloaded_media/$system/screenshots/homebrew/$gameNameUrl.png" -o "$toolsPath/downloaded_media/$system/screenshots/homebrew/$gameName.png" ;
	curl "https://raw.githubusercontent.com/EmuDeck/emudeck-homebrew/main/downloaded_media/$system/titlescreens/homebrew/$gameNameUrl.png" -o "$toolsPath/downloaded_media/$system/titlescreens/homebrew/$gameName.png" ; echo 'true'
}
function emuDeckUnInstallHomebrewGame($system, $gameName, $game){

	rm -fo "$romsPath/$system/homebrew/$gameName.zip" ;
	rm -fo  "$toolsPath/downloaded_media/$system/screenshots/homebrew/$gameName.png" ;
	rm -fo  "$toolsPath/downloaded_media/$system/titlescreens/homebrew/$gameName.png" ; echo 'true'

}