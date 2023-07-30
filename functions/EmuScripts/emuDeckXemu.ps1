function Xemu_install(){
	setMSG "Downloading Xemu"
	$url_xemu = getLatestReleaseURLGH "xemu-project/xemu" "zip" "win-release"
	download $url_xemu "xemu-win-release.zip"
	moveFromTo "$temp/xemu-win-release" "$emusPath\xemu"
	createLauncher "xemu"
}
function Xemu_init(){
	Write-Output "NYI"
	#Xemu_setResolution $xemuResolution
}
function Xemu_update(){
	Write-Output "NYI"
}
function Xemu_setEmulationFolder(){
	Write-Output "NYI"
}
function Xemu_setupSaves(){
	Write-Output "NYI"
}
function Xemu_setResolution($resolution){
	Write-Output $resolution
}
function Xemu_setupStorage(){
	Write-Output "NYI"
}
function Xemu_wipe(){
	Write-Output "NYI"
}
function Xemu_uninstall(){
	Write-Output "NYI"
}
function Xemu_migrate(){
	Write-Output "NYI"
}
function Xemu_setABXYstyle(){
	Write-Output "NYI"
}
function Xemu_wideScreenOn(){
	Write-Output "NYI"
}
function Xemu_wideScreenOff(){
	Write-Output "NYI"
}
function Xemu_bezelOn(){
	Write-Output "NYI"
}
function Xemu_bezelOff(){
	Write-Output "NYI"
}
function Xemu_finalize(){
	Write-Output "NYI"
}
function Xemu_IsInstalled(){
	$test=Test-Path -Path "$emusPath\xemu"
	if($test){
		Write-Output "true"
	}
}
function Xemu_resetConfig(){
	Xemu_init
	if($?){
		Write-Output "true"
	}
}
function Xemu_wideScreenOff(){
	Write-Output "NYI"
}
function Xemu_wideScreenOn(){
	Write-Output "NYI"
}