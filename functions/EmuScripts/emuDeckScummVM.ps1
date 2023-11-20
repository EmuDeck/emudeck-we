$ScummVM_configFile="$env:APPDATA\ScummVM\scummvm.ini"

function ScummVM_install(){
	setMSG "Downloading ScummVM"
	download $url_ScummVM "ScummVM.zip"
	moveFromTo "$temp\ScummVM" "$emusPath\ScummVM"
	createLauncher "ScummVM"
}
function ScummVM_init(){
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\scummvm" "$env:APPDATA\ScummVM"
	ScummVM_setEmulationFolder
	ScummVM_setupSaves
}
function ScummVM_update(){
	Write-Output "NYI"
}
function ScummVM_setEmulationFolder(){
	sedFile $ScummVM_configFile "/run/media/mmcblk0p1/Emulation" "$emulationPath"
}
function ScummVM_setupSaves(){
	setMSG "ScummVM - Saves Links"
	mkdir "$savespath\scummvm\saves" -ErrorAction SilentlyContinue
}
function ScummVM_setupStorage(){
	Write-Output "NYI"
}
function ScummVM_wipe(){
	Write-Output "NYI"
}
function ScummVM_uninstall(){
	Remove-Item –path "$emusPath\ScummVM" –recurse -force
	if($?){
		Write-Output "true"
	}
}
function ScummVM_migrate(){
	Write-Output "NYI"
}
function ScummVM_setABXYstyle(){
	Write-Output "NYI"
}
function ScummVM_wideScreenOn(){
	Write-Output "NYI"
}
function ScummVM_wideScreenOff(){
	Write-Output "NYI"
}
function ScummVM_bezelOn(){
	Write-Output "NYI"
}
function ScummVM_bezelOff(){
	Write-Output "NYI"
}
function ScummVM_finalize(){
	Write-Output "NYI"
}
function ScummVM_IsInstalled(){
	$test=Test-Path -Path "$emusPath\ScummVM\scummvm.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function ScummVM_resetConfig(){
	ScummVM_init
	if($?){
		Write-Output "true"
	}
}