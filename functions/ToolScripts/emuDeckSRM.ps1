function SRM_install(){
	showNotification -ToastTitle 'Downloading Steam Rom Manager'
	download $url_srm "tools/srm.exe"
}
function SRM_init(){
	showNotification -ToastTitle 'Steam Rom Manager - Configuration'	
	copyFromTo "$env:USERPROFILE\EmuDeck\backend\configs\steam-rom-manager" tools\
	
	#Paths	
	sedFile tools\UserData\userConfigurations.json "C:\\Emulation" $emulationPath
	sedFile tools\UserData\userConfigurations.json ":\" ":\\"
	sedFile tools\UserData\userConfigurations.json "\\\" "\\"
	sedFile tools\UserData\userSettings.json "C:\\Emulation" $emulationPath
	sedFile tools\UserData\userSettings.json ":\" ":\\"
	sedFile tools\UserData\userSettings.json "\\\" "\\"

	
	
	createLink "$emulationPath\tools\srm.exe" "$desktop_path\EmuDeck - Steam Rom Manager.lnk"		
}
function SRM_update(){
	echo "NYI"
}
function SRM_setEmulationFolder(){
	echo "NYI"
}
function SRM_setupSaves(){
	echo "NYI"
}
function SRM_setupStorage(){
	echo "NYI"
}
function SRM_wipe(){
	echo "NYI"
}
function SRM_uninstall(){
	echo "NYI"
}
function SRM_migrate(){
	echo "NYI"
}
function SRM_setABXYstyle(){
	echo "NYI"
}
function SRM_wideScreenOn(){
	echo "NYI"
}
function SRM_wideScreenOff(){
	echo "NYI"
}
function SRM_bezelOn(){
	echo "NYI"
}
function SRM_bezelOff(){
	echo "NYI"
}
function SRM_finalize(){
	echo "NYI"
}
function SRM_IsInstalled(){
	echo "NYI"
}
function SRM_resetConfig(){
	echo "NYI"
}