$ShadPS4_configFile="$emusPath\ShadPS4-qt\user\config.toml"

function ShadPS4_install(){
	setMSG "Downloading ShadPS4"
	$url_ShadPS4 = "https://github.com/shadps4-emu/shadPS4/releases/download/v.0.4.0/shadps4-win64-qt-0.4.0.zip"
	download $url_ShadPS4 "ShadPS4.zip"
	moveFromTo "$temp/ShadPS4" "$emusPath\ShadPS4-qt"
	createLauncher "ShadPS4"
}
function ShadPS4_init(){
	setMSG "ShadPS4 - Configuration"
	$destination="$emusPath\ShadPS4-qt\user"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\ShadPS4-qt" "$destination"
	#ShadPS4_setResolution $ShadPS4Resolution
	ShadPS4_setupStorage
	#ShadPS4_setupSaves
	ShadPS4_setEmulationFolder
}
function ShadPS4_update(){
	Write-Output "NYI"
}
function ShadPS4_setEmulationFolder(){
	sedFile "$ShadPS4_configFile" "/run/media/mmcblk0p1/Emulation/" "$emulationPath"
	sedFile "$ShadPS4_configFile" "\" "/"
	sedFile "$ShadPS4_configFile" "/" "//"
}
function ShadPS4_setResolution($resolution){
	echo "NYI"
}

function ShadPS4_setupSaves(){
	setMSG "ShadPS4 - Saves Links"
	mkdir "$emusPath\shadps4-qt\user"  -ErrorAction SilentlyContinue
	mkdir "$emusPath\shadps4-qt\user\savedata"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\shadps4-qt\user\savedata"
	$emuSavePath = "$emulationPath\saves\shadps4\saves"
	createSaveLink $simLinkPath $emuSavePath
}

function ShadPS4_setupStorage(){
	mkdir "$emulationPath\storage\shadps4\games\"  -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\shadps4\dlc\"  -ErrorAction SilentlyContinue
}
function ShadPS4_wipe(){
	Write-Output "NYI"
}
function ShadPS4_uninstall(){
	Remove-Item -path "$emusPath\ShadPS4-qt"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function ShadPS4_migrate(){
	Write-Output "NYI"
}
function ShadPS4_setABXYstyle(){
	Write-Output "NYI"
}
function ShadPS4_wideScreenOn(){
	Write-Output "NYI"
}
function ShadPS4_wideScreenOff(){
	Write-Output "NYI"
}
function ShadPS4_bezelOn(){
	Write-Output "NYI"
}
function ShadPS4_bezelOff(){
	Write-Output "NYI"
}
function ShadPS4_finalize(){
	Write-Output "NYI"
}
function ShadPS4_IsInstalled(){
	$test=Test-Path -Path "$emusPath\ShadPS4-qt\shadPS4.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function ShadPS4_resetConfig(){
	ShadPS4_init
	if($?){
		Write-Output "true"
	}
}
