function Cemu_install(){
	setMSG "Downloading Cemu"
	$url_cemu = getReleaseURLGH 'cemu-project/Cemu' 'zip' 'windows-x64' "ubuntu"
	download $url_cemu "cemu.zip"

	$folderPath = "$temp/cemu"
	$subfolders = Get-ChildItem -Path $folderPath -Directory

	foreach ($subfolder in $subfolders) {
		$subfolderName = $subfolder.Name
		moveFromTo "$temp/cemu/$subfolderName" "$emusPath\cemu"
	}

	Remove-Item -Recurse -Force cemu -ErrorAction SilentlyContinue
	createLauncher "cemu"

}
function Cemu_init(){
	setMSG "Cemu - Configuration"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\cemu" "$emusPath\cemu"
	sedFile "$emusPath\cemu\controllerProfiles\controller0.xml" "DSUController" "XInput"
	#sedFile "$emusPath\cemu\controllerProfiles\Deck-Gamepad-Gyro.xml" "DSUController" "XInput"
	sedFile "$emusPath\cemu\settings.xml" "C:\Emulation" "$emulationPath"

#	Cemu_setupSaves



}
function Cemu_update(){
	Write-Output "NYI"
}
function Cemu_setEmulationFolder(){
	Write-Output "NYI"
}

function Cemu_setupSaves(){
	setMSG "Cemu - Saves Links"
	mkdir "$emusPath\cemu\mlc01\usr\" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\cemu\mlc01\usr\save"
	$emuSavePath = "$emulationPath/saves\Cemu\saves"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\Cemu"
}

function Cemu_setResolution($resolution){
	Write-Output $resolution
}

function Cemu_setupStorage(){
	Write-Output "NYI"
}
function Cemu_wipe(){
	Write-Output "NYI"
}
function Cemu_uninstall(){
	Remove-Item -path "$emusPath\Cemu"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Cemu_migrate(){
	Write-Output "NYI"
}
function Cemu_setABXYstyle(){
	Write-Output "NYI"
}
function Cemu_wideScreenOn(){
	Write-Output "NYI"
}
function Cemu_wideScreenOff(){
	Write-Output "NYI"
}
function Cemu_bezelOn(){
	Write-Output "NYI"
}
function Cemu_bezelOff(){
	Write-Output "NYI"
}
function Cemu_finalize(){
	Write-Output "NYI"
}
function Cemu_IsInstalled(){
	$test=Test-Path -Path "$emusPath\cemu"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Cemu_resetConfig(){
	Cemu_init
	if($?){
		Write-Output "true"
	}
}
