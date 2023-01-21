function DuckStation_install(){
	showNotification -ToastTitle 'Downloading DuckStation'
	download $url_duck "duckstation.zip"
	moveFromTo "duckstation" "tools\EmulationStation-DE\Emulators\duckstation"
	createLauncher "duckstation" "duckstation-qt-x64-ReleaseLTCG"
}
function DuckStation_init(){	
	showNotification -ToastTitle 'DuckStation - Configuration'
	New-Item -Path "tools\EmulationStation-DE\Emulators\duckstation\portable.txt" -ErrorAction SilentlyContinue
	$destination="tools\EmulationStation-DE\Emulators\duckstation\"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\EmuDeck\backend\configs\DuckStation" $destination
	
	#Bios Path
	sedFile $destination\settings.ini "SearchDirectory = C:\Emulation\bios\" "SearchDirectory = $biosPath"
	
	DuckStation_setupSaves
}
function DuckStation_update(){
	echo "NYI"
}
function DuckStation_setEmulationFolder(){
	echo "NYI"
}
function DuckStation_setupSaves(){
	showNotification -ToastTitle 'DuckStation - Creating Saves Links'
	#Saves
	$SourceFilePath = -join($userFolder, '\tools\EmulationStation-DE\Emulators\duckstation\memcards')
	$ShortcutPath = -join($emulationPath,'saves\duckstation\saves.lnk')
	mkdir 'saves\duckstation' -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = -join($userFolder, 'tools\EmulationStation-DE\Emulators\duckstation\savestates')
	$ShortcutPath = -join($emulationPath,'saves\duckstation\states.lnk')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}

function DuckStation_setResolution($resolution){
	switch ( $screenResolution )
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