function ESDE_install(){
	setMSG 'Downloading EmulationStation DE'

	#Fixes for ESDE warning message
	if ( ESDE_IsInstalled -like "*true*" ){
		moveFromTo "$esdePath\.emulationstation\gamelists" "$temp\gamelists"
		ESDE_uninstall
		$doInit="true"
	}

	rm -r -fo "$temp/esde" -ErrorAction SilentlyContinue
	download $url_esde "esde.zip"
	mkdir $esdePath -ErrorAction SilentlyContinue

	moveFromTo "$temp/esde/EmulationStation-DE" "$esdePath"

	if($doInit -eq "true" ){
		ESDE_init
	}
}

function ESDE_init(){
	setMSG 'EmulationStation DE - Paths and Themes'
	if(Test-Path "$esdePath\.emulationstation\gamelists"){
		moveFromTo "$esdePath\.emulationstation\gamelists" "$temp\gamelists"
	}
	#We reset ESDE system files
	#Copy-Item "$esdePath/resources/systems/windows/es_systems.xml.bak" -Destination "$esdePath/resources/systems/windows/es_systems.xml" -ErrorAction SilentlyContinue
	#Copy-Item "$esdePath/resources/systems/windows/es_find_rules.xml.bak" -Destination "$esdePath/resources/systems/windows/es_find_rules.xml" -ErrorAction SilentlyContinue

	#We move ESDE + Emus to the userfolder.
	$test=Test-Path -Path "$toolsPath\EmulationStation-DE\EmulationStation.exe"
	if($test){

		$userDrive="$userFolder[0]"

		$destinationFree = (Get-PSDrive -Name "$userDrive").Free
		$sizeInGB = [Math]::Round($destinationFree / 1GB)

		$originSize = (Get-ChildItem -Path "$toolsPath/EmulationStation-DE" -Recurse | Measure-Object -Property Length -Sum).Sum
		$wshell = New-Object -ComObject Wscript.Shell

		if ( $originSize -gt $destinationFree ){
			$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB")
			exit
		}
		$Output = $wshell.Popup("We are going to move EmulationStation and all the Emulators to $userFolder in order to improve loading times. This will take long, so please wait until you get a new confirmation window")

		mkdir $esdePath  -ErrorAction SilentlyContinue
		moveFromTo "$toolsPath\EmulationStation-DE" "$esdePath"

		$Output = $wshell.Popup("Migration complete!")

	}

	#We move download_media folder
	$test=Test-Path -Path "$userFolder\emudeck\EmulationStation-DE\.emulationstation\downloaded_media"
	if($test){

		$userDrive="$userFolder[0]"

		$destinationFree = (Get-PSDrive -Name $userDrive).Free
		$sizeInGB = [Math]::Round($destinationFree / 1GB)

		$originSize = (Get-ChildItem -Path "$toolsPath/EmulationStation-DE" -Recurse | Measure-Object -Property Length -Sum).Sum
		$wshell = New-Object -ComObject Wscript.Shell

		if ( $originSize -gt $destinationFree ){
			$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB")
			exit
		}
		$Output = $wshell.Popup("We are going to move EmulationStation scrape data to $emulationPath/storage in order to free space in your internal drive. This could take long, so please wait until you get a new confirmation window")

		mkdir "$emulationPath/storage/downloaded_media"  -ErrorAction SilentlyContinue
		moveFromTo "$esdePath/.emulationstation/downloaded_media" "$emulationPath/storage/downloaded_media"

		$Output = $wshell.Popup("Migration complete!")

	}

	$destination="$esdePath\.emulationstation"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\emulationstation" "$destination"

	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="ROMDirectory" value=").*?(?=" />)', "$romsPath"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml" -Encoding UTF8

	mkdir "$emulationPath/storage/downloaded_media" -ErrorAction SilentlyContinue

	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="MediaDirectory" value=").*?(?=" />)', "$emulationPath/storage/downloaded_media"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml" -Encoding UTF8

	mkdir "$toolsPath\launchers\esde" -ErrorAction SilentlyContinue
	createLauncher "esde/EmulationStationDE"

	ESDE_applyTheme "$esdeThemeUrl" "$esdeThemeName"

	ESDE_setDefaultEmulators

	#Citra fixes
	sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\Citra\nightly-mingw\citra-qt.exe</entry>' '<entry>%ESPATH%\Emulators\citra\citra-qt.exe</entry>'

	#Xenia fixes
	sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\xenia_canary\xenia_canary.exe</entry>' '<entry>%ESPATH%\Emulators\xenia\xenia_canary.exe</entry>'

	if(Test-Path "$temp\gamelists"){
		rm -r -fo "$esdePath\.emulationstation\gamelists"
		mkdir "$esdePath\.emulationstation\gamelists" -ErrorAction SilentlyContinue
		moveFromTo "$temp\gamelists" "$esdePath\.emulationstation\gamelists"
		rm -r -fo "$temp\gamelists"
	}

}

function ESDE_addLauncher($emucode, $launcher){

	# Configuration file path
	$configFile = "$esdePath/resources/systems/windows/es_find_rules.xml"

	# Emulator name
	$emulatorName = "$emucode"

	# New entry to add
	$newEntry = "$toolsPath\launchers\$launcher.bat"

	# Load the XML content
	$xmlContent = Get-Content $configFile -Raw

	# Create an XML object from the content
	$xml = [xml]$xmlContent

	# Find the emulator by name
	$emulator = Select-Xml -Xml $xml -XPath "//emulator[@name='$emulatorName']"

	# Check if the emulator was found
	if ($emulator -eq $null) {
		Write-Host "No emulator found with the name '$emulatorName'."
	} else {
		# Add the new entry to the rule
		$newEntryElement = $xml.CreateElement("entry")
		$newEntryElement.InnerText = $newEntry
		$emulator.Node.rule.prependChild($newEntryElement)

		# Save the changes to the file
		$xml.Save($configFile)

		Write-Host "The new entry has been added successfully."
	}

}

function ESDE_update(){
	Write-Output "NYI"
}
function ESDE_setEmulationFolder(){
	Write-Output "NYI"
}
function ESDE_setupSaves(){
	Write-Output "NYI"
}
function ESDE_setupStorage(){
	Write-Output "NYI"
}
function ESDE_wipe(){
	Write-Output "NYI"
}
function ESDE_uninstall(){
	$testpath = Test-Path -Path "$esdepath"
	if ($testpath -eq $True){
		Get-ChildItem -Path "$esdePath" | Where-Object { $_.Name -ne "Emulators" } | Remove-Item -Recurse -Force
		if($?){
		Write-Output "true"
		}
	}
	else{
		
	}
	
}
function ESDE_migrate(){
	Write-Output "NYI"
}
function ESDE_setABXYstyle(){
	Write-Output "NYI"
}
function ESDE_wideScreenOn(){
	Write-Output "NYI"
}
function ESDE_wideScreenOff(){
	Write-Output "NYI"
}
function ESDE_bezelOn(){
	Write-Output "NYI"
}
function ESDE_bezelOff(){
	Write-Output "NYI"
}
function ESDE_finalize(){
	Write-Output "NYI"
}

function ESDE_applyTheme($esdeThemeUrl, $esdeThemeName ){

	mkdir -p "$esdePath\.emulationstation\themes" -ErrorAction SilentlyContinue
	cd "$esdePath\.emulationstation\themes"
	git clone $esdeThemeUrl "./$esdeThemeName"

	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', "$esdeThemeName"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml" -Encoding UTF8

}

function ESDE_IsInstalled(){
	$test=Test-Path -Path "$esdePath\emulationstation.exe"
	$testold=Test-Path -Path "$toolsPath/EmulationStation-DE"
	if ($test -or $testold) {
		Write-Output "true"
	}else{
		Write-Output "false"
	}

}
function ESDE_resetConfig(){
	ESDE_init
	if($?){
		Write-Output "true"
	}
}



function ESDE_setDefaultEmulators(){
	mkdir "$esdePath/.emulationstation/gamelists/"  -ErrorAction SilentlyContinue

	ESDE_setEmu 'Dolphin (Standalone)' gc
	ESDE_setEmu 'PPSSPP (Standalone)' psp
	ESDE_setEmu 'Dolphin (Standalone)' wii
	ESDE_setEmu 'PCSX2 (Standalone)' ps2
	ESDE_setEmu 'melonDS' nds
	ESDE_setEmu 'Citra (Standalone)' n3ds
	ESDE_setEmu 'Beetle Lynx' atarilynx
	ESDE_setEmu 'DuckStation (Standalone)' psx
	ESDE_setEmu 'Beetle Saturn' saturn
	ESDE_setEmu 'ScummVM (Standalone)' scummvm
}


function ESDE_setEmu($emu, $system){
    $gamelistFile="$esdePath/.emulationstation/gamelists/$system/gamelist.xml"
	$test=Test-Path -Path "gamelistFile"

	if ( Test-Path -Path "$gamelistFile" ){

		echo "we do nothing"
		#$xml = [xml](Get-Content $gamelistFile)

		#$xml.alternativeEmulator.label = $emu

		# Guardar los cambios en el archivo XML
		#$xml.Save($gamelistFile)

	}
	else{

		mkdir "$esdePath/.emulationstation/gamelists/$system"  -ErrorAction SilentlyContinue

		"$env:APPDATA\EmuDeck\backend\configs\emulationstation"

		Copy-Item "$env:APPDATA\EmuDeck\backend\configs\emulationstation/gamelists/$system/gamelist.xml" -Destination "$gamelistFile" -ErrorAction SilentlyContinue -Force
	}

}
