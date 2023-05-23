function PPSSPP_install(){
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\ppsspp_win"
	if($test){
		Rename-Item "$emulationPath\tools\EmulationStation-DE\Emulators\ppsspp_win" "$emulationPath\tools\EmulationStation-DE\Emulators\PPSSPP" -ErrorAction SilentlyContinue
	}
	setMSG 'Downloading PPSSPP'
	download $url_PPSSPP "PPSSPP.zip"
	moveFromTo "temp/PPSSPP" "tools\EmulationStation-DE\Emulators\PPSSPP"
	createLauncher "PPSSPP"
}
function PPSSPP_init(){
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\ppsspp_win"
	if($test){
		Rename-Item "$emulationPath\tools\EmulationStation-DE\Emulators\ppsspp_win" "$emulationPath\tools\EmulationStation-DE\Emulators\PPSSPP" -ErrorAction SilentlyContinue
	}
	PPSSPP_setupSaves
}
function PPSSPP_update(){
	echo "NYI"
}
function PPSSPP_setEmulationFolder(){
	echo "NYI"
}
function PPSSPP_setupSaves(){	
	setMSG 'PPSSPP - Saves Links'
	
	$SourceFilePath = -join($emulationPath, '\tools\EmulationStation-DE\Emulators\PPSSPP\memstick\PSP\PPSSPP_STATE')	
	$ShortcutPath = -join($emulationPath,'\saves\ppsspp\states.lnk')	
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	$SourceFilePath = -join($emulationPath, '\tools\EmulationStation-DE\Emulators\PPSSPP\memstick\PSP\SAVEDATA')	
	$ShortcutPath = -join($emulationPath,'\saves\yuzu\saves.lnk')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
}
function PPSSPP_setResolution($resolution){
	echo $resolution
}
function PPSSPP_setupStorage(){
	echo "NYI"
}
function PPSSPP_wipe(){
	echo "NYI"
}
function PPSSPP_uninstall(){
	echo "NYI"
}
function PPSSPP_migrate(){
	echo "NYI"
}
function PPSSPP_setABXYstyle(){
	echo "NYI"
}
function PPSSPP_wideScreenOn(){
	echo "NYI"
}
function PPSSPP_wideScreenOff(){
	echo "NYI"
}
function PPSSPP_bezelOn(){
	echo "NYI"
}
function PPSSPP_bezelOff(){
	echo "NYI"
}
function PPSSPP_finalize(){
	echo "NYI"
}
function PPSSPP_IsInstalled(){
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\ppsspp_win"
	if($test){
		echo "true"
	}
}
function PPSSPP_resetConfig(){
	PPSSPP_init
	if($?){
		echo "true"
	}
}