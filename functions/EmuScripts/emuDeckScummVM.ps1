function ScummVM_install(){
	Write-Output "NYI"
}
function ScummVM_init(){
	Write-Output "NYI"
}
function ScummVM_update(){
	Write-Output "NYI"
}
function ScummVM_setEmulationFolder(){
	Write-Output "NYI"
}
function ScummVM_setupSaves(){
	Write-Output "NYI"
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
	$test=Test-Path -Path "$emusPath\ScummVM"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function ScummVM_resetConfig(){
	Write-Output "NYI"
}