$MAME_emuName="MAME"
$MAME_configFile="$emusPAth\mame\mame.ini"

function MAME_install(){
	setMSG "Downloading MAME"
	$url_MAME = getLatestReleaseURLGH "mamedev\mame" "exe" "64bit" "symbols"
	download $url_MAME "mame.exe"
	mkdir "$emusPath\mame" -ErrorAction SilentlyContinue
	$installDir="$emusPath\mame"
	Start-Process -FilePath "$temp\mame.exe" -ArgumentList "x", "$temp\mame.7z", "-o$emusPath\mame", "-y", "-b" -Wait

	createLauncher "MAME"
}
function MAME_init(){
	setMSG "MAME - Configuration"
	$destination="$emusPath\mame"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\mame" "$destination"

	MAME_setupStorage
	MAME_setEmulationFolder
	#MAME_setupSaves
}
function MAME_update(){
	Write-Output "NYI"
}
function MAME_setEmulationFolder(){
		$gameDirOpt='rompath                   '
		$newGameDirOpt="$gameDirOpt""$romsPath\arcade;$biosPath;$biosPath\mame"
		changeLine "$gameDirOpt" "$newGameDirOpt" "$MAME_configFile"

		$samplepathOpt='samplepath                '
		$newSamplepathOpt="$samplepathOpt""$storagePath\mame\samples;samples"
		changeLine "$samplepathOpt" "$newSamplepathOpt" "$MAME_configFile"

		$artpathOpt='artpath                   '
		$newArtpathOpt="$artpathOpt""$storagePath\mame\artwork;artwork"
		changeLine "$artpathOpt" "$newArtpathOpt" "$MAME_configFile"

		$ctrlrpathOpt='ctrlrpath                 '
		$newctrlrpathOpt="$ctrlrpathOpt""$storagePath\mame\ctrlr;ctrlr"
		changeLine "$ctrlrpathOpt" "$newctrlrpathOpt" "$MAME_configFile"

		$inipathOpt='inipath                   '
		$newinipathOpt="$inipathOpt""$storagePath\mame\ini;ini;ini\presets"
		changeLine "$inipathOpt" "$newinipathOpt" "$MAME_configFile"


		$cheatpathOpt='cheatpath                 '
		$newcheatpathOpt="$cheatpathOpt""$storagePath\mame\cheat;cheat"
		changeLine "$cheatpathOpt" "$newcheatpathOpt" "$MAME_configFile"
}
function MAME_setupSaves(){
	setMSG "MAME - Creating Saves Links"

	#Saves
	$nvram_directoryOpt='nvram_directory           '
	$newnvram_directoryOpt="$nvram_directoryOpt""$savesPath\mame\saves"
	mkdir "$savesPath\mame\saves" -ErrorAction SilentlyContinue
	changeLine "$nvram_directoryOpt" "$newnvram_directoryOpt" "$MAME_configFile"

	#States
	state_directoryOpt='state_directory           '
	newstate_directoryOpt="$state_directoryOpt""$savesPath\mame\states"
	mkdir "$savesPath\mame\states" -ErrorAction SilentlyContinue
	changeLine "$state_directoryOpt" "$newstate_directoryOpt" "$MAME_configFile"
}
function MAME_setupStorage(){
	mkdir "$storagePath\mame\samples" -ErrorAction SilentlyContinue
	mkdir "$storagePath\mame\artwork" -ErrorAction SilentlyContinue
	mkdir "$storagePath\mame\ctrlr" -ErrorAction SilentlyContinue
	mkdir "$storagePath\mame\ini" -ErrorAction SilentlyContinue
	mkdir "$storagePath\mame\cheat" -ErrorAction SilentlyContinue
}
function MAME_wipe(){
	Write-Output "NYI"
}
function MAME_uninstall(){
	Remove-Item –path "$emusPath\mame" –recurse -force
	if($?){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function MAME_migrate(){
	Write-Output "NYI"
}
function MAME_setABXYstyle(){
	Write-Output "NYI"
}
function MAME_wideScreenOn(){
	Write-Output "NYI"
}
function MAME_wideScreenOff(){
	Write-Output "NYI"
}
function MAME_bezelOn(){
	Write-Output "NYI"
}
function MAME_bezelOff(){
	Write-Output "NYI"
}
function MAME_finalize(){
	Write-Output "NYI"
}
function MAME_IsInstalled(){
	$test=Test-Path -Path "$emusPath\mame\mame.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function MAME_resetConfig(){
	MAME_init
}