function ESDE_install(){
	setMSG 'Downloading EmulationStation DE'
	download $url_esde "esde.zip"
	mkdir $esdePath -ErrorAction SilentlyContinue
	moveFromTo "$temp/esde/EmulationStation-DE" "$esdePath"	
}
function ESDE_init(){	
	setMSG 'EmulationStation DE - Paths and Themes'
	
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
	
	#PS2 Fixes	
	sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\PCSX2-Qt\pcsx2-qtx64*.exe</entry>' '<entry>%ESPATH%\Emulators\PCSX2-Qt\pcsx2-qtx64*.exe</entry><entry>%ESPATH%\Emulators\PCSX2\pcsx2-qtx64*.exe</entry>' 
	
	#Citra fixes
	sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\Citra\nightly-mingw\citra-qt.exe</entry>' '<entry>%ESPATH%\Emulators\citra\citra-qt.exe</entry>'
	
	
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