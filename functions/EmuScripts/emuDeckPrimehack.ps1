function Primehack_install(){
	Write-Output "true"
}
function Primehack_init(){
	Write-Output "true"
}
function Primehack_update(){
	Write-Output "true"
}
function Primehack_setEmulationFolder(){
	Write-Output "true"
}
function Primehack_setupSaves(){
	Write-Output "true"
}
function Primehack_setupStorage(){
	Write-Output "true"
}
function Primehack_wipe(){
	Write-Output "true"
}
function Primehack_uninstall(){
	Remove-Item –path "$emusPath\primehack" –recurse -force
}
function Primehack_migrate(){
	Write-Output "true"
}
function Primehack_setABXYstyle(){
	Write-Output "true"
}
function Primehack_wideScreenOn(){
	Write-Output "true"
}
function Primehack_wideScreenOff(){
	Write-Output "true"
}
function Primehack_bezelOn(){
	Write-Output "true"
}
function Primehack_bezelOff(){
	Write-Output "true"
}
function Primehack_finalize(){
	Write-Output "true"
}
function Primehack_IsInstalled(){
	Write-Output "true"
}
function Primehack_resetConfig(){
	Write-Output "true"
}