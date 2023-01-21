function Xemu_install(){
	showNotification -ToastTitle 'Downloading Xemu'
	download $url_xemu "xemu-win-release.zip"
	moveFromTo "xemu-win-release" "tools\EmulationStation-DE\Emulators\xemu"
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
	echo "NYI"
}
function Xemu_resetConfig(){
	echo "NYI"
}