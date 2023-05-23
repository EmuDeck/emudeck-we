$Dolphin_emuName="Dolphin"
$Dolphin_emuType="FlatPak"
$Dolphin_emuPath="org.DolphinEmu.dolphin-emu"
$Dolphin_releaseURL=""


function Dolphin_install(){
	setMSG 'Downloading Dolphin'
	download $url_dolphin "dolphin.7z"
	moveFromTo "$temp/dolphin/Dolphin-x64" "$emusFolder\Dolphin-x64"
	Remove-Item -Recurse -Force dolphin -ErrorAction SilentlyContinue
	createLauncher "dolphin"
	
}
function Dolphin_init(){
	setMSG 'Dolphin - Configuration'
	New-Item -Path "$emusFolder\Dolphin-x64\portable.txt" -ErrorAction SilentlyContinue
	$destination=-join($emulationPath, "\$emusFolder\Dolphin-x64"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\Dolphin" "$destination"

	
	#Bios Path	
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/" "$emulationPath"
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/roms/gamecube" "$emulationPath\roms\gamecube"
	sedFile $destination\User\Config\Dolphin.ini "/run/media/mmcblk0p1/Emulation/roms/wii" "$emulationPath\roms\wii"

	Dolphin_setupSaves
	Dolphin_DynamicInputTextures
}
function Dolphin_update(){
	echo "NYI"
}
function Dolphin_setEmulationFolder(){
	echo "NYI"
}
function Dolphin_setupSaves(){
	setMSG 'Dolphin - Creating Saves Links'
	#Saves GC
	$SourceFilePath = "$emusFolder\Dolphin-x64\User\GC"
	$ShortcutPath = -join($emulationPath,'\saves\dolphin\GC.lnk')
	mkdir 'saves\dolphin' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#Saves Wii
	$SourceFilePath = "$emusFolder\Dolphin-x64\User\Wii"
	$ShortcutPath = -join($emulationPath,'\saves\dolphin\Wii.lnk')
	mkdir 'saves\dolphin' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = "$emusFolder\Dolphin-x64\User\StateSaves"
	$ShortcutPath = -join($emulationPath,'\saves\dolphin\states.lnk')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}

function Dolphin_setResolution($resolution){
	
	switch ( $resolution )
	{
		'720P' { $multiplier = 2 }
		'1080P' { $multiplier = 3    }
		'1440P' { $multiplier = 4   }
		'4K' { $multiplier = 6 }
	}		
	
	setConfig 'InternalResolution' $multiplier "$emusFolder\Dolphin-x64\User\Config\GFX.ini"
	
}

function Dolphin_setupStorage(){
	echo "NYI"
}
function Dolphin_wipe(){
	echo "NYI"
}
function Dolphin_uninstall(){
	echo "NYI"
}
function Dolphin_migrate(){
	echo "NYI"
}
function Dolphin_setABXYstyle(){
	echo "NYI"
}
function Dolphin_wideScreenOn(){
	setMSG "Dolphin Widescreen On"
	echo ""
	$configFile="$emusFolder\Dolphin-x64\User\Config\GFX.ini"
	$wideScreenHack='wideScreenHack = '
	$wideScreenHackSetting='wideScreenHack = True'
	$aspectRatio='AspectRatio = '
	$aspectRatioSetting='AspectRatio = 1'
	sedFile $configFile $wideScreenHack $wideScreenHackSetting
	sedFile $configFile $aspectRatio $aspectRatioSetting

}
function Dolphin_wideScreenOff(){
	setMSG "Dolphin Widescreen Of"
	echo ""
	$configFile="$emusFolder\Dolphin-x64\User\Config\GFX.ini"
	$wideScreenHack='wideScreenHack = '
	$wideScreenHackSetting='wideScreenHack = False'
	$aspectRatio='AspectRatio = '
	$aspectRatioSetting='AspectRatio = 0'
	sedFile $configFile $wideScreenHack $wideScreenHackSetting
	sedFile $configFile $aspectRatio $aspectRatioSetting
}
function Dolphin_bezelOn(){
	echo "NYI"
}
function Dolphin_bezelOff(){
	echo "NYI"
}
function Dolphin_finalize(){
	echo "NYI"
}
function Dolphin_IsInstalled(){
	$test=Test-Path -Path "$emusFolder\Dolphin-x64"
	if($test){
		echo "true"
	}
}
function Dolphin_resetConfig(){
	Dolphin_init
	if($?){
		echo "true"
	}
}


function Dolphin_DynamicInputTextures(){
  $DIT_releaseURL = getLatestReleaseURLGH 'Venomalia/UniversalDynamicInput' '7z'
  mkdir "$toolsPath\EmulationStation-DE\Emulators\Dolphin-x64\User\Load" -ErrorAction SilentlyContinue
  download $DIT_releaseURL "UniversalDynamicInput.7z"
  moveFromTo "$temp/UniversalDynamicInput" "$toolsPath\EmulationStation-DE\Emulators\Dolphin-x64\User\Load"	
}