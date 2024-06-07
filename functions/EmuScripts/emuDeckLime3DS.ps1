$Lime3DS_configFile="$emusPath\lime-qt\user\config\qt-config.ini"

function Lime3DS_install(){
	setMSG "Downloading Lime3DS"
	$url_lime3ds = getLatestReleaseURLGH "Lime3DS/Lime3DS" "zip" "windows-msvc"
	download $url_lime3ds "lime3ds.zip"
	$oldName = Get-ChildItem -Path "$temp/lime3ds" -Directory -Filter "lime3ds-*-windows-msvc" | Select-Object -First 1
	$newName = Join-Path -Path "$temp/lime3ds" -ChildPath "lime-qt"
	Rename-Item -Path $oldName.FullName -NewName $newName
	moveFromTo "$temp/lime3ds/lime-qt" "$emusPath/lime-qt"
	rm -r -fo "$temp/lime3ds"

}
function Lime3DS_init(){

	setMSG "Lime3DS - Configuration"
	$destination="$emusPath\lime-qt\user"
	mkdir $destination -ErrorAction SilentlyContinue

	$destination="$emusPath\lime-qt\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\lime3ds\config" "$destination"

	sedFile "$Lime3DS_configFile" "C:/Emulation" "$emulationPath"
	sedFile "$Lime3DS_configFile" ":\Emulation" ":/Emulation"

	mkdir "$emusPath\lime-qt\user\sysdata"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\lime-qt\user\sysdata"
	$emuSavePath = "$biosPath\lime-qt"
	createSaveLink $simLinkPath $emuSavePath

#	Lime3DS_setupSaves
}
function Lime3DS_update(){
	Write-Output "NYI"
}
function Lime3DS_setEmulationFolder(){
	Write-Output "NYI"
}
function Lime3DS_setupSaves(){
	setMSG "Lime3DS - Saves Links"

	#Saves migration
	$test=Test-Path -Path "$emulationPath\saves\citra"
	if($test){
		Rename-Item -Path "$emulationPath\saves\citra" -NewName "$emulationPath\saves\lime3ds"
	}


	mkdir "$emusPath\lime-qt\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\lime-qt\user\sdmc"
	$emuSavePath = "$emulationPath\saves\lime3ds\saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\lime-qt\user\states"
	$emuSavePath = "$emulationPath\saves\lime3ds\states"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\citra"
}
function Lime3DS_setupStorage(){
	Write-Output "NYI"
}

function Lime3DS_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}

	setConfig "resolution_factor" $multiplier "$Lime3DS_configFile"
}

function Lime3DS_wipe(){
	Write-Output "NYI"
}
function Lime3DS_uninstall(){
	Remove-Item -path "$emusPath\lime-qt"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Lime3DS_migrate(){
	Write-Output "NYI"
}
function Lime3DS_setABXYstyle(){
	Write-Output "NYI"
}
function Lime3DS_wideScreenOn(){
	Write-Output "NYI"
}
function Lime3DS_wideScreenOff(){
	Write-Output "NYI"
}
function Lime3DS_bezelOn(){
	Write-Output "NYI"
}
function Lime3DS_bezelOff(){
	Write-Output "NYI"
}
function Lime3DS_finalize(){
	Write-Output "NYI"
}
function Lime3DS_IsInstalled(){
	$test=Test-Path -Path "$emusPath\lime-qt\lime3ds-gui.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Lime3DS_resetConfig(){
	Lime3DS_init
	if($?){
		Write-Output "true"
	}
}
