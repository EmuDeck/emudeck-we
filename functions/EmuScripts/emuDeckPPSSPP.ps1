function PPSSPP_install(){
	$test=Test-Path -Path "$emusPath\ppsspp_win"
	if($test){
		Rename-Item "$emusPath\ppsspp_win" "$emusPath\PPSSPP" -ErrorAction SilentlyContinue
	}
	setMSG "Downloading PPSSPP"
	download $url_PPSSPP "PPSSPP.zip"
	moveFromTo "$temp/PPSSPP" "$emusPath\PPSSPP"
	createLauncher "PPSSPP"
}
function PPSSPP_init(){
	$test=Test-Path -Path "$emusPath\ppsspp_win"
	if($test){
		Rename-Item "$emusPath\ppsspp_win" "$emusPath\PPSSPP" -ErrorAction SilentlyContinue
	}
	
	$destination="$emusPath\PPSSPP\memstick\PSP\SYSTEM"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs/PPSSPP/memstick/PSP/SYSTEM" "$destination"

	
	sedFile "$emusPath\PPSSPP\memstick\PSP\SYSTEM\ppsspp.ini" "C:/Emulation" "$emulationPath"
	sedFile "$emusPath\PPSSPP\memstick\PSP\SYSTEM\ppsspp.ini" ":\Emulation" ":/Emulation"
	
#	PPSSPP_setupSaves
	#PPSSPP_setResolution $ppssppResolution
}
function PPSSPP_update(){
	Write-Output "NYI"
}
function PPSSPP_setEmulationFolder(){
	Write-Output "NYI"
}
function PPSSPP_setupSaves(){	
	setMSG "PPSSPP - Saves Links"
	$simLinkPath = "$emusPath\PPSSPP\memstick\PSP\PPSSPP_STATE"	
	$emuSavePath = -join($emulationPath,"\saves\ppsspp\states")	
	createSaveLink $simLinkPath $emuSavePath
	
	$simLinkPath = "$emusPath\PPSSPP\memstick\PSP\SAVEDATA"	
	$emuSavePath = -join($emulationPath,"\saves\ppsspp\saves")
	createSaveLink $simLinkPath $emuSavePath
	
}
function PPSSPP_setResolution($resolution){
	Write-Output $resolution
}
function PPSSPP_setupStorage(){
	Write-Output "NYI"
}
function PPSSPP_wipe(){
	Write-Output "NYI"
}
function PPSSPP_uninstall(){
	Write-Output "NYI"
}
function PPSSPP_migrate(){
	Write-Output "NYI"
}
function PPSSPP_setABXYstyle(){
	Write-Output "NYI"
}
function PPSSPP_wideScreenOn(){
	Write-Output "NYI"
}
function PPSSPP_wideScreenOff(){
	Write-Output "NYI"
}
function PPSSPP_bezelOn(){
	Write-Output "NYI"
}
function PPSSPP_bezelOff(){
	Write-Output "NYI"
}
function PPSSPP_finalize(){
	Write-Output "NYI"
}
function PPSSPP_IsInstalled(){
	$test=Test-Path -Path "$emusPath\PPSSPP\PPSSPPWindows64.exe"
	if($test){
		Write-Output "true"
	}
}
function PPSSPP_resetConfig(){
	PPSSPP_init
	if($?){
		Write-Output "true"
	}
}