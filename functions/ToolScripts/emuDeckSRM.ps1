function SRM_install(){
	setMSG 'Downloading Steam Rom Manager'
	$url_srm = getLatestReleaseURLGH 'SteamGridDB/steam-rom-manager' 'exe' 'portable'
	download $url_srm "srm.exe"	
	Move-item -Path "$temp/srm.exe" -destination "$toolsPath/srm.exe" -force	
}
function SRM_init(){
	setMSG 'Steam Rom Manager - Configuration'	
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager" $toolsPath\
	Start-Sleep -Seconds 1
	
	#Steam installation	
	$steamRegPath = "HKCU:\Software\Valve\Steam"
	$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	$steamInstallPath = $steamInstallPath.Replace("/", "\\")
	
	#Paths
	sedFile $toolsPath\UserData\userConfigurations.json "C:\\Emulation" $emulationPath
	sedFile $toolsPath\UserData\userConfigurations.json "EMUSPATH" $emusPathSRM
	sedFile $toolsPath\UserData\userConfigurations.json "USERPATH" $userFolder
	sedFile $toolsPath\UserData\userConfigurations.json "Users\" "Users\\"
	sedFile $toolsPath\UserData\userConfigurations.json ":\" ":\\"
	sedFile $toolsPath\UserData\userConfigurations.json "\\\" "\\"
	
	sedFile $toolsPath\UserData\userSettings.json "C:\\Emulation" $emulationPath
	sedFile $toolsPath\UserData\userSettings.json "EMUSPATH" $emusPathSRM
	sedFile $toolsPath\UserData\userSettings.json "STEAMPATH" $steamInstallPath
	sedFile $toolsPath\UserData\userSettings.json "Users\" "Users\\"
	sedFile $toolsPath\UserData\userSettings.json ":\" ":\\"
	sedFile $toolsPath\UserData\userSettings.json "\\\" "\\"
	
	sedFile $toolsPath\UserData\controllerTemplates.json "STEAMPATH" $steamInstallPath
	sedFile $toolsPath\UserData\controllerTemplates.json "Users\" "Users\\"
	sedFile $toolsPath\UserData\controllerTemplates.json ":\" ":\\"
	sedFile $toolsPath\UserData\controllerTemplates.json "\\\" "\\"


	#Desktop Icon
	createLink "$toolsPath\srm.exe" "$env:USERPROFILE\Desktop\EmuDeck - Steam Rom Manager.lnk"		
	#Start Menu
	#mkdir "$EmuDeckStartFolder" -ErrorAction SilentlyContinue
	#createLink "$toolsPath\srm.exe" "$EmuDeckStartFolder\EmuDeck - Steam Rom Manager.lnk"
	
	#SteamInput
	$PFPath="$env:ProgramFiles (x86)\Steam\controller_base\templates\"
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-input\*" -Destination $PFPath -Recurse
	

		
}
function SRM_update(){
	Write-Output "NYI"
}
function SRM_setEmulationFolder(){
	Write-Output "NYI"
}
function SRM_setupSaves(){
	Write-Output "NYI"
}
function SRM_setupStorage(){
	Write-Output "NYI"
}
function SRM_wipe(){
	Write-Output "NYI"
}
function SRM_uninstall(){
	Remove-Item –path "$toolsPath\userData" –recurse -force
	Remove-Item –path "$toolsPath\srm.exe" –recurse -force
}
function SRM_migrate(){
	Write-Output "NYI"
}
function SRM_setABXYstyle(){
	Write-Output "NYI"
}
function SRM_wideScreenOn(){
	Write-Output "NYI"
}
function SRM_wideScreenOff(){
	Write-Output "NYI"
}
function SRM_bezelOn(){
	Write-Output "NYI"
}
function SRM_bezelOff(){
	Write-Output "NYI"
}
function SRM_finalize(){
	Write-Output "NYI"
}
function SRM_IsInstalled(){
	$test=Test-Path -Path "$toolsPath\srm.exe"
	if($test){
		Write-Output "true"
	}
}
function SRM_resetConfig(){
	SRM_init
	SRM_resetLaunchers
	if($?){
		Write-Output "true"
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
	if ($doInstallRPCS3 -eq "true"){
		createLauncher rpcs3
	}
	if ($doInstallYuzu -eq "true"){
		createLauncher yuzu
	}
	if ($doInstallRyujinx -eq "true"){
		createLauncher "Ryujinx"
	}
	if ($doInstallCitra -eq "true"){
		createLauncher citra
	}
	if ($doInstallDuck -eq "true"){
		createLauncher duckstation
	}
	if ($doInstallmelonDS -eq "true"){
		createLauncher melonDS
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