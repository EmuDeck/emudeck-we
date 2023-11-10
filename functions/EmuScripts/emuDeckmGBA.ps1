$mGBA_configFile="$emusPath/mgba/config.ini"

function mGBA_install(){
	setMSG "Downloading mGBA"
	#$url_mGBA = getLatestReleaseURLGH "mgba-emu/mgba" "7z" "win64.7z"

	$url_mGBA = "https://github.com/mgba-emu/mgba/releases/download/0.10.1/mGBA-0.10.1-win64.7z"
	download $url_mGBA "mgba.zip"
	moveFromTo "$temp\mgba\mGBA-0.10.1-win64" "$emusPath\mGBA"
	createLauncher "mGBA"
}
function mGBA_init(){
	$destination="$emusPath\mgba"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\mgba" "$destination"
	#mGBA_setupStorage
	mGBA_setEmulationFolder
	#mGBA_setupSaves
	#mGBA_addSteamInputProfile
}
function mGBA_update(){
	Write-Output "true"
}
function mGBA_setEmulationFolder(){
	sedFile $mGBA_configFile "/run/media/mmcblk0p1/Emulation" "$emulationPath"
}
function mGBA_setupSaves(){
	mkdir "$savesPath/mgba/saves" -ErrorAction SilentlyContinue
	mkdir "$savesPath/mgba/states" -ErrorAction SilentlyContinue
}
function mGBA_setupStorage(){
	Write-Output "true"
}
function mGBA_wipe(){
	Write-Output "true"
}
function mGBA_uninstall(){
	Remove-Item –path "$emusPath\mGBA" –recurse -force
	if($?){
		Write-Output "true"
	}
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
	$test=Test-Path -Path "$emusPath\mgba\mgba.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function mGBA_resetConfig(){
	Write-Output "true"
}