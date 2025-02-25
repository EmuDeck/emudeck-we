$Citra_configFile="$emusPath\citra\user\config\qt-config.ini"

function Citra_install(){
	setMSG "Downloading Citra"
	$url_citra = getLatestReleaseURLGH "PabloMK7/citra" "7z" "windows-msvc"
	download $url_citra "citra.7z"
	moveFromTo "$temp/citra/head" "$emusPath\citra"
	Remove-Item -Recurse -Force citra -ErrorAction SilentlyContinue
	mkdir "$emusPath\citra\user" -ErrorAction SilentlyContinue
	createLauncher "citra"
}
function Citra_init(){

	setMSG "Citra - Configuration"
	$destination="$emusPath\citra\user"
	mkdir $destination -ErrorAction SilentlyContinue

	$destination="$emusPath\citra\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\citra\config" "$destination"

	sedFile "$Citra_configFile" "C:/Emulation" "$emulationPath"
	sedFile "$Citra_configFile" ":\Emulation" ":/Emulation"

	mkdir "$emusPath\citra\user\sysdata"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\citra\user\sysdata"
	$emuSavePath = "$biosPath\citra"
	createSaveLink $simLinkPath $emuSavePath

	Citra_setupSaves
}
function Citra_update(){
	Write-Output "NYI"
}
function Citra_setEmulationFolder(){
	Write-Output "NYI"
}
function Citra_setupSaves(){
	setMSG "Citra - Saves Links"
	mkdir "$emusPath\citra\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\citra\user\sdmc"
	$emuSavePath = "$emulationPath\saves\citra\saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\citra\user\states"
	$emuSavePath = "$emulationPath\saves\citra\states"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\citra"
}
function Citra_setupStorage(){
	Write-Output "NYI"
}

function Citra_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}

	setConfig "resolution_factor" $multiplier "$Citra_configFile"
}

function Citra_wipe(){
	Write-Output "NYI"
}
function Citra_uninstall(){
	Remove-Item -path "$emusPath\citra"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Citra_migrate(){
	Write-Output "NYI"
}
function Citra_setABXYstyle(){
	Write-Output "NYI"
}
function Citra_wideScreenOn(){
	Write-Output "NYI"
}
function Citra_wideScreenOff(){
	Write-Output "NYI"
}
function Citra_bezelOn(){
	Write-Output "NYI"
}
function Citra_bezelOff(){
	Write-Output "NYI"
}
function Citra_finalize(){
	Write-Output "NYI"
}
function Citra_IsInstalled(){
	$test=Test-Path -Path "$emusPath\citra\citra.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Citra_resetConfig(){
	Citra_init
	if($?){
		Write-Output "true"
	}
}
