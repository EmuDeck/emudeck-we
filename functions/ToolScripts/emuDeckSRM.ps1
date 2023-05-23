function SRM_install(){
	setMSG 'Downloading Steam Rom Manager'
	$url_srm = getLatestReleaseURLGH 'SteamGridDB/steam-rom-manager' 'exe' 'portable'
	download $url_srm "$toolsPath/srm.exe"
}
function SRM_init(){
	setMSG 'Steam Rom Manager - Configuration'	
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager" tools\
	Start-Sleep -Seconds 1
	#Paths	
	sedFile tools\UserData\userConfigurations.json "C:\\Emulation" $emulationPath
	sedFile tools\UserData\userConfigurations.json ":\" ":\\"
	sedFile tools\UserData\userConfigurations.json "\\\" "\\"
	sedFile tools\UserData\userSettings.json "C:\\Emulation" $emulationPath
	sedFile tools\UserData\userSettings.json ":\" ":\\"
	sedFile tools\UserData\userSettings.json "\\\" "\\"

	#Desktop Icon
	createLink "$emulationPath\tools\srm.exe" "$env:USERPROFILE\Desktop\EmuDeck - Steam Rom Manager.lnk"		
	#Start Menu
	#mkdir "$EmuDeckStartFolder" -ErrorAction SilentlyContinue
	#createLink "$emulationPath\tools\srm.exe" "$EmuDeckStartFolder\EmuDeck - Steam Rom Manager.lnk"
	
	#SteamInput
	$PFPath="$env:ProgramFiles (x86)\Steam\controller_base\templates\"
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-input\*" -Destination $PFPath -Recurse
	

		
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
	$test=Test-Path -Path "$emulationPath\tools\srm.exe"
	if($test){
		echo "true"
	}
}
function SRM_resetConfig(){
	SRM_init
	SRM_resetLaunchers
	if($?){
		echo "true"
	}
}

function SRM_resetLaunchers(){
	if ($doInstallRA -eq "true"){
		createLauncher retroarch
	}
	if ($doInstallDolphin -eq "true"){
		createLauncher dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		createLauncher pcsx2
	}
	#if ($doInstallRPCS3 -eq "true"){
	#	createLauncher rpcs3
	#}
	if ($doInstallYuzu -eq "true"){
		createLauncher yuzu
	}
	#if ($doInstallCitra -eq "true"){
	#	createLauncher citra
	#}
	if ($doInstallDuck -eq "true"){
		createLauncher duckstation
	}
	if ($doInstallCemu -eq "true"){
		createLauncher cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	createLauncher xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		createLauncher PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	createLauncher xemu
	#}
	
	if ($doInstallESDE -eq "true"){
		createLauncher "esde\EmulationStationDE"
	}
	
}