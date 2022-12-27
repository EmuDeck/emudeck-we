function Cemu_install(){
	showNotification -ToastTitle 'Downloading Cemu'
	download $url_cemu "cemu.zip"
	moveFromTo "cemu\cemu_1.26.2" "tools\EmulationStation-DE\Emulators\cemu"
	Remove-Item -Recurse -Force cemu -ErrorAction SilentlyContinue
	createLauncher "cemu" "Cemu"

}
function Cemu_init(){
	showNotification -ToastTitle 'Cemu - Configuration'
	copyFromTo "$env:USERPROFILE\EmuDeck\backend\configs\cemu" "tools\EmulationStation-DE\Emulators\cemu"
	
	sedFile "tools\EmulationStation-DE\Emulators\cemu\controllerProfiles\controller0.xml" "DSUController" "XInput"
	#sedFile "tools\EmulationStation-DE\Emulators\cemu\controllerProfiles\Deck-Gamepad-Gyro.xml" "DSUController" "XInput"
	
	
	Cemu_setupSaves
}
function Cemu_update(){
	echo "NYI"
}
function Cemu_setEmulationFolder(){
	echo "NYI"
}
function Cemu_setupSaves(){
	showNotification -ToastTitle 'Cemu - Saves Links'
	$SourceFilePath = "tools\EmulationStation-DE\Emulators\cemu\mlc01\usr\save"
	$ShortcutPath = -join($emulationPath,'saves\cemu\saves.lnk')
	mkdir 'saves\cemu' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}
function Cemu_setupStorage(){
	echo "NYI"
}
function Cemu_wipe(){
	echo "NYI"
}
function Cemu_uninstall(){
	echo "NYI"
}
function Cemu_migrate(){
	echo "NYI"
}
function Cemu_setABXYstyle(){
	echo "NYI"
}
function Cemu_wideScreenOn(){
	echo "NYI"
}
function Cemu_wideScreenOff(){
	echo "NYI"
}
function Cemu_bezelOn(){
	echo "NYI"
}
function Cemu_bezelOff(){
	echo "NYI"
}
function Cemu_finalize(){
	echo "NYI"
}
function Cemu_IsInstalled(){
	echo "NYI"
}
function Cemu_resetConfig(){
	echo "NYI"
}