function ESDE_install(){
	showNotification -ToastTitle 'Downloading EmulationStation DE'
	download $url_esde "esde.zip"
	moveFromTo "esde\EmulationStation-DE" "tools/EmulationStation-DE"
}
function ESDE_init(){	
	showNotification -ToastTitle 'EmulationStation DE - Paths and Themes'
	mkdir "tools\EmulationStation-DE\.emulationstation" -ErrorAction SilentlyContinue
	
	$destination='tools\EmulationStation-DE\.emulationstation'
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$HOME\EmuDeck\backend\configs\emulationstation" "$destination"
	
	sedFile 'tools\EmulationStation-DE\.emulationstation\es_settings.xml' '/run/media/mmcblk0p1/Emulation/roms/' $romsPath
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\themes\es-epicnoir"
	if(-not($test)){
		download "https://github.com/dragoonDorise/es-theme-epicnoir/archive/refs/heads/master.zip" "temp.zip"
		moveFromTo "temp\es-theme-epicnoir-master" "tools\EmulationStation-DE\themes\es-epicnoir"
	}
	
}
function ESDE_update(){
	echo "NYI"
}
function ESDE_setEmulationFolder(){
	echo "NYI"
}
function ESDE_setupSaves(){
	echo "NYI"
}
function ESDE_setupStorage(){
	echo "NYI"
}
function ESDE_wipe(){
	echo "NYI"
}
function ESDE_uninstall(){
	echo "NYI"
}
function ESDE_migrate(){
	echo "NYI"
}
function ESDE_setABXYstyle(){
	echo "NYI"
}
function ESDE_wideScreenOn(){
	echo "NYI"
}
function ESDE_wideScreenOff(){
	echo "NYI"
}
function ESDE_bezelOn(){
	echo "NYI"
}
function ESDE_bezelOff(){
	echo "NYI"
}
function ESDE_finalize(){
	echo "NYI"
}
function ESDE_IsInstalled(){
	echo "NYI"
}
function ESDE_resetConfig(){
	echo "NYI"
}