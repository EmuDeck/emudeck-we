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

	Dolphin_setupSaves
	Dolphin_DynamicInputTextures
	Dolphin_setResolution $dolphinResolution
	
}
function Dolphin_update(){
	echo "NYI"
}
function Dolphin_setEmulationFolder(){
	echo "NYI"
}
function Dolphin_setupSaves(){
	setMSG "Dolphin - Creating Saves Links"
	#Saves GC
	$SourceFilePath = "$emusPath\Dolphin-x64\User\GC"
	$ShortcutPath = -join($emulationPath,"\saves\dolphin\GC.lnk")
	mkdir "saves\dolphin" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#Saves Wii
	$SourceFilePath = "$emusPath\Dolphin-x64\User\WII"
	$ShortcutPath = -join($emulationPath,"\saves\dolphin\WII.lnk")
	rm -fo  $ShortcutPath -Recurse -ErrorAction SilentlyContinue
	mkdir "saves\dolphin" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = "$emusPath\Dolphin-x64\User\StateSaves"
	$ShortcutPath = -join($emulationPath,"\saves\dolphin\states.lnk")
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
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
	$configFile="$emusPath\Dolphin-x64\User\Config\GFX.ini"
	$wideScreenHack="wideScreenHack = "
	$wideScreenHackSetting="wideScreenHack = True"
	$aspectRatio="AspectRatio = "
	$aspectRatioSetting="AspectRatio = 1"
	sedFile $configFile $wideScreenHack $wideScreenHackSetting
	sedFile $configFile $aspectRatio $aspectRatioSetting

}
function Dolphin_wideScreenOff(){
	setMSG "Dolphin Widescreen Of"
	echo ""
	$configFile="$emusPath\Dolphin-x64\User\Config\GFX.ini"
	$wideScreenHack="wideScreenHack = "
	$wideScreenHackSetting="wideScreenHack = False"
	$aspectRatio="AspectRatio = "
	$aspectRatioSetting="AspectRatio = 0"
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
	$test=Test-Path -Path "$emusPath\Dolphin-x64"
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
echo "nope"
  #$DIT_releaseURL = getLatestReleaseURLGH "Venomalia/UniversalDynamicInput" "7z"
  #mkdir "$emusPath\Dolphin-x64\User\Load" -ErrorAction SilentlyContinue
  #download $DIT_releaseURL "UniversalDynamicInput.7z"
  #moveFromTo "$temp/UniversalDynamicInput" "$emusPath\Dolphin-x64\User\Load"	
}