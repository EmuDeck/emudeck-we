function Flycast_install(){
	Write-Output "NYI"
}
function Flycast_init(){
	Write-Output "NYI"
}
function Flycast_update(){
	Write-Output "NYI"
}
function Flycast_setEmulationFolder(){
	Write-Output "NYI"
}
function Flycast_setupSaves(){
	Write-Output "NYI"
}
function Flycast_setupStorage(){
	Write-Output "NYI"
}
function Flycast_wipe(){
	Write-Output "NYI"
}
function Flycast_uninstall(){
	Remove-Item –path "$emusPath\Flycast" –recurse -force
	if($?){
		Write-Output "true"
	}
}
function Flycast_migrate(){
	Write-Output "NYI"
}
function Flycast_setABXYstyle(){
	Write-Output "NYI"
}
function Flycast_wideScreenOn(){
	Write-Output "NYI"
}
function Flycast_wideScreenOff(){
	Write-Output "NYI"
}
function Flycast_bezelOn(){
	Write-Output "NYI"
}
function Flycast_bezelOff(){
	Write-Output "NYI"
}
function Flycast_finalize(){
	Write-Output "NYI"
}
function Flycast_IsInstalled(){
	$test=Test-Path -Path "$emusPath\Flycast"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Flycast_resetConfig(){
	Write-Output "NYI"
}