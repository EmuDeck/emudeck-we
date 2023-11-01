#Put here your autofix functions, they should be load when EmuDeck Starts

function autofix_betaCorruption(){

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

function autofix_oldParsers(){

	#Steam installation Path
	$steamRegPath = "HKCU:\Software\Valve\Steam"
	$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	$steamInstallPath = $steamInstallPath.Replace("/", "\\")

	$folders = Get-ChildItem -Path (Join-Path $steamInstallPath "userdata") -Directory

	# Busca el archivo shortcuts.vdf en cada carpeta de userdata
	foreach ($folder in $folders) {
		$filePath = Join-Path $folder.FullName "shortcuts.vdf"
		if (Test-Path -Path $filePath) {
			$shorcutsPath = $filePath
			$shorcutsContent = Get-Content -Path $filePath
		}
	}

	if ($shorcutsContent -like "*.bat*" ){
		confirmDialog -TitleText "Old parsers detected" -MessageText "We've detected you are still using the old .bat launchers, please open Steam Rom Manager and parse all your games so they get updated to the new .ps1 launchers"
	}


}

function autofix_dynamicParsers(){
	if( -not $emuMULTI -or -not $emuGBA -or -not $emuMAME-or -not $emuN64 -or -not $emuNDS -or -not $emuPSP -or -not $emuPSX ){
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

	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory

	if ($subfolders.Count -gt 0) {

		$subSubfolders = Get-ChildItem -Path $subfolders -Directory
		foreach ($subfolder in $subfolders) {
			$subSubfolders = Get-ChildItem -Path $subfolders -Directory
			if ($subfolders.Count -lt 2) {
				cloud_sync_createBackup "retroarch"
				confirmDialog -TitleText "Old RetroArch saves folders found" -MessageText "EmuDeck will create a backup of them in Emulation\saves-backup just in case, after that it will reorganize and delete the old subfolder. Please manually delete all subfolders you might have in your cloud provider ( EmuDeck/saves/retroarch/saves/* and EmuDeck/saves/retroarch/states/*)"
				$subfolderPath = $subfolder.FullName
				robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
				Remove-Item -Path $subfolderPath -Force -Recurse
			}
		}

	}

	$sourceFolder = "$savesPath/RetroArch/states"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory

	if ($subfolders.Count -gt 0) {
		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
			Remove-Item -Path $subfolderPath -Force -Recurse
		}
	}
	$RetroArch_configFile="$emusPath\RetroArch\retroarch.cfg"
	setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
	setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
	setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
	setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
	setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile

}

function autofix_ESDE(){
	if ($doInstallESDE -eq "true"){

		$xmlFile = "$env:USERPROFILE\emudeck\EmulationStation-DE\.emulationstation\es_settings.xml"
		if (-not (Select-String -Pattern "Emulation\\roms" -Path $xmlFile)){
			confirmDialog -TitleText "ESDE is not set up" -MessageText "EmuDeck will create its settings now."
			ESDE_Init
		}

		if (-not (Test--Path -Path $xmlFile)){
			confirmDialog -TitleText "ESDE is not set up" -MessageText "EmuDeck will create its settings now."
			ESDE_Init
		}
	}
}