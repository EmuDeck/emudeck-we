function template_install(){
	Write-Output "NYI"
}
function template_init(){
	Write-Output "NYI"
}
function template_update(){
	Write-Output "NYI"
}
function template_setEmulationFolder(){
	Write-Output "NYI"
}
function template_setupSaves(){
	Write-Output "NYI"
}
function template_setupStorage(){
	Write-Output "NYI"
}
function template_wipe(){
	Write-Output "NYI"
}
function template_uninstall(){
	Remove-Item –path "$emusPath\template" –recurse -force
	if($?){
		Write-Output "true"
	}
}
function template_migrate(){
	Write-Output "NYI"
}
function template_setABXYstyle(){
	Write-Output "NYI"
}
function template_wideScreenOn(){
	Write-Output "NYI"
}
function template_wideScreenOff(){
	Write-Output "NYI"
}
function template_bezelOn(){
	Write-Output "NYI"
}
function template_bezelOff(){
	Write-Output "NYI"
}
function template_finalize(){
	Write-Output "NYI"
}
function template_IsInstalled(){
	$test=Test-Path -Path "$emusPath\template"
	if($test){
		Write-Output "true"
	}
}
function template_resetConfig(){
	Write-Output "NYI"
}