$Dolphin_emuName="Dolphin"
$Dolphin_emuType="FlatPak"
$Dolphin_emuPath="org.DolphinEmu.dolphin-emu"
$Dolphin_releaseURL=""


function Dolphin_install(){
	setMSG "Downloading Dolphin"
	download $url_dolphin "dolphin.7z"
	moveFromTo "$temp/dolphin/Dolphin-x64" "$emusPath\Dolphin-x64"
	Remove-Item -Recurse -Force dolphin -ErrorAction SilentlyContinue
	createLauncher "dolphin"

}
function Dolphin_init(){
	setMSG "Dolphin - Configuration"
	New-Item -Path "$emusPath\Dolphin-x64\portable.txt" -ErrorAction SilentlyContinue
	$destination="$emusPath\Dolphin-x64"
	mkdir $destination -ErrorAction SilentlyContinue

	$destination="$emusPath\Dolphin-x64"
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\Dolphin" "$destination"
	#Bios Path
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/" "$emulationPath"
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/roms/gamecube" "$emulationPath\roms\gamecube"
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/roms/wii" "$emulationPath\roms\wii"

	sedFile $destination\User\Config\Dolphin.ini "Emulation" "Emulation\"

	sedFile $destination\User\Config\Dolphin.ini "/" "\"

#	Dolphin_setupSaves
	Dolphin_DynamicInputTextures
	Dolphin_setResolution $dolphinResolution


	if ( "$arDolphin" -eq 169 ){
		Dolphin_wideScreenOn
	}else{
		Dolphin_wideScreenOff
	}

}
function Dolphin_update(){
	Write-Output "NYI"
}
function Dolphin_setEmulationFolder(){
	Write-Output "NYI"
}
function Dolphin_setupSaves(){
	setMSG "Dolphin - Creating Saves Links"
	#Saves GC
	mkdir "$emusPath\Dolphin-x64\User\"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\Dolphin-x64\User\GC"
	$emuSavePath = -join($emulationPath,"\saves\dolphin\GC")
	createSaveLink $simLinkPath $emuSavePath

	#Saves Wii
	$simLinkPath = "$emusPath\Dolphin-x64\User\Wii"
	$emuSavePath = -join($emulationPath,"\saves\dolphin\Wii")
	createSaveLink $simLinkPath $emuSavePath


	#States
	$simLinkPath = "$emusPath\Dolphin-x64\User\StateSaves"
	$emuSavePath = -join($emulationPath,"\saves\dolphin\states")
	createSaveLink $simLinkPath $emuSavePath

	#cloud_sync_save_hash "$savesPath\dolphin"
}

function Dolphin_setResolution($resolution){

	switch ( $resolution )
	{
		"720P" { $multiplier = 2 }
		"1080P" { $multiplier = 3    }
		"1440P" { $multiplier = 4   }
		"4K" { $multiplier = 6 }
	}

	setConfig "InternalResolution" $multiplier "$emusPath\Dolphin-x64\User\Config\GFX.ini"

}

function Dolphin_setupStorage(){
	Write-Output "NYI"
}
function Dolphin_wipe(){
	Write-Output "NYI"
}
function Dolphin_uninstall(){
	Remove-Item –path "$emusPath\Dolphin" –recurse -force
}
function Dolphin_migrate(){
	Write-Output "NYI"
}
function Dolphin_setABXYstyle(){
	Write-Output "NYI"
}
function Dolphin_wideScreenOn(){
	setMSG "Dolphin Widescreen On"
	Write-Output ""
	$configFile="$emusPath\Dolphin-x64\User\Config\GFX.ini"
	$wideScreenHack="wideScreenHack"
	$wideScreenHackSetting="wideScreenHack = True"
	$AspectRatio="AspectRatio"

	setSettingNoQuotes $configFile $wideScreenHack "True"
	setSettingNoQuotes $configFile $AspectRatio "1"

}
function Dolphin_wideScreenOff(){
	setMSG "Dolphin Widescreen Of"
	Write-Output ""
	$configFile="$emusPath\Dolphin-x64\User\Config\GFX.ini"
	$wideScreenHack="wideScreenHack"
	$wideScreenHackSetting="wideScreenHack = True"
	$AspectRatio="AspectRatio"

	setSettingNoQuotes $configFile $wideScreenHack "False"
	setSettingNoQuotes $configFile $AspectRatio "0"
}
function Dolphin_bezelOn(){
	Write-Output "NYI"
}
function Dolphin_bezelOff(){
	Write-Output "NYI"
}
function Dolphin_finalize(){
	Write-Output "NYI"
}
function Dolphin_IsInstalled(){
	$test=Test-Path -Path "$emusPath\Dolphin-x64"
	if($test){
		Write-Output "true"
	}
}
function Dolphin_resetConfig(){
	Dolphin_init
	if($?){
		Write-Output "true"
	}
}


function Dolphin_DynamicInputTextures(){
Write-Output "nope"
  #$DIT_releaseURL = getLatestReleaseURLGH "Venomalia/UniversalDynamicInput" "7z"
  #mkdir "$emusPath\Dolphin-x64\User\Load" -ErrorAction SilentlyContinue
  #download $DIT_releaseURL "UniversalDynamicInput.7z"
  #moveFromTo "$temp/UniversalDynamicInput" "$emusPath\Dolphin-x64\User\Load"
}
