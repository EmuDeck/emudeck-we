function Yuzu_install(){
	setMSG "Downloading Yuzu"
	winget install Microsoft.VCRedist.2015+.x64 --accept-package-agreements --accept-source-agreements
	$url_yuzu = getLatestReleaseURLGH "yuzu-emu/yuzu-mainline" "7z" "windows"
	#$url_yuzu = "https://github.com/yuzu-emu/yuzu-mainline/releases/download/mainline-0-1476/yuzu-windows-msvc-20230621-e3122c5b4.7z"
	download $url_yuzu "yuzu.7z"
	moveFromTo "$temp/yuzu/yuzu-windows-msvc" "$emusPath\yuzu\yuzu-windows-msvc"
	Remove-Item -Recurse -Force yuzu -ErrorAction SilentlyContinue
	createLauncher "yuzu"
}
function Yuzu_init(){

	setMSG "Yuzu - Configuration"
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered" -ErrorAction SilentlyContinue
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\keys" -ErrorAction SilentlyContinue
	
	$destination="$emusPath\yuzu\yuzu-windows-msvc\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\yuzu\config" "$destination"
	
	#SDL fix
	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\yuzu\SDL2.dll" -Destination "$emusPath\yuzu\yuzu-windows-msvc\" -ErrorAction SilentlyContinue
	
	sedFile $destination\qt-config.ini "C:\Emulation" $emulationPath
	
	Yuzu_setupStorage
#	Yuzu_setupSaves
	Yuzu_setResolution $yuzuResolution
	

}
function Yuzu_update(){
	Write-Output "NYI"
}
function Yuzu_setEmulationFolder(){
	Write-Output "NYI"
}
function Yuzu_setupSaves(){

	setMSG "Yuzu - Creating Keys & Firmware Links"
	#Firmware
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered"
	$emuSavePath = -join($emulationPath,"\bios\yuzu\firmware")
	createSaveLink $simLinkPath $emuSavePath
	
	#Keys
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\keys"
	$emuSavePath = -join($emulationPath,"\bios\yuzu\keys")
	createSaveLink $simLinkPath $emuSavePath

	setMSG "Yuzu - Saves Links"
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\user\save"	
	$emuSavePath = -join($emulationPath,"\saves\yuzu\saves")
	createSaveLink $simLinkPath $emuSavePath
	
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\save\8000000000000010\su\avators"	
	$emuSavePath = -join($emulationPath,"\saves\yuzu\profiles")	
	createSaveLink $simLinkPath $emuSavePath
	
	
}
function Yuzu_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2;  $docked="false"}
		"1080P" { $multiplier = 2; $docked="true"   }
		"1440P" { $multiplier = 3;  $docked="false" }
		"4K" { $multiplier = 3; $docked="true" }
	}	
	
	setConfig "resolution_setup" $multiplier "$emusPath\yuzu\yuzu-windows-msvc\user\config\qt-config.ini"
	setConfig "use_docked_mode" $docked "$emusPath\yuzu\yuzu-windows-msvc\user\config\qt-config.ini"

}
function Yuzu_setupStorage(){
	mkdir $emulationPath\storage\yuzu\screenshots -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\dump -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\load -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\nand -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\sdmc -ErrorAction SilentlyContinue
	mkdir $emulationPath\storage\yuzu\tas -ErrorAction SilentlyContinue
}
function Yuzu_wipe(){
	Write-Output "NYI"
}
function Yuzu_uninstall(){
	Write-Output "NYI"
}
function Yuzu_migrate(){
	Write-Output "NYI"
}
function Yuzu_setABXYstyle(){
	Write-Output "NYI"
}
function Yuzu_wideScreenOn(){
	Write-Output "NYI"
}
function Yuzu_wideScreenOff(){
	Write-Output "NYI"
}
function Yuzu_bezelOn(){
	Write-Output "NYI"
}
function Yuzu_bezelOff(){
	Write-Output "NYI"
}
function Yuzu_finalize(){
	Write-Output "NYI"
}
function Yuzu_IsInstalled(){
	$test=Test-Path -Path "$emusPath\yuzu\yuzu-windows-msvc"
	if($test){
		Write-Output "true"
	}
}
function Yuzu_resetConfig(){
	Yuzu_init
	if($?){
		Write-Output "true"
	}
}