function PCSX2_install(){
	showNotification -ToastTitle 'Downloading PCSX2'
	download $url_pcsx2 "pcsx2.7z"
	moveFromTo "pcsx2" "tools\EmulationStation-DE\Emulators\PCSX2"
}
function PCSX2_init(){	
	showNotification -ToastTitle 'PCSX2 - Configuration'
	$destination="tools\EmulationStation-DE\Emulators\PCSX2"
	copyFromTo "$env:USERPROFILE\EmuDeck\backend\configs\PCSX2" $destination
	
	sedFile $destination\inis\PCSX2_ui.ini "/run/media/mmcblk0p1/Emulation" "$emulationPath"
	sedFile $destination\inis\PCSX2_ui.ini "/home/deck/.var/app/net.pcsx2.PCSX2/config/PCSX2" $emulationPath\tools\EmulationStation-DE\Emulators\PCSX2
	sedFile $destination\inis\PCSX2-reg.ini "/home/deck/.var/app/net.pcsx2.PCSX2/config/PCSX2" $emulationPath\tools\EmulationStation-DE\Emulators\PCSX2
	
	sedFile $destination\inis\PCSX2_ui.ini "/" "\"
	sedFile $destination\inis\PCSX2-reg.ini "/" "\"	
	sedFile $destination\inis\PCSX2_ui.ini "C:\" "\\"
	
	
	$test=Test-Path -Path "$emulationPath\tools\vc_redist.x86.exe"
	if(-not($test)){
		showNotification -ToastTitle 'PCSX2 - Downloading Microsoft Visual C++ 2022 x86'
		download "https://aka.ms/vs/17/release/vc_redist.x86.exe" "tools/vc_redist.x86.exe"	
		.\tools\vc_redist.x86.exe
	}
	

	
	PCSX2_setupSaves
	
}
function PCSX2_update(){
	echo "NYI"
}
function PCSX2_setEmulationFolder(){
	echo "NYI"
}
function PCSX2_setupSaves(){
	#Saves
	showNotification -ToastTitle 'PCSX2 - Saves Links'
	mkdir saves/PCSX2 -ErrorAction SilentlyContinue
	$SourceFilePath = -join($emulationPath,'tools\EmulationStation-DE\Emulators\PCSX2\memcards\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'saves\PCSX2\saves.lnk')
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = -join($emulationPath,'tools\EmulationStation-DE\Emulators\PCSX2\sstates\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'saves\PCSX2\states.lnk')
	createLink $SourceFilePath $ShortcutPath
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
	echo "NYI"
}
function PCSX2_resetConfig(){
	echo "NYI"
}