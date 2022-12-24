function Yuzu_install(){
	showNotification -ToastTitle 'Downloading Yuzu'
	download $url_yuzu "yuzu.zip"
	moveFromTo "yuzu\yuzu-windows-msvc" "tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc"
}
function Yuzu_init(){

	showNotification -ToastTitle 'Yuzu - Configuration'
	mkdir 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user' -ErrorAction SilentlyContinue
	$destination=tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\EmuDeck\backend\configs\yuzu" "$destination"
	
	sedFile $destination\config\qt-config.ini "/run/media/mmcblk0p1/Emulation" $EmulationPath
	sedFile $destination\config\qt-config.ini "/" "\"
	
	showNotification -ToastTitle 'Yuzu - Downloading Microsoft Visual C++ 2022'
	download "https://aka.ms/vs/17/release/vc_redist.x64.exe" "tools/vc_redist.x64.exe"	
	.\tools\vc_redist.x64.exe
	
	showNotification -ToastTitle 'Yuzu - Creating Keys & Firmware Links'
	#Firmware
	$SourceFilePath = -join($userFolder, 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered')
	$ShortcutPath = -join($EmulationPath,'bios\yuzu\keys.lnk')
	mkdir 'bios\yuzu' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#Keys
	$SourceFilePath = -join($userFolder, 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\keys')
	$ShortcutPath = -join($EmulationPath,'bios\yuzu\firmware.lnk')
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
	showNotification -ToastTitle 'Yuzu - Saves Links'
	$SourceFilePath = -join($userFolder, 'tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\user\nand\user\save')
	$ShortcutPath = -join($EmulationPath,'saves\yuzu\saves.lnk')
	mkdir 'saves\yuzu' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}
function Yuzu_setupStorage(){
	mkdir $EmulationPath\storage\yuzu\screenshots -ErrorAction SilentlyContinue
	mkdir $EmulationPath\storage\yuzu\dump -ErrorAction SilentlyContinue
	mkdir $EmulationPath\storage\yuzu\load -ErrorAction SilentlyContinue
	mkdir $EmulationPath\storage\yuzu\nand -ErrorAction SilentlyContinue
	mkdir $EmulationPath\storage\yuzu\sdmc -ErrorAction SilentlyContinue
	mkdir $EmulationPath\storage\yuzu\tas -ErrorAction SilentlyContinue
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
	echo "NYI"
}
function Yuzu_resetConfig(){
	echo "NYI"
}