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
		
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\melonDS" "$destination"		
	
	sedFile $destination\melonDS.ini "/run/media/mmcblk0p1/Emulation" $emulationPath
	sedFile $destination\melonDS.ini "\" "/"	
	
	melonDS_setupSaves
	melonDS_setResolution $melondsResolution
}
function melonDS_update(){
	echo "true"
}
function melonDS_setEmulationFolder(){
	echo "true"
}
function melonDS_setupSaves(){
	mkdir "$savesPath\melonds\saves" -ErrorAction SilentlyContinue
	mkdir "$savesPath\melonds\states" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\melonDS\cheats" -ErrorAction SilentlyContinue
	echo "true"
}

function melonDS_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $WindowWidth = 1024; $WindowHeight = 768 }
		"1080P" { $WindowWidth = 1536; $WindowHeight = 1152 }
		"1440P" { $WindowWidth = 2048; WindowHeight = 1536 }
		"4K" { $WindowWidth = 2816;  WindowHeight = 2112 }
	}	
	$destination="$emusPath/melonDS"
	
	setConfig "WindowWidth" $WindowWidth $destination\melonDS.ini
	setConfig "WindowHeight" $WindowHeight $destination\melonDS.ini
}



function melonDS_setupStorage(){
	echo "true"
}
function melonDS_wipe(){
	echo "true"
}
function melonDS_uninstall(){
	echo "true"
}
function melonDS_migrate(){
	echo "true"
}
function melonDS_setABXYstyle(){
	echo "true"
}
function melonDS_wideScreenOn(){
	echo "true"
}
function melonDS_wideScreenOff(){
	echo "true"
}
function melonDS_bezelOn(){
	echo "true"
}
function melonDS_bezelOff(){
	echo "true"
}
function melonDS_finalize(){
	echo "true"
}
function melonDS_IsInstalled(){
	$test=Test-Path -Path "$emusPath\melonDS"
	if($test){
		echo "true"
	}
}
function melonDS_resetConfig(){
	melonDS_init
	if($?){
		echo "true"
	}
}