$Xenia_configFile="${emusPath}\xenia\xenia-canary.config.toml"

function Xenia_install(){
	setMSG "Downloading Xenia"
	$url_xenia = getLatestReleaseURLGH "xenia-canary/xenia-canary" "zip"
	download $url_xenia "xenia.zip"
	moveFromTo "$temp/xenia" "$emusPath\xenia"
	createLauncher "xenia"
	Xenia_getPatches
}
function Xenia_init(){
	$destination="$emusPath\xenia"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\xenia" "$destination"
	mkdir "$romsPath\xbox360\xbla" -ErrorAction SilentlyContinue
	#Xenia_setResolution $xeniaResolution
}
function Xenia_update(){
	Write-Output "NYI"
}
function Xenia_setEmulationFolder(){
	Write-Output "NYI"
}
function Xenia_setupSaves(){
	setMSG "Xenia - Saves Links"
	mkdir "$emusPath\xenia\content"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\xenia\content"
	$emuSavePath = "$emulationPath\saves\xenia\saves"
	createSaveLink $simLinkPath $emuSavePath

}
function Xenia_setResolution($resolution){
	Write-Output $resolution
}
function Xenia_getPatches(){
  $patches_dir="$emusPath/xenia/patches"
  $patches_url="https://github.com/xenia-canary/game-patches/releases/latest/download/game-patches.zip"
  $patches_branch="main"
  download $patches_url "patches.zip"
  mkdir $patches_dir -ErrorAction SilentlyContinue
  moveFromTo "$temp\patches" "$emusPath\xenia"


}
function Xenia_setupStorage(){
	Write-Output "NYI"
}
function Xenia_wipe(){
	Write-Output "NYI"
}
function Xenia_uninstall(){
	Remove-Item -path "$emusPath\Xenia"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Xenia_migrate(){
	Write-Output "NYI"
}
function Xenia_setABXYstyle(){
	Write-Output "NYI"
}
function Xenia_wideScreenOn(){
	Write-Output "NYI"
}
function Xenia_wideScreenOff(){
	Write-Output "NYI"
}
function Xenia_bezelOn(){
	Write-Output "NYI"
}
function Xenia_bezelOff(){
	Write-Output "NYI"
}
function Xenia_finalize(){
	Write-Output "NYI"
}
function Xenia_IsInstalled(){
	$test=Test-Path -Path "$emusPath\xenia"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Xenia_resetConfig(){
	Xenia_init
	if($?){
		Write-Output "true"
	}
}