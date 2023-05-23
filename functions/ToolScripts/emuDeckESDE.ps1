function ESDE_install(){
	setMSG 'Downloading EmulationStation DE'
	download $url_esde "esde.zip"
	moveFromTo "$temp/esde/EmulationStation-DE" "$esdeFolder"	
}
function ESDE_init(){	
	setMSG 'EmulationStation DE - Paths and Themes'
	
	#We move ESDE + Emus to the userfolder.
	$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\EmulationStation.exe"
	if($test){
		mkdir $esdeFolder  -ErrorAction SilentlyContinue
		moveFromTo "$emulationPath\tools\EmulationStation-DE" "$esdeFolder"
	}		
	
	$destination='$esdeFolder\.emulationstation'
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\emulationstation" "$destination"
	
	$xml = Get-Content "$esdeFolder\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="ROMDirectory" value=").*?(?=" />)', "$romsPath"
	$updatedXML | Set-Content "$esdeFolder\.emulationstation\es_settings.xml"
	
	mkdir "tools\launchers\esde" -ErrorAction SilentlyContinue
	createLauncher "esde/EmulationStationDE"
		
	ESDE_applyTheme $esdeTheme
	
	#PS2 Fixes	
	sedFile "$esdeFolder\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\PCSX2-Qt\pcsx2-qtx64*.exe</entry>' '<entry>%ESPATH%\Emulators\PCSX2-Qt\pcsx2-qtx64*.exe</entry><entry>%ESPATH%\Emulators\PCSX2\pcsx2-qtx64*.exe</entry>' 
	
}
function ESDE_update(){
	echo "NYI"
}
function ESDE_setEmulationFolder(){
	echo "NYI"
}
function ESDE_setupSaves(){
	echo "NYI"
}
function ESDE_setupStorage(){
	echo "NYI"
}
function ESDE_wipe(){
	echo "NYI"
}
function ESDE_uninstall(){
	echo "NYI"
}
function ESDE_migrate(){
	echo "NYI"
}
function ESDE_setABXYstyle(){
	echo "NYI"
}
function ESDE_wideScreenOn(){
	echo "NYI"
}
function ESDE_wideScreenOff(){
	echo "NYI"
}
function ESDE_bezelOn(){
	echo "NYI"
}
function ESDE_bezelOff(){
	echo "NYI"
}
function ESDE_finalize(){
	echo "NYI"
}
function ESDE_applyTheme($theme){
	
	mkdir "$esdeFolder/themes/" -ErrorAction SilentlyContinue
	
	git clone https://github.com/anthonycaccese/epic-noir-revisited-es-de "$esdeFolder/themes/epic-noir-revisited" --depth=1
	cd "$esdeFolder/themes/epic-noir-revisited" ; git reset --hard HEAD ; git clean -f -d ; git pull

	
	$xml = Get-Content "$esdeFolder\.emulationstation\es_settings.xml"
	if($theme -eq "EPICNOIR"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'epic-noir-revisited'
	}
	if($theme -eq "MODERN-DE"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'modern-es-de'
	}
	if($theme -eq "RBSIMPLE-DE"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'slate-es-de'
	}		
	$updatedXML | Set-Content "$esdeFolder\.emulationstation\es_settings.xml"

}
function ESDE_IsInstalled(){
	$test=Test-Path -Path "$esdeFolder"
	if($test){
		echo "true"
	}
}
function ESDE_resetConfig(){
	ESDE_init
	if($?){
		echo "true"
	}
}