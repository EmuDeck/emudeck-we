function mGBA_install(){
	Write-Output "true"
}
function mGBA_init(){
	Write-Output "true"
}
function mGBA_update(){
	Write-Output "true"
}
function mGBA_setEmulationFolder(){
	Write-Output "true"
}
function mGBA_setupSaves(){
	Write-Output "true"
}
function mGBA_setupStorage(){
	Write-Output "true"
}
function mGBA_wipe(){
	Write-Output "true"
}
function mGBA_uninstall(){
	Remove-Item –path "$emusPath\mGBA" –recurse -force
}
function mGBA_migrate(){
	Write-Output "true"
}
function mGBA_setABXYstyle(){
	Write-Output "true"
}
function mGBA_wideScreenOn(){
	Write-Output "true"
}
function mGBA_wideScreenOff(){
	Write-Output "true"
}
function mGBA_bezelOn(){
	Write-Output "true"
}
function mGBA_bezelOff(){
	Write-Output "true"
}
function mGBA_finalize(){
	Write-Output "true"
}
function mGBA_IsInstalled(){
	Write-Output "true"
}
function mGBA_resetConfig(){
	Write-Output "true"
}