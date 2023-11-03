#Put here your autofix functions, they should be load when EmuDeck Starts

function autofix_betaCorruption(){
	echo $MyInvocation.MyCommand.Name
	if ( "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1" -like "*NYI*" -and (-not (Test-Path "$toolsPath\cloudSync\WinSW-x64.exe"))){
			confirmDialog -TitleText "Corrupted installation" -MessageText "EmuDeck will reinstall after clicking OK, nothing will be deleted. This could take a few seconds to download"
			$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
			download $url_emudeck "emudeck_install.exe"
			&"$temp/emudeck_install.exe"
	-ForegroundColor Cyan
			break
			exit
	}else{
		Write-Output "early OK!"
	}
}

function autofix_oldParsersBAT(){
	echo $MyInvocation.MyCommand.Name
	$steamRegPath = "HKCU:\Software\Valve\Steam"
	$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	$steamInstallPath = $steamInstallPath.Replace("/", "\\")

	$steamPath = "$steamInstallPath\userdata"
	# Busca el archivo shortcuts.vdf en cada carpeta de userdata
	$parsersUpdated="Yes"

	$archivosLinksVDF = Get-ChildItem -Path $steamPath -File -Recurse -Filter "shortcuts.vdf"

	if ($archivosLinksVDF.Count -gt 0) {
		$archivosLinksVDF | ForEach-Object {
			$filePath =  $_.FullName
			$shortcutsContent = Get-Content -Path $filePath
			if ($shortcutsContent -like "*.bat*"){
				confirmDialog -TitleText "Old parsers detected" -MessageText "We've detected you are still using the old .bat launchers, please open Steam Rom Manager and parse all your games so they get updated to the new .ps1 launchers"
			}
		}
	}

}

function autofix_dynamicParsers(){
	echo $MyInvocation.MyCommand.Name
	if( -not $emuMULTI -or -not $emuGBA -or -not $emuMAME -or -not $emuN64 -or -not $emuNDS -or -not $emuPSP -or -not $emuPSX ){
		confirmDialog -TitleText "SRM Parsers issue detected" -MessageText "We've detected issues with the Dynamic Parsers, if you were missing some parsers this action will fix it. If you are still facing SRM issues do a Custom Reset"
		setSetting emuMULTI "ra"
		setSetting emuGBA "multiemulator"
		setSetting emuMAME "multiemulator"
		setSetting emuN64 "multiemulator"
		setSetting emuNDS "melonDS"
		setSetting emuPSP "ppsspp"
		setSetting emuPSX "duckstation"
		SRM_init
	}
}


function autofix_lnk(){
	echo $MyInvocation.MyCommand.Name
	$sourceFolder = "$savesPath"

	if ( Get-ChildItem -Path "$sourceFolder" -Filter *.lnk ){
		confirmDialog -TitleText "Old .lnk files found in Emulation/saves/" -MessageText "We will delete them since they are no longer neccesary and can cause problems. Make sure to delete them in your cloud provider in every subfolder"
	}

	Get-ChildItem -Path "$sourceFolder" -Filter "*.lnk" | ForEach-Object {
		$filePath=$_.FullName
		Remove-Item -path $filePath -Force
	}
}

function autofix_cloudSyncLockfile(){
	if( Test-Path "$userFolder\cloud.lock" ){
		confirmDialog -TitleText "CloudSync Lock file detected" -MessageText "EmuDeck will delete the cloud.lock fike. Maybe your upload failed?"
		rm -fo "$userFolder\cloud.lock" -ErrorAction SilentlyContinue
	}
}

function autofix_raSavesFolders(){
	echo $MyInvocation.MyCommand.Name
	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory
	$doFixSaves="false"
	if ($subfolders.Count -gt 0) {
		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			$subSubFolders = Get-ChildItem -Path $subfolderPath -Directory

			if ($subSubFolders.Count -gt 0) {
				echo "More than one subdirectory, skip"
			}else{
				$doFixSaves="true"
			}

		}
	}



	if ( $doFixSaves -eq "true" ){
		confirmDialog -TitleText "Old RetroArch saves folders found" -MessageText "EmuDeck will create a backup of them in Emulation\saves-backup just in case, after that it will reorganize and delete the old subfolder. Please manually delete all subfolders you might have in your cloud provider ( EmuDeck/saves/retroarch/saves/* and EmuDeck/saves/retroarch/states/*)"
		cloud_sync_createBackup "retroarch"
		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			$subSubFolders = Get-ChildItem -Path $subfolderPath -Directory

			if ($subSubFolders.Count -gt 0) {
				echo "More than one subdirectory, skip"
			}else{
				robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
				Remove-Item -Path $subfolderPath -Force -Recurse
			}
		}
	}


	$sourceFolder = "$savesPath/RetroArch/states"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory
	$doFixStates="false"
	if ($subfolders.Count -gt 0) {
		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			$doFixStates="true"

		}
	}

	if ( $doFixStates -eq "true" ){
		if ( $doFixSaves -eq "false" ){
			confirmDialog -TitleText "Old RetroArch saves folders found" -MessageText "EmuDeck will create a backup of them in Emulation\saves-backup just in case, after that it will reorganize and delete the old subfolder. Please manually delete all subfolders you might have in your cloud provider ( EmuDeck/saves/retroarch/saves/* and EmuDeck/saves/retroarch/states/*)"
		}
		robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
		Remove-Item -Path $subfolderPath -Force -Recurse
	}


	$RetroArch_configFile="$emusPath\RetroArch\retroarch.cfg"
	setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
	setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
	setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
	setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
	setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile

}

function autofix_ESDE(){
	echo $MyInvocation.MyCommand.Name
	if (ESDE_isInstalled -like "*true*"){

		$xmlFile = "$env:USERPROFILE\emudeck\EmulationStation-DE\.emulationstation\es_settings.xml"

		if (-not (Select-String -Pattern "Emulation\\" -Path "$xmlFile")){
			confirmDialog -TitleText "ESDE is not set up" -MessageText "EmuDeck will create its settings now."
			ESDE_Init
		}

		if (-not (Test-Path -Path $xmlFile)){
			confirmDialog -TitleText "ESDE settings not found" -MessageText "EmuDeck will create its settings now."
			ESDE_Init
		}
	}
}


function autofix_emulatorInitLaunchers(){
		echo $MyInvocation.MyCommand.Name
		Get-ChildItem -Path "$toolsPath/launchers" -Filter "*.ps1" | ForEach-Object {
			$filePath=$_.FullName
			$fileContent=Get-Content "$filePath" -Raw
			if ( -not ($fileContent -like "*emulatorInit*") ){
				SRM_resetLaunchers
			}
		}
}

function autofix_MAXMIN(){
	echo $MyInvocation.MyCommand.Name
	#Steam installation Path
	$steamRegPath = "HKCU:\Software\Valve\Steam"
	$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	$steamInstallPath = $steamInstallPath.Replace("/", "\\")

	$steamPath = "$steamInstallPath\userdata"

	$archivosLinksVDF = Get-ChildItem -Path $steamPath -File -Recurse -Filter "shortcuts.vdf"

	if ($archivosLinksVDF.Count -gt 0) {
		$archivosLinksVDF | ForEach-Object {
			$filePath =  $_.FullName
			$shortcutsContent = Get-Content -Path $filePath
			if ($shortcutsContent -like "*/max*"){
				confirmDialog -TitleText "We need to update your SRM shortcuts" -MessageText "We will close Steam now. When the update is completed you'll be able to use the new CloudSync visual notifications instead of the audio notifications"
				taskkill /IM steam.exe /F
				sedFile "$shorcutsPath" '/max' '/min'
			}
		}
	}else{
		echo "No /max detected"
	}
}