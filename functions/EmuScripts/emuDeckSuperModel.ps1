function SuperModel_install(){
	Write-Output "NYI"
}
function SuperModel_init(){
	Write-Output "NYI"
}
function SuperModel_update(){
	Write-Output "NYI"
}
function SuperModel_setEmulationFolder(){
	Write-Output "NYI"
}
function SuperModel_setupSaves(){
	Write-Output "NYI"
}
function SuperModel_setupStorage(){
	Write-Output "NYI"
}
function SuperModel_wipe(){
	Write-Output "NYI"
}
function SuperModel_uninstall(){
	Remove-Item –path "$emusPath\SuperModel" –recurse -force
	if($?){
		Write-Output "true"
	}
}
function SuperModel_migrate(){
	Write-Output "NYI"
}
function SuperModel_setABXYstyle(){
	Write-Output "NYI"
}
function SuperModel_wideScreenOn(){
	Write-Output "NYI"
}
function SuperModel_wideScreenOff(){
	Write-Output "NYI"
}
function SuperModel_bezelOn(){
	Write-Output "NYI"
}
function SuperModel_bezelOff(){
	Write-Output "NYI"
}
function SuperModel_finalize(){
	Write-Output "NYI"
}
function SuperModel_IsInstalled(){
	$test=Test-Path -Path "$emusPath\SuperModel"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function SuperModel_resetConfig(){
	Write-Output "NYI"
}