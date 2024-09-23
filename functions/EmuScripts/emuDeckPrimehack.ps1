$Primehack_configFile="$emusPath\primehack\User\Config\Dolphin.ini"

function Primehack_install(){
	setMSG "Downloading PrimeHack"
	#$url_primehack = getLatestReleaseURLGH "shiiion/dolphin" "zip" "zip"
	$url_primehack = "https://github.com/shiiion/dolphin/releases/download/1.0.7a/PrimeHack.Release.v1.0.7a.zip"
	download $url_primehack "PrimeHack.zip"
	moveFromTo "$temp\PrimeHack" "$emusPath\PrimeHack"
	createLauncher "PrimeHack"
}
function Primehack_init(){
	setMSG "Dolphin - Configuration"
	New-Item -Path "$emusPath\primehack\portable.txt" -ErrorAction SilentlyContinue
	$destination="$emusPath\primehack"
	mkdir $destination -ErrorAction SilentlyContinue

	$destination="$emusPath\primehack"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\primehack" "$destination"
	#Bios Path
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/roms/" "$romsPath"
	sedFile $destination\User\Config\Dolphin.ini "/" '\'

#	Dolphin_setupSaves
	#Dolphin_DynamicInputTextures
	Primehack_setResolution $dolphinResolution
}
function Primehack_update(){
	Write-Output "true"
}
#function Primehack_setEmulationFolder(){
#	gameDirOpt='ISOPath0 = '
#	newGameDirOpt='ISOPath0 = '"${romsPath}/primehack"
#	mkdir newGameDirOpt -ErrorAction SilentlyContinue
#	sedFile "$Primehack_configFile" "$gameDirOpt" $newGameDirOpt"
#}

function Primehack_setupSaves(){
	setMSG "Dolphin - Creating Saves Links"

	#Saves GC
	mkdir "$emusPath\primehack\User" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\primehack\User\GC"
	$emuSavePath = "$emulationPath\saves\primehack\GC"
	createSaveLink $simLinkPath $emuSavePath

	#Saves Wii
	$simLinkPath = "$emusPath\primehack\User\Wii"
	$emuSavePath = "$emulationPath\saves\primehack\Wii"
	createSaveLink $simLinkPath $emuSavePath

	#States
	$simLinkPath = "$emusPath\primehack\User\StateSaves"
	$emuSavePath = "$emulationPath\saves\primehack\states"
	createSaveLink $simLinkPath $emuSavePath
}
function Primehack_setResolution(){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2 }
		"1080P" { $multiplier = 3    }
		"1440P" { $multiplier = 4   }
		"4K" { $multiplier = 6 }
	}
	setConfig "InternalResolution" $multiplier "$emusPath\primehack\User\Config\GFX.ini"
}

function Primehack_setupStorage(){
	Write-Output "true"
}
function Primehack_wipe(){
	Write-Output "true"
}
function Primehack_uninstall(){
	Remove-Item -path "$emusPath\primehack"-recurse -force
	if($?){
		Write-Output "true"
	}
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
	$test=Test-Path -Path "$emusPath\primehack"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Primehack_resetConfig(){
	Primehack_init
	if($?){
		Write-Output "true"
	}
}