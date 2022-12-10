function Yuzu_install(){
	showNotification -ToastTitle 'Downloading Yuzu'
	download $url_yuzu "yuzu.zip"
	moveFromTo "yuzu\yuzu-windows-msvc" "tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc"
}
function Yuzu_init(){
	showNotification -ToastTitle 'Yuzu - Downloading Microsoft Visual C++ 2022'
	download "https://aka.ms/vs/17/release/vc_redist.x64.exe" "tools/vc_redist.x64.exe"	
	.\tools\vc_redist.x64.exe
	
	showNotification -ToastTitle 'Yuzu - Creating Keys & Firmware Links'
	#Firmware
	$SourceFilePath = -join($userFolder, '\AppData\Roaming\yuzu\nand\system\Contents\registered')
	$ShortcutPath = -join($EmulationPath,'bios\yuzu\keys.lnk')
	mkdir 'bios\yuzu' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#Keys
	$SourceFilePath = -join($userFolder, '\AppData\Roaming\yuzu\keys')
	$ShortcutPath = -join($EmulationPath,'bios\yuzu\firmware.lnk')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}
function Yuzu_update(){
	echo "NYI"
}
function Yuzu_setEmulationFolder(){
	echo "NYI"
}
function Yuzu_setupSaves(){
	echo "NYI"
}
function Yuzu_setupStorage(){
	echo "NYI"
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