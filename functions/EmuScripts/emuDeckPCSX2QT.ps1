function PCSX2QT_install(){
	setMSG 'Downloading PCSX2'
	download $url_pcsx2 "pcsx2.7z"
	moveFromTo "temp/pcsx2/pcsx2" "tools\EmulationStation-DE\Emulators\PCSX2-Qt"
	Remove-Item -Recurse -Force pcsx2 -ErrorAction SilentlyContinue
	createLauncher "pcsx2"
}
function PCSX2QT_init(){	
	setMSG 'PCSX2 - Configuration'
	$destination="tools\EmulationStation-DE\Emulators\PCSX2-Qt"
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\PCSX2" $destination
	
	sedFile $destination\inis\PCSX2QT_ui.ini "/run/media/mmcblk0p1/Emulation" "$emulationPath"
	sedFile $destination\inis\PCSX2QT_ui.ini "/home/deck/.var/app/net.pcsx2.PCSX2/config/PCSX2" $emulationPath\tools\EmulationStation-DE\Emulators\PCSX2-Qt
	sedFile $destination\inis\PCSX2-reg.ini "/home/deck/.var/app/net.pcsx2.PCSX2/config/PCSX2" $emulationPath\tools\EmulationStation-DE\Emulators\PCSX2-Qt
	
	sedFile $destination\inis\PCSX2QT_ui.ini "/" "\"
	sedFile $destination\inis\PCSX2-reg.ini "/" "\"	
	sedFile $destination\inis\PCSX2QT_ui.ini "C:\" "\\"
	
	
	#$test=Test-Path -Path "$emulationPath\tools\vc_redist.x86.exe"
	#if(-not($test)){
		#setMSG 'PCSX2 - Downloading Microsoft Visual C++ 2022 x86'
		##Win7
		##download "https://aka.ms/vs/17/release/vc_redist.x86.exe" "tools/vc_redist.x86.exe"	
		##.\tools\vc_redist.x86.exe
		winget install Microsoft.VCRedist.2015+.x86 --accept-package-agreements --accept-source-agreements
	#}
	

	
	PCSX2QT_setupSaves
	
}
function PCSX2QT_update(){
	echo "NYI"
}
function PCSX2QT_setEmulationFolder(){
	echo "NYI"
}
function PCSX2QT_setupSaves(){
	#Saves
	setMSG 'PCSX2 - Saves Links'
	mkdir saves/PCSX2 -ErrorAction SilentlyContinue
	$SourceFilePath = -join($emulationPath,'\tools\EmulationStation-DE\Emulators\PCSX2-Qt\memcards\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'\saves\PCSX2\saves.lnk')
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = -join($emulationPath,'\tools\EmulationStation-DE\Emulators\PCSX2-Qt\sstates\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'\saves\PCSX2\states.lnk')
	createLink $SourceFilePath $ShortcutPath
}
function PCSX2QT_setResolution($resolution){
	switch ( $resolution )
	{
		'720P' { $multiplier = 2 }
		'1080P' { $multiplier = 3    }
		'1440P' { $multiplier = 4   }
		'4K' { $multiplier = 6 }
	}	
	
	setConfig 'upscale_multiplier' $multiplier 'tools\EmulationStation-DE\Emulators\PCSX2-Qt\inis\PCSX2.ini'
}
function PCSX2QT_setupStorage(){
	echo "NYI"
}
function PCSX2QT_wipe(){
	echo "NYI"
}
function PCSX2QT_uninstall(){
	echo "NYI"
}
function PCSX2QT_migrate(){
	echo "NYI"
}
function PCSX2QT_setABXYstyle(){
	echo "NYI"
}
function PCSX2QT_wideScreenOn(){
	echo "NYI"
}
function PCSX2QT_wideScreenOff(){
	echo "NYI"
}
function PCSX2QT_bezelOn(){
	echo "NYI"
}
function PCSX2QT_bezelOff(){
	echo "NYI"
}
function PCSX2QT_finalize(){
	echo "NYI"
}
function PCSX2QT_IsInstalled(){
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\PCSX2-Qt"
	if($test){
		echo "true"
	}
}
function PCSX2QT_resetConfig(){
	PCSX2QT_init
	if($?){
		echo "true"
	}
}


function PCSX2QT_retroAchievementsSetLogin(){	
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	setConfig 'Token' $rat 'tools\EmulationStation-DE\Emulators\PCSX2-Qt\inis\PCSX2.ini'		
}
