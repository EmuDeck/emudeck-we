function PCSX2QT_install(){
	#$test=Test-Path -Path "$toolsPath\vc_redist.x86.exe"
	winget install Microsoft.VCRedist.2015+.x86 --accept-package-agreements --accept-source-agreements
	setMSG "Downloading PCSX2"
	$url_pcsx2 = getReleaseURLGH "pcsx2/pcsx2" "7z" "symbols"
	download $url_pcsx2 "pcsx2.7z"
	moveFromTo "$temp\pcsx2" "$emusPath\PCSX2-Qt"
	Remove-Item -Recurse -Force $temp\pcsx2 -ErrorAction SilentlyContinue
	createLauncher "pcsx2"
}
function PCSX2QT_init(){	
	setMSG "PCSX2 - Configuration"
	$destination="$emusPath\PCSX2-Qt"
	New-Item -force $emusPath\PCSX2-Qt\portable.ini

	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\PCSX2" $destination
	
	PCSX2QT_setEmulationFolder
	PCSX2QT_setupSaves
	PCSX2QT_setResolution $pcsx2Resolution
}
function PCSX2QT_update(){
	echo "NYI"
}
function PCSX2QT_setEmulationFolder(){
	sedFile $destination\inis\PCSX2.ini "C:\Emulation" "$emulationPath"
}
function PCSX2QT_setupSaves(){
	#Saves
	setMSG "PCSX2 - Saves Links"
	rm -fo "saves\pcsx2" -Recurse -ErrorAction SilentlyContinue
	mkdir saves\pcsx2 -ErrorAction SilentlyContinue
	$SourceFilePath = "$emusPath\PCSX2-Qt\memcards"
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	
	$ShortcutPath = -join($emulationPath,"\saves\pcsx2\saves.lnk")
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = "$emusPath\PCSX2-Qt\sstates\"
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\pcsx2\states.lnk")
	createLink $SourceFilePath $ShortcutPath
}
function PCSX2QT_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2 }
		"1080P" { $multiplier = 3    }
		"1440P" { $multiplier = 4   }
		"4K" { $multiplier = 6 }
	}	
	
	setConfig "upscale_multiplier" $multiplier "$emusPath\PCSX2-Qt\inis\PCSX2.ini"
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
	$test=Test-Path -Path "$emusPath\PCSX2-Qt"
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
	setConfig "Token" $rat "$emusPath\PCSX2-Qt\inis\PCSX2.ini"		
}
