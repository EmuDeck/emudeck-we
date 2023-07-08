function Xenia_install(){
	setMSG "Downloading Xenia"
	$url_xenia = getLatestReleaseURLGH "xenia-canary/xenia-canary" "zip"
	download $url_xenia "xenia.zip"
	moveFromTo "$temp/xenia" "$emusPath\xenia"
	createLauncher "xenia"
}
function Xenia_init(){
	Write-Output "NYI"
	#Xenia_setResolution $xeniaResolution
}
function Xenia_update(){
	Write-Output "NYI"
}
function Xenia_setEmulationFolder(){
	Write-Output "NYI"
}
function Xenia_setupSaves(){
	Write-Output "NYI"
}
function Xenia_setResolution($resolution){
	Write-Output $resolution
}
function Xenia_setupStorage(){
	Write-Output "NYI"
}
function Xenia_wipe(){
	Write-Output "NYI"
}
function Xenia_uninstall(){
	Write-Output "NYI"
}
function Xenia_migrate(){
	Write-Output "NYI"
}
function Xenia_setABXYstyle(){
	Write-Output "NYI"
}
function Xenia_wideScreenOn(){
	Write-Output "NYI"
}
function Xenia_wideScreenOff(){
	Write-Output "NYI"
}
function Xenia_bezelOn(){
	Write-Output "NYI"
}
function Xenia_bezelOff(){
	Write-Output "NYI"
}
function Xenia_finalize(){
	Write-Output "NYI"
}
function Xenia_IsInstalled(){
	$test=Test-Path -Path "$emusPath\xenia"
	if($test){
		Write-Output "true"
	}
}
function Xenia_resetConfig(){
	Xenia_init
	if($?){
		Write-Output "true"
	}
}