function PPSSPP_install(){
	setMSG 'Downloading PPSSPP'
	download $url_PPSSPP "PPSSPP.zip"
	moveFromTo "temp/PPSSPP" "tools\EmulationStation-DE\Emulators\ppsspp_win"
	createLauncher "PPSSPP"
}
function PPSSPP_init(){
	echo "NYI"
}
function PPSSPP_update(){
	echo "NYI"
}
function PPSSPP_setEmulationFolder(){
	echo "NYI"
}
function PPSSPP_setupSaves(){
	echo "NYI"
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