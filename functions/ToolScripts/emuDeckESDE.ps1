function ESDE_install(){
	setMSG 'Downloading EmulationStation DE'
	download $url_esde "esde.zip"
	moveFromTo "temp/esde/EmulationStation-DE" "tools/EmulationStation-DE"	
}
function ESDE_init(){	
	setMSG 'EmulationStation DE - Paths and Themes'
	mkdir "tools\EmulationStation-DE\.emulationstation" -ErrorAction SilentlyContinue
	
	$destination='tools\EmulationStation-DE\.emulationstation'
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\emulationstation" "$destination"
	
	sedFile 'tools\EmulationStation-DE\.emulationstation\es_settings.xml' '/run/media/mmcblk0p1/Emulation/roms/' $romsPath
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\themes\es-epicnoir"
	if(-not($test)){
		download "https://github.com/dragoonDorise/es-theme-epicnoir/archive/refs/heads/master.zip" "temp.zip"
		moveFromTo "temp\es-theme-epicnoir-master" "tools\EmulationStation-DE\themes\es-epicnoir"
		Remove-Item -Recurse -Force temp -ErrorAction SilentlyContinue
	}
	
	#PS2 Fixes	
	sedFile "tools\EmulationStation-DE\resources\systems\windows\es_find_rules.xml" 'pcsx2.exe' 'pcsx2-qtx64-avx2.exe' 
	sedFile "tools\EmulationStation-DE\resources\systems\windows\es_systems.xml" '%EMULATOR_PCSX2% --nogui' '%EMULATOR_PCSX2% -nogui -fastboot -fullscreen' 

	
}
function ESDE_update(){
	echo "NYI"
}
function ESDE_setEmulationFolder(){
	echo "NYI"
}
function ESDE_setupSaves(){
	echo "NYI"
}
function ESDE_setupStorage(){
	echo "NYI"
}
function ESDE_wipe(){
	echo "NYI"
}
function ESDE_uninstall(){
	echo "NYI"
}
function ESDE_migrate(){
	echo "NYI"
}
function ESDE_setABXYstyle(){
	echo "NYI"
}
function ESDE_wideScreenOn(){
	echo "NYI"
}
function ESDE_wideScreenOff(){
	echo "NYI"
}
function ESDE_bezelOn(){
	echo "NYI"
}
function ESDE_bezelOff(){
	echo "NYI"
}
function ESDE_finalize(){
	echo "NYI"
}
function ESDE_IsInstalled(){
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE"
	if($test){
		echo "true"
	}
}
function ESDE_resetConfig(){
	ESDE_init
	if($?){
		echo "true"
	}
}