function Xemu_install(){
	setMSG 'Downloading Xemu'
	$url_xemu = getLatestReleaseURLGH 'xemu-project/xemu' 'zip' 'win-release'
	download $url_xemu "xemu-win-release.zip"
	moveFromTo "temp/xemu-win-release" "tools\EmulationStation-DE\Emulators\xemu"
	createLauncher "xemu" "xemu"
}
function Xemu_init(){
	echo "NYI"
}
function Xemu_update(){
	echo "NYI"
}
function Xemu_setEmulationFolder(){
	echo "NYI"
}
function Xemu_setupSaves(){
	echo "NYI"
}
function Xemu_setResolution($resolution){
	echo $resolution
}
function Xemu_setupStorage(){
	echo "NYI"
}
function Xemu_wipe(){
	echo "NYI"
}
function Xemu_uninstall(){
	echo "NYI"
}
function Xemu_migrate(){
	echo "NYI"
}
function Xemu_setABXYstyle(){
	echo "NYI"
}
function Xemu_wideScreenOn(){
	echo "NYI"
}
function Xemu_wideScreenOff(){
	echo "NYI"
}
function Xemu_bezelOn(){
	echo "NYI"
}
function Xemu_bezelOff(){
	echo "NYI"
}
function Xemu_finalize(){
	echo "NYI"
}
function Xemu_IsInstalled(){
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\xemu"
	if($test){
		echo "true"
	}
}
function Xemu_resetConfig(){
	Xemu_init
	if($?){
		echo "true"
	}
}
function Xemu_wideScreenOff(){
	echo "NYI"
}
function Xemu_wideScreenOn(){
	echo "NYI"
}