$Flycast_configFile="$EmusPath\flycast\emu.cfg"

function Flycast_install(){
	Write-Output "NYI"
	setMSG "Downloading Flycast"
	$url_flycast = getLatestReleaseURLGH "flyinghead/flycast" "zip" "win64"
	download $url_flycast "flycast.zip"
	mkdir "$emusPath\flycast" -ErrorAction SilentlyContinue
	Move-Item -Path "$temp\flycast\flycast.exe" -Destination "$EmusPath\flycast"
	createLauncher "Flycast"
}
function Flycast_init(){
	Flycast_setupStorage
	Flycast_setEmulationFolder
	#Flycast_setupSaves
}
function Flycast_update(){
	Write-Output "NYI"
}
function Flycast_setEmulationFolder(){
	$ContentPathSetting='Dreamcast.ContentPath = '
	changeLine "$ContentPathSetting" "$ContentPathSetting""$romsPath/dreamcast" "$Flycast_configFile"

	#Setup symlink for bios
	mkdir "${biosPath}/flycast/" -ErrorAction SilentlyContinue
	#createSymlink "${biosPath}/flycast/"

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
	$test=Test-Path -Path "$emusPath\Flycast\flycast.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Flycast_resetConfig(){
	Write-Output "NYI"
}