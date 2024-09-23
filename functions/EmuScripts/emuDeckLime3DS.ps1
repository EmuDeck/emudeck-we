$Lime3DS_configFile="$emusPath\lime3ds\user\config\qt-config.ini"

function Lime3DS_install(){
	setMSG "Downloading Lime3DS"
	$url_lime3ds = getLatestReleaseURLGH "Lime3DS/Lime3DS" "zip" "windows-msvc"
	download $url_lime3ds "lime3ds.zip"
	$oldName = Get-ChildItem -Path "$temp/lime3ds" -Directory -Filter "lime3ds-*-windows-msvc" | Select-Object -First 1
	$newName = Join-Path -Path "$temp/lime3ds" -ChildPath "lime3ds"
	Rename-Item -Path $oldName.FullName -NewName $newName
	moveFromTo "$temp/lime3ds/lime3ds" "$emusPath/lime3ds"
	rm -r -fo "$temp/lime3ds"
	createLauncher "lime3ds"

}
function Lime3DS_init(){

	setMSG "Lime3DS - Configuration"

	#Esde Fix
	#sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\lime-qt\lime-qt.exe</entry>' '<entry>%ESPATH%\Emulators\lime3ds\lime3ds-gui.exe.exe</entry>'

	$destination="$emusPath\lime3ds\user"
	mkdir $destination -ErrorAction SilentlyContinue

	$destination="$emusPath\lime3ds\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\lime3ds\config" "$destination"

	sedFile "$Lime3DS_configFile" "C:/Emulation" "$emulationPath"
	sedFile "$Lime3DS_configFile" ":\Emulation" ":/Emulation"

	mkdir "$emusPath\lime3ds\user\sysdata"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\lime3ds\user\sysdata"
	$emuSavePath = "$biosPath\lime3ds"
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


	mkdir "$emusPath\lime3ds\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\lime3ds\user\sdmc"
	$emuSavePath = "$emulationPath\saves\lime3ds\saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\lime3ds\user\states"
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
	Remove-Item -path "$emusPath\lime3ds"-recurse -force
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
	$test=Test-Path -Path "$emusPath\lime3ds\lime3ds.exe"
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
