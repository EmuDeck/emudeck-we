function DuckStation_install(){
	setMSG "Downloading DuckStation"
	$url_duck = getLatestReleaseURLGH "stenzek/duckstation" "zip" "windows-x64" "symbols"	
	download $url_duck "duckstation.zip"
	moveFromTo "$temp/duckstation" "$emusPath\duckstation"
	createLauncher "duckstation"
}
function DuckStation_init(){	
	setMSG "DuckStation - Configuration"
	New-Item -Path "$emusPath\duckstation\portable.txt" -ErrorAction SilentlyContinue
	$destination="$emusPath\duckstation"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\DuckStation" $destination
	
	#Paths
	sedFile $destination\settings.ini "C:\Emulation" "$emulationPath"
	
	DuckStation_setupSaves
	DuckStation_setResolution $duckstationResolution
	
	if  ("$doRASignIn" -eq "true" ){
		DuckStation_retroAchievementsSetLogin
	}
	
	#
	#New Aspect Ratios
	#
	
	# Classic 3D Games
	if ( "$arClassic3D" -eq 169 ){				
		DuckStation_wideScreenOn		
	}else{
		DuckStation_wideScreenOff
	}

	
}
function DuckStation_update(){
	Write-Output "NYI"
}
function DuckStation_setEmulationFolder(){
	Write-Output "NYI"
}
function DuckStation_setupSaves(){
	setMSG "DuckStation - Creating Saves Links"
	#Saves	
	$simLinkPath = "$emusPath\duckstation\memcards"
	$emuSavePath = -join($emulationPath,"\saves\duckstation\saves")
	createSymlink $simLinkPath $emuSavePath	
	
	#States
	$simLinkPath = "$emusPath\duckstation\savestates"
	$emuSavePath = -join($emulationPath,"\saves\duckstation\states")	
	createSymlink $simLinkPath $emuSavePath
}

function DuckStation_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}	
	
	setConfig "ResolutionScale" $multiplier "$emusPath\duckstation\settings.ini"
}

function DuckStation_setupStorage(){
	Write-Output "NYI"
}
function DuckStation_wipe(){
	Write-Output "NYI"
}
function DuckStation_uninstall(){
	Write-Output "NYI"
}
function DuckStation_migrate(){
	Write-Output "NYI"
}
function DuckStation_setABXYstyle(){
	Write-Output "NYI"
}
function DuckStation_wideScreenOn(){
	Write-Output "NYI"
}
function DuckStation_wideScreenOff(){
	Write-Output "NYI"
}
function DuckStation_bezelOn(){
	Write-Output "NYI"
}
function DuckStation_bezelOff(){
	Write-Output "NYI"
}
function DuckStation_finalize(){
	Write-Output "NYI"
}
function DuckStation_IsInstalled(){
	$test=Test-Path -Path "$emusPath\duckstation"
	if($test){
		Write-Output "true"
	}
}
function DuckStation_resetConfig(){
	DuckStation_init
	if($?){
		Write-Output "true"
	}
}

function DuckStation_wideScreenOn(){
	setConfig "WidescreenHack" "true" "$emusPath\duckstation\settings.ini"
	setConfig "AspectRatio" "16:9" "$emusPath\duckstation\settings.ini"	
}
function DuckStation_wideScreenOff(){
	setConfig "WidescreenHack" "false" "$emusPath\duckstation\settings.ini"
	setConfig "AspectRatio" "4:3" "$emusPath\duckstation\settings.ini"	
}
function DuckStation_retroAchievementsSetLogin(){
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	setConfig "Token" $rat "$emusPath\duckstation\settings.ini"
}