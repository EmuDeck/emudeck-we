$Azahar_configFile="$emusPath\azahar\user\config\qt-config.ini"

function Azahar_install(){
	setMSG "Downloading Azahar"
	$url_azahar = getLatestReleaseURLGH "azahar-emu/azahar" "zip" "windows-msvc"
	#$url_azahar = "https://github.com/azahar-emu/azahar/releases/download/2120-rc3/azahar-2120-rc3-windows-msvc.zip"
	download $url_azahar "azahar.zip"
	$oldName = Get-ChildItem -Path "$temp/azahar" -Directory -Filter "azahar-*-windows-msvc" | Select-Object -First 1
	$newName = Join-Path -Path "$temp/azahar" -ChildPath "azahar"
	Rename-Item -Path $oldName.FullName -NewName $newName
	moveFromTo "$temp/azahar/azahar" "$emusPath/azahar"
	rm -r -fo "$temp/azahar"
	createLauncher "azahar"

}
function Azahar_init(){

	setMSG "Azahar - Configuration"

	$destination="$emusPath\azahar\user"
	mkdir $destination -ErrorAction SilentlyContinue

	$destination="$emusPath\azahar\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\azahar\config" "$destination"

	sedFile "$Azahar_configFile" "C:/Emulation" "$emulationPath"
	sedFile "$Azahar_configFile" ":\Emulation" ":/Emulation"

	mkdir "$emusPath\azahar\user\sysdata"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\azahar\user\sysdata"
	$emuSavePath = "$biosPath\azahar"
	createSaveLink $simLinkPath $emuSavePath

	Azahar_setupSaves

	Azahar_migrate

	ESDE_refreshCustomEmus

	ESDE_setEmu 'Azahar (Standalone)' n3ds

	SRM_createParsers

}
function Azahar_update(){
	Write-Output "NYI"
}
function Azahar_setEmulationFolder(){
	Write-Output "NYI"
}
function Azahar_setupSaves(){
	setMSG "Azahar - Saves Links"

	#Saves migration
	$test=Test-Path -Path "$emulationPath\saves\citra"
	if($test){
		Rename-Item -Path "$emulationPath\saves\citra" -NewName "$emulationPath\saves\azahar"
	}


	mkdir "$emusPath\azahar\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\azahar\user\sdmc"
	$emuSavePath = "$emulationPath\saves\azahar\saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\azahar\user\states"
	$emuSavePath = "$emulationPath\saves\azahar\states"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\citra"
}
function Azahar_setupStorage(){
	Write-Output "NYI"
}

function Azahar_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}

	setConfig "resolution_factor" $multiplier "$Azahar_configFile"
}

function Azahar_wipe(){
	Write-Output "NYI"
}
function Azahar_uninstall(){
	Remove-Item -path "$emusPath\azahar"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Azahar_migrate(){

	# Launcher
	rm -fo -r "$toolsPath/launchers/citra.ps1"
	rm -fo -r "$toolsPath/launchers/lime3ds.ps1"

	$simLinkPath = "$toolsPath/launchers/lime3ds.ps1"
	$emuSavePath = "$toolsPath/launchers/azahar.ps1"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$toolsPath/launchers/citra.ps1"
	$emuSavePath = "$toolsPath/launchers/azahar.ps1"
	createSaveLink $simLinkPath $emuSavePath
}

function Azahar_setABXYstyle(){
	Write-Output "NYI"
}
function Azahar_wideScreenOn(){
	Write-Output "NYI"
}
function Azahar_wideScreenOff(){
	Write-Output "NYI"
}
function Azahar_bezelOn(){
	Write-Output "NYI"
}
function Azahar_bezelOff(){
	Write-Output "NYI"
}
function Azahar_finalize(){
	Write-Output "NYI"
}
function Azahar_IsInstalled(){
	$test=Test-Path -Path "$emusPath\azahar\azahar.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Azahar_resetConfig(){
	Azahar_init
	if($?){
		Write-Output "true"
	}
}
