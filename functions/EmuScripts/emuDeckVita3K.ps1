$Vita3K_configFile="$emusPath\Vita3K\config.yml"

function Vita3K_install(){
	setMSG "Downloading Vita3K"
	$url_vita3k = getLatestReleaseURLGH "Vita3K/Vita3K" "zip" "windows"
	download $url_vita3k "vita3k.zip"
	moveFromTo "$temp\vita3k" "$emusPath\Vita3K"
	createLauncher "Vita3K"
}
function Vita3K_init(){
	$destination="$emusPath\vita3k"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\vita3k" "$destination"
	Vita3K_setEmulationFolder
	Vita3K_setupStorage
	Vita3K_setupSaves
	Vita3K_finalize
}
function Vita3K_update(){
	Write-Output "NYI"
}
function Vita3K_setEmulationFolder(){
	sedFile "$Vita3K_configFile" "/run/media/mmcblk0p1/Emulation" "$emulationPath"
}
function Vita3K_setupSaves(){
	setMSG "Vita3K - Saves Links"
	mkdir "$storagePath\Vita3K\ux0\user\00\savedata" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\saves\Vita3K\saves" -ErrorAction SilentlyContinue
	createSymlink "$emulationPath\storage\Vita3K\ux0\user\00\savedata" "$emulationPath\saves\Vita3K\saves"
}
function Vita3K_setupStorage(){
	mkdir "$storagePath\Vita3K\ux0\app" -ErrorAction SilentlyContinue
	createSymlink "$romsPath\psvita\InstalledGames" "$storagePath\Vita3K\ux0\app"
}
function Vita3K_wipe(){
	Write-Output "NYI"
}
function Vita3K_uninstall(){
	Remove-Item -path "$emusPath\vita3k" -recurse -force
	if($?){
		Write-Output "true"
	}
}
function Vita3K_migrate(){
	Write-Output "NYI"
}
function Vita3K_setABXYstyle(){
	Write-Output "NYI"
}
function Vita3K_wideScreenOn(){
	Write-Output "NYI"
}
function Vita3K_wideScreenOff(){
	Write-Output "NYI"
}
function Vita3K_bezelOn(){
	Write-Output "NYI"
}
function Vita3K_bezelOff(){
	Write-Output "NYI"
}
function Vita3K_finalize(){
	Write-Output "NYI"
}
function Vita3K_IsInstalled(){
	$test=Test-Path -Path "$emusPath\vita3k\vita3k.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Vita3K_resetConfig(){
	Vita3K_init
	if($?){
		Write-Output "true"
	}
}