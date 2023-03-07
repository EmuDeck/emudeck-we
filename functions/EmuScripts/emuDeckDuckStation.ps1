function DuckStation_install(){
	setMSG 'Downloading DuckStation'
	download $url_duck "duckstation.zip"
	moveFromTo "temp/duckstation" "tools\EmulationStation-DE\Emulators\duckstation"
	createLauncher "duckstation" "duckstation-qt-x64-ReleaseLTCG"
}
function DuckStation_init(){	
	setMSG 'DuckStation - Configuration'
	New-Item -Path "tools\EmulationStation-DE\Emulators\duckstation\portable.txt" -ErrorAction SilentlyContinue
	$destination="tools\EmulationStation-DE\Emulators\duckstation\"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\DuckStation" $destination
	
	#Paths
	sedFile $destination\settings.ini "C:\Emulation" "$emulationPath"
	
	DuckStation_setupSaves
}
function DuckStation_update(){
	echo "NYI"
}
function DuckStation_setEmulationFolder(){
	echo "NYI"
}
function DuckStation_setupSaves(){
	setMSG 'DuckStation - Creating Saves Links'
	#Saves
	$SourceFilePath = -join($userFolder, '\tools\EmulationStation-DE\Emulators\duckstation\memcards')
	$ShortcutPath = -join($emulationPath,'\saves\duckstation\saves.lnk')
	mkdir 'saves\duckstation' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath	
	
	#States
	$SourceFilePath = -join($userFolder, 'tools\EmulationStation-DE\Emulators\duckstation\savestates')
	$ShortcutPath = -join($emulationPath,'\saves\duckstation\states.lnk')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}

function DuckStation_setResolution($resolution){
	switch ( $resolution )
	{
		'720P' { $multiplier = 3 }
		'1080P' { $multiplier = 5 }
		'1440P' { $multiplier = 6 }
		'4K' { $multiplier = 9 }
	}	
	
	setConfig 'ResolutionScale' $multiplier 'tools\EmulationStation-DE\Emulators\duckstation\settings.ini'
}

function DuckStation_setupStorage(){
	echo "NYI"
}
function DuckStation_wipe(){
	echo "NYI"
}
function DuckStation_uninstall(){
	echo "NYI"
}
function DuckStation_migrate(){
	echo "NYI"
}
function DuckStation_setABXYstyle(){
	echo "NYI"
}
function DuckStation_wideScreenOn(){
	echo "NYI"
}
function DuckStation_wideScreenOff(){
	echo "NYI"
}
function DuckStation_bezelOn(){
	echo "NYI"
}
function DuckStation_bezelOff(){
	echo "NYI"
}
function DuckStation_finalize(){
	echo "NYI"
}
function DuckStation_IsInstalled(){
	echo "NYI"
}
function DuckStation_resetConfig(){
	echo "NYI"
}

function DuckStation_wideScreenOn(){
	setConfig 'WidescreenHack' 'true' 'tools\EmulationStation-DE\Emulators\duckstation\settings.ini'
	setConfig 'AspectRatio' '16:9' 'tools\EmulationStation-DE\Emulators\duckstation\settings.ini'	
}
function DuckStation_wideScreenOff(){
	setConfig 'WidescreenHack' 'false' 'tools\EmulationStation-DE\Emulators\duckstation\settings.ini'
	setConfig 'AspectRatio' '4:3' 'tools\EmulationStation-DE\Emulators\duckstation\settings.ini'	
}
function DuckStation_retroAchievementsSetLogin(){
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	setConfig 'Token' $rat 'tools\EmulationStation-DE\Emulators\duckstation\settings.ini'
}