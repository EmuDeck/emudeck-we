function PCSX2_install(){
	setMSG "Downloading PCSX2"
	winget install Microsoft.VCRedist.2015+.x86 --accept-package-agreements --accept-source-agreements
	download $url_pcsx2 "pcsx2.7z"
	moveFromTo "$temp/pcsx2/pcsx2" "$emusPath\PCSX2-Qt"
	Remove-Item -Recurse -Force pcsx2 -ErrorAction SilentlyContinue
	createLauncher "pcsx2"
}
function PCSX2_init(){	
	setMSG "PCSX2 - Configuration"
	$destination="$emusPath\PCSX2-Qt"
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\PCSX2" $destination
	
	sedFile $destination\inis\PCSX2_ui.ini "/run/media/mmcblk0p1/Emulation" "$emulationPath"
	sedFile $destination\inis\PCSX2_ui.ini "/home/deck/.var/app/net.pcsx2.PCSX2/config/PCSX2" $emusPath\PCSX2-Qt
	sedFile $destination\inis\PCSX2-reg.ini "/home/deck/.var/app/net.pcsx2.PCSX2/config/PCSX2" $emusPath\PCSX2-Qt
	
	sedFile $destination\inis\PCSX2_ui.ini "/" "\"
	sedFile $destination\inis\PCSX2-reg.ini "/" "\"	
	sedFile $destination\inis\PCSX2_ui.ini "C:\" "\\"
	
	PCSX2_setupSaves
	PCSX2_setResolution $pcsx2Resolution
	
}
function PCSX2_update(){
	echo "NYI"
}
function PCSX2_setEmulationFolder(){
	echo "NYI"
}
function PCSX2_setupSaves(){
	#Saves
	setMSG "PCSX2 - Saves Links"
	mkdir saves/PCSX2 -ErrorAction SilentlyContinue
	$SourceFilePath = "$emusPath\PCSX2-Qt\memcards"
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\PCSX2\saves.lnk")
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = "$emusPath\PCSX2-Qt\sstates"
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\PCSX2\states.lnk")
	createLink $SourceFilePath $ShortcutPath
}
function PCSX2_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2 }
		"1080P" { $multiplier = 3    }
		"1440P" { $multiplier = 4   }
		"4K" { $multiplier = 6 }
	}	
	
	setConfig "upscale_multiplier" $multiplier "$emusPath\PCSX2-Qt\inis\PCSX2.ini"
}
function PCSX2_setupStorage(){
	echo "NYI"
}
function PCSX2_wipe(){
	echo "NYI"
}
function PCSX2_uninstall(){
	echo "NYI"
}
function PCSX2_migrate(){
	echo "NYI"
}
function PCSX2_setABXYstyle(){
	echo "NYI"
}
function PCSX2_wideScreenOn(){
	echo "NYI"
}
function PCSX2_wideScreenOff(){
	echo "NYI"
}
function PCSX2_bezelOn(){
	echo "NYI"
}
function PCSX2_bezelOff(){
	echo "NYI"
}
function PCSX2_finalize(){
	echo "NYI"
}
function PCSX2_IsInstalled(){
	$test=Test-Path -Path "$emusPath\PCSX2-Qt"
	if($test){
		echo "true"
	}
}
function PCSX2_resetConfig(){
	PCSX2_init
	if($?){
		echo "true"
	}
}


function PCSX2_retroAchievementsSetLogin(){	
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	setConfig "Token" $rat "$emusPath\PCSX2-Qt\inis\PCSX2.ini"		
}
