function Citra_install(){
	setMSG "Downloading Citra"
	$url_citra = getLatestReleaseURLGH "citra-emu/citra-nightly" "7z" "windows-mingw"
	download $url_citra "citra.7z"
	moveFromTo "$temp/citra/nightly-mingw" "$emusPath\citra"
	Remove-Item -Recurse -Force citra -ErrorAction SilentlyContinue	
	mkdir "$emusPath\citra\user" -ErrorAction SilentlyContinue	
	createLauncher "citra"
	
}
function Citra_init(){

	setMSG "Citra - Configuration"
	$destination="$emusPath\citra\user
	mkdir $destination -ErrorAction SilentlyContinue
	
	#Different ini per controller	
	Citra_setController($device)	
	
	Citra_setupSaves
}
function Citra_update(){
	echo "NYI"
}
function Citra_setEmulationFolder(){
	echo "NYI"
}
function Citra_setupSaves(){
	setMSG "Citra - Saves Links"
	$SourceFilePath = "$emusPath\citra\user\sdmc\"
	$ShortcutPath = -join($emulationPath,"\saves\citra\saves.lnk")
	mkdir "saves\citra" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	$SourceFilePath = "$emusPath\citra\user\states\"
	$ShortcutPath = -join($emulationPath,"\saves\citra\states.lnk")
	mkdir "saves\citra" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}
function Citra_setupStorage(){
	echo "NYI"
}

function Citra_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}	
	$destination="$emusPath\citra\user
	
	setConfig "resolution_factor" $multiplier $destination\config\qt-config.ini
}

function Citra_wipe(){
	echo "NYI"
}
function Citra_uninstall(){
	echo "NYI"
}
function Citra_migrate(){
	echo "NYI"
}
function Citra_setABXYstyle(){
	echo "NYI"
}
function Citra_wideScreenOn(){
	echo "NYI"
}
function Citra_wideScreenOff(){
	echo "NYI"
}
function Citra_bezelOn(){
	echo "NYI"
}
function Citra_bezelOff(){
	echo "NYI"
}
function Citra_finalize(){
	echo "NYI"
}
function Citra_IsInstalled(){
	$test=Test-Path -Path "$emusPath\citra"
	if($test){
		echo "true"
	}
}
function Citra_resetConfig(){
	Citra_init
	if($?){
		echo "true"
	}
}

function Citra_setController($device){

	$destination="$emusPath\citra\user\config"
	
	switch ($device) {
		"PS5" {
			Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config\qt-config.ps5.ini" -Destination "$destination\qt-config.ini"
		}
		"PS4" {
			Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config\qt-config.ps5.ini" -Destination "$destination\qt-config.ini"
		}
		"XONE" {
			Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config\qt-config.ini" -Destination "$destination\qt-config.ini"
		}
		"X360" {
			Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config\qt-config.ini" -Destination "$destination\qt-config.ini"
		}
		"SWITCHPRO" {
			Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config\qt-config.ini" -Destination "$destination\qt-config.ini"
		}
		Default {
			Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config\qt-config.ini" -Destination "$destination\qt-config.ini"
		}
	}
	
}