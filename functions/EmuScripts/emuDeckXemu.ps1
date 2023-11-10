$Xemu_configFile="${emusPath}\xemu\xemu.toml"

function Xemu_install(){
	setMSG "Downloading Xemu"
	$url_xemu = getLatestReleaseURLGH "xemu-project/xemu" "zip" "win-release.zip"
	download $url_xemu "xemu-win-release.zip"
	moveFromTo "$temp/xemu-win-release" "$emusPath\xemu"
	createLauncher "xemu"
}
function Xemu_init(){
	$destination="$emusPath\xemu"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\xemu" "$destination"
	sedFile $Xemu_configFile "/run/media/mmcblk0p1/Emulation" "$emulationPath"
	sedFile $Xemu_configFile "/" '\'
	Xemu_setupStorage
	Xemu_setCustomizations
	#Xemu_setResolution $xemuResolution
}
function Xemu_update(){
	Write-Output "NYI"
}
function Xemu_setupSaves(){
	Write-Output "NYI"
}
function Xemu_setResolution($resolution){
	Write-Output $resolution
}
function Xemu_setupStorage(){
	mkdir "$storagePath\xemu" -ErrorAction SilentlyContinue
	$url_xemu_hdd = "https://github.com/mborgerson/xemu-hdd-image/releases/latest/download/xbox_hdd.qcow2.zip"
	download $url_xemu_hdd "xbox_hdd.qcow2.zip"
	moveFromTo "$temp/xbox_hdd.qcow2" "$storagePath\xemu"
}
function Xemu_wipe(){
	Write-Output "NYI"
}
function Xemu_uninstall(){
	Remove-Item –path "$emusPath\Xemu" –recurse -force
	if($?){
		Write-Output "true"
	}
}
function Xemu_migrate(){
	Write-Output "NYI"
}
function Xemu_setABXYstyle(){
	Write-Output "NYI"
}
function Xemu_wideScreenOn(){
	$fit='fit = '
	$fitSetting="$fit'scale_16_9'"
	changeLine "$fit" "$fitSetting" "$Xemu_configFile"
}
function Xemu_wideScreenOff(){
	$fit='fit = '
	$fitSetting="$fit'scale_4_3'"
	changeLine "$fit" "$fitSetting" "$Xemu_configFile"
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
	}else{
		Write-Output "false"
	}
}
function Xemu_resetConfig(){
	Xemu_init
	if($?){
		Write-Output "true"
	}
}
function Xemu_setCustomizations(){
	if ( "$arClassic3D" -eq "169"){
	  Xemu_wideScreenOn
	}else{
	  Xemu_wideScreenOff
	}
}

