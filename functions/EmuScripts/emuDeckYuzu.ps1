Yuzu_install(){
	showNotification -ToastTitle 'Downloading Yuzu'
	download $url_yuzu "yuzu.zip"
	moveFromTo "yuzu\yuzu-windows-msvc" "tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc"
}
Yuzu_init(){
	showNotification -ToastTitle 'Yuzu - Downloading Microsoft Visual C++ 2022'
	download "https://aka.ms/vs/17/release/vc_redist.x64.exe" "tools/vc_redist.x64.exe"
	.\tools/vc_redist.x64.exe
	
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
Yuzu_update(){
	echo "NYI"
}
Yuzu_setEmulationFolder(){
	echo "NYI"
}
Yuzu_setupSaves(){
	echo "NYI"
}
Yuzu_setupStorage(){
	echo "NYI"
}
Yuzu_wipe(){
	echo "NYI"
}
Yuzu_uninstall(){
	echo "NYI"
}
Yuzu_migrate(){
	echo "NYI"
}
Yuzu_setABXYstyle(){
	echo "NYI"
}
Yuzu_wideScreenOn(){
	echo "NYI"
}
Yuzu_wideScreenOff(){
	echo "NYI"
}
Yuzu_bezelOn(){
	echo "NYI"
}
Yuzu_bezelOff(){
	echo "NYI"
}
Yuzu_finalize(){
	echo "NYI"
}
Yuzu_IsInstalled(){
	echo "NYI"
}
Yuzu_resetConfig(){
	echo "NYI"
}