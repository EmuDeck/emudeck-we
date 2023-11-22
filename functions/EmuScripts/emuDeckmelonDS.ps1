$melonD_configFile="$emusPath\melonDS\melonDS.ini"

function melonDS_install(){
	setMSG "Downloading melonDS"
	$url_melonDS = getLatestReleaseURLGH "melonDS-emu/melonDS" "zip" "win_x64"
	download $url_melonDS "melonds.zip"
	moveFromTo "$temp/melonDS" "$emusPath/melonDS"
	Remove-Item -Recurse -Force melonds.zip -ErrorAction SilentlyContinue
	createLauncher "melonDS"
}
function melonDS_init(){
	setMSG "melonDS - Configuration"
	$destination="$emusPath/melonDS"

	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\melonDS" "$destination"

	sedFile "$melonD_configFile" "/run/media/mmcblk0p1/Emulation" "$emulationPath"
	sedFile "$melonD_configFile" "\" "/"

	#melonDS_setupSaves
	melonDS_setResolution $melondsResolution
}
function melonDS_update(){
	Write-Output "true"
}
function melonDS_setEmulationFolder(){
	Write-Output "true"
}
function melonDS_setupSaves(){
	mkdir "$savesPath\melonds\saves" -ErrorAction SilentlyContinue
	mkdir "$savesPath\melonds\states" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\melonDS\cheats" -ErrorAction SilentlyContinue
	Write-Output "true"
	#cloud_sync_save_hash "$savesPath\melonds"
}

function melonDS_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $WindowWidth = 1024; $WindowHeight = 768 }
		"1080P" { $WindowWidth = 1536; $WindowHeight = 1152 }
		"1440P" { $WindowWidth = 2048; $WindowHeight = 1536 }
		"4K" { $WindowWidth = 2816;  $WindowHeight = 2112 }
	}
	$destination="$emusPath/melonDS"

	setConfig "WindowWidth" $WindowWidth "$melonD_configFile"
	setConfig "WindowHeight" $WindowHeight "$melonD_configFile"
}



function melonDS_setupStorage(){
	Write-Output "true"
}
function melonDS_wipe(){
	Write-Output "true"
}
function melonDS_uninstall(){
	Remove-Item -path "$emusPath\melonDS"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function melonDS_migrate(){
	Write-Output "true"
}
function melonDS_setABXYstyle(){
	Write-Output "true"
}
function melonDS_wideScreenOn(){
	Write-Output "true"
}
function melonDS_wideScreenOff(){
	Write-Output "true"
}
function melonDS_bezelOn(){
	Write-Output "true"
}
function melonDS_bezelOff(){
	Write-Output "true"
}
function melonDS_finalize(){
	Write-Output "true"
}
function melonDS_IsInstalled(){
	$test=Test-Path -Path "$emusPath\melonDS\melonDS.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function melonDS_resetConfig(){
	melonDS_init
	if($?){
		Write-Output "true"
	}
}