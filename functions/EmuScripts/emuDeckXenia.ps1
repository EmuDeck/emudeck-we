function Xenia_install(){
	setMSG "Downloading Xenia"
	$url_xenia = getLatestReleaseURLGH "xenia-canary/xenia-canary" "zip"
	download $url_xenia "xenia.zip"
	moveFromTo "$temp/xenia" "$emusPath\xenia"
	createLauncher "xenia"
}
function Xenia_init(){
	echo "NYI"
}
function Xenia_update(){
	echo "NYI"
}
function Xenia_setEmulationFolder(){
	echo "NYI"
}
function Xenia_setupSaves(){
	echo "NYI"
}
function Xenia_setResolution($resolution){
	echo $resolution
}
function Xenia_setupStorage(){
	echo "NYI"
}
function Xenia_wipe(){
	echo "NYI"
}
function Xenia_uninstall(){
	echo "NYI"
}
function Xenia_migrate(){
	echo "NYI"
}
function Xenia_setABXYstyle(){
	echo "NYI"
}
function Xenia_wideScreenOn(){
	echo "NYI"
}
function Xenia_wideScreenOff(){
	echo "NYI"
}
function Xenia_bezelOn(){
	echo "NYI"
}
function Xenia_bezelOff(){
	echo "NYI"
}
function Xenia_finalize(){
	echo "NYI"
}
function Xenia_IsInstalled(){
	$test=Test-Path -Path "$emusPath\xenia"
	if($test){
		echo "true"
	}
}
function Xenia_resetConfig(){
	Xenia_init
	if($?){
		echo "true"
	}
}