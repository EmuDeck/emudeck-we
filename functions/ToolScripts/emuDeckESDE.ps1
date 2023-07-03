function ESDE_install(){
	setMSG 'Downloading EmulationStation DE'
	download $url_esde "esde.zip"
	mkdir $esdePath -ErrorAction SilentlyContinue
	moveFromTo "$temp/esde/EmulationStation-DE" "$esdePath"	
}
function ESDE_init(){	
	setMSG 'EmulationStation DE - Paths and Themes'
	
	#We reset ESDE system files
	Copy-Item "$esdePath/resources/systems/windows/es_systems.xml.bak" -Destination "$esdePath/resources/systems/windows/es_systems.xml" -ErrorAction SilentlyContinue
	Copy-Item "$esdePath/resources/systems/windows/es_find_rules.xml.bak" -Destination "$esdePath/resources/systems/windows/es_find_rules.xml" -ErrorAction SilentlyContinue
	
	#We move ESDE + Emus to the userfolder.
	$test=Test-Path -Path "$toolsPath\EmulationStation-DE\EmulationStation.exe"
	if($test){
	
		$userDrive=$userFolder[0]
		
		$destinationFree = (Get-PSDrive -Name $userDrive).Free
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
	
		$userDrive=$userFolder[0]
		
		$destinationFree = (Get-PSDrive -Name $userDrive).Free
		$sizeInGB = [Math]::Round($destinationFree / 1GB)
		
		$originSize = (Get-ChildItem -Path "$toolsPath/EmulationStation-DE" -Recurse | Measure-Object -Property Length -Sum).Sum
		$wshell = New-Object -ComObject Wscript.Shell
		
		if ( $originSize -gt $destinationFree ){			
			$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB")
			exit
		}				
		$Output = $wshell.Popup("We are going to move EmulationStation scrape data to $emulationPath/storage in order to free space in your internal drive. This could take long, so please wait until you get a new confirmation window")
		
		mkdir $emulationPath/storage/downloaded_media  -ErrorAction SilentlyContinue
		moveFromTo "$esdePath/.emulationstation/downloaded_media" "$emulationPath/storage/downloaded_media"
		
		$Output = $wshell.Popup("Migration complete!")
	
	}
	
	$destination="$esdePath\.emulationstation"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\emulationstation" "$destination"
	
	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="ROMDirectory" value=").*?(?=" />)', "$romsPath"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml"
	
	mkdir $emulationPath/storage/downloaded_media -ErrorAction SilentlyContinue 
	
	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="MediaDirectory" value=").*?(?=" />)', "$emulationPath/storage/downloaded_media"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml"
	
	mkdir "$toolsPath\launchers\esde" -ErrorAction SilentlyContinue
	createLauncher "esde/EmulationStationDE"
		
	ESDE_applyTheme $esdeTheme
	
	#Adding launchers
	
	#Backup
	Copy-Item "$esdePath/resources/systems/windows/es_systems.xml" -Destination "$esdePath/resources/systems/windows/es_systems.xml.bak"
	Copy-Item "$esdePath/resources/systems/windows/es_find_rules.xml" -Destination "$esdePath/resources/systems/windows/es_find_rules.xml.bak"	
	
	#Citra
	ESDE_addLauncher CITRA citra	
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_CITRA% %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_CITRA%" %ROM% `&`& exit " `&`& exit'
	
	#RetroArch
	ESDE_addLauncher RETROARCH retroarch
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_RETROARCH% -L %CORE_RETROARCH%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_RETROARCH%" "-L" "%CORE_RETROARCH%'
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '.dll %ROM%' '.dll" %ROM% `&`& exit " `&`& exit'

	
	sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '%EMUPATH%\cores' '%ESPATH%\Emulators\RetroArch\cores'
	
	
	#Yuzu
	ESDE_addLauncher YUZU yuzu
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_YUZU% -f -g %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_YUZU%" "-f" "-g" %ROM% `&`& exit " `&`& exit'
		
	#Ryujinx
	ESDE_addLauncher RYUJINX ryujinx
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_RYUJINX% %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_RYUJINX%" %ROM% `&`& exit " `&`& exit'
					
	#Dolphin
	ESDE_addLauncher DOLPHIN dolphin
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_DOLPHIN% -b -e %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_DOLPHIN%" "-b" "-e" %ROM% `&`& exit " `&`& exit'	
	
	#PCSX2
	ESDE_addLauncher PCSX2 pcsx2
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_PCSX2% -batch %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_PCSX2%" "-batch" %ROM% `&`& exit " `&`& exit'
	
	#RPCS3
	ESDE_addLauncher RPCS3 rpcs3
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_RPCS3% --no-gui %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_RPCS3%" "--no-gui" %ROM% `&`& exit " `&`& exit'
	
	#PPSSPP
	ESDE_addLauncher PPSSPP PPSSPP
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_PPSSPP% %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_PPSSPP%" %ROM% `&`& exit " `&`& exit'
	
	#MelonDS
	ESDE_addLauncher MELONDS melonDS
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_MELONDS% %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_MELONDS%" %ROM% `&`& exit " `&`& exit'
	
	#Duckstation
	ESDE_addLauncher DUCKSTATION duckstation
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_DUCKSTATION% -batch %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_DUCKSTATION%" "-batch" %ROM% `&`& exit " `&`& exit'
	
	#Cemu
	ESDE_addLauncher CEMU Cemu	
	sedFile "$esdePath\resources\systems\windows\es_systems.xml" '%EMULATOR_CEMU% -f -g %ROM%' 'C:\Windows\System32\cmd.exe /k start /max "Emu" C:\Windows\System32\cmd.exe /K " "%EMULATOR_CEMU%" "-f" "-g" %ROM% `&`& exit " `&`& exit'
	
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
	
	mkdir "$esdePath/themes/" -ErrorAction SilentlyContinue
	
	git clone https://github.com/anthonycaccese/epic-noir-revisited-es-de "$esdePath/themes/epic-noir-revisited" --depth=1
	cd "$esdePath/themes/epic-noir-revisited" ; git reset --hard HEAD ; git clean -f -d ; git pull

	
	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	if($theme -eq "EPICNOIR"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'epic-noir-revisited'
	}
	if($theme -eq "MODERN-DE"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'modern-es-de'
	}
	if($theme -eq "RBSIMPLE-DE"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'slate-es-de'
	}		
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml"

}
function ESDE_IsInstalled(){
	$test=Test-Path -Path "$esdePath"
	$testold=Test-Path -Path "$toolsPath/EmulationStation-DE"
	if ($test -or $testold) {
		Write-Output "true"
	}

}
function ESDE_resetConfig(){
	ESDE_init
	if($?){
		echo "true"
	}
}