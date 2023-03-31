function Yuzu_install(){
	setMSG 'Downloading Yuzu'
	download $url_yuzu "yuzu.zip"
	moveFromTo "temp/yuzu/yuzu-windows-msvc" "tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc"
	Remove-Item -Recurse -Force yuzu -ErrorAction SilentlyContinue
	createLauncher "yuzu"
}
function Yuzu_init(){

	setMSG 'Yuzu - Configuration'
	mkdir 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered' -ErrorAction SilentlyContinue
	mkdir 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\keys' -ErrorAction SilentlyContinue
	
	$destination='tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user'
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\yuzu" "$destination"
	
	sedFile $destination\config\qt-config.ini "C:\Emulation" $emulationPath	
	
	sedFile $destination\config\qt-config.ini ":\\Emulation\roms\" ':/Emulation/roms/'	
	
	#$test=Test-Path -Path "$emulationPath\tools\vc_redist.x64.exe"
	#if(-not($test)){
		#setMSG 'Yuzu - Downloading Microsoft Visual C++ 2022'
		#Win7
		#download "https://aka.ms/vs/17/release/vc_redist.x64.exe" "tools/vc_redist.x64.exe"	
		#.\tools\vc_redist.x64.exe
		
		winget install Microsoft.VCRedist.2015+.x64 --accept-package-agreements --accept-source-agreements
	#}
	
	setMSG 'Yuzu - Creating Keys & Firmware Links'
	#Firmware
	$SourceFilePath = -join($emulationPath, '\tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered')
	$ShortcutPath = -join($emulationPath,'\bios\yuzu\firmware.lnk')
	mkdir 'bios\yuzu' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#Keys
	$SourceFilePath = -join($emulationPath, '\tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\keys')
	$ShortcutPath = -join($emulationPath,'\bios\yuzu\keys.lnk')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	Yuzu_setupStorage
	Yuzu_setupSaves
}
function Yuzu_update(){
	echo "NYI"
}
function Yuzu_setEmulationFolder(){
	echo "NYI"
}
function Yuzu_setupSaves(){
	setMSG 'Yuzu - Saves Links'
	$SourceFilePath = -join($userFolder, '\tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\nand\user\save')
	$ShortcutPath = -join($emulationPath,'\saves\yuzu\saves.lnk')
	mkdir 'saves\yuzu' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}
function Yuzu_setResolution($resolution){
	switch ( $resolution )
{
	'720P' { $multiplier = 2;  $docked='false'}
	'1080P' { $multiplier = 2; $docked='true'   }
	'1440P' { $multiplier = 3;  $docked='false' }
	'4K' { $multiplier = 3; $docked='true' }
}	

setConfig 'resolution_setup' $multiplier 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\config\qt-config.ini'
setConfig 'use_docked_mode' $docked 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\config\qt-config.ini'


}
function Yuzu_setupStorage(){
	mkdir $emulationPath\storage\yuzu\screenshots -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\dump -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\load -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\nand -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\sdmc -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\tas -ErrorAction SilentlyContinue
}
function Yuzu_wipe(){
	echo "NYI"
}
function Yuzu_uninstall(){
	echo "NYI"
}
function Yuzu_migrate(){
	echo "NYI"
}
function Yuzu_setABXYstyle(){
	echo "NYI"
}
function Yuzu_wideScreenOn(){
	echo "NYI"
}
function Yuzu_wideScreenOff(){
	echo "NYI"
}
function Yuzu_bezelOn(){
	echo "NYI"
}
function Yuzu_bezelOff(){
	echo "NYI"
}
function Yuzu_finalize(){
	echo "NYI"
}
function Yuzu_IsInstalled(){
	$test=Test-Path -Path "tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc"
	if($test){
		echo "true"
	}
}
function Yuzu_resetConfig(){
	Yuzu_init
	if($?){
		echo "true"
	}
}