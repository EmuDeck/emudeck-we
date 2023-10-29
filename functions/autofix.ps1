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


function autofix_MAXMIN(){

	$maxminMigrated="true"
	Get-ChildItem -Path "$toolsPath/launchers" -Filter "*.ps1" | ForEach-Object {
		$filePath=$_.FullName
		$fileContent=Get-Content "$filePath" -Raw
		if ( -not ($fileContent -like "*hideMe*") ){
			$maxminMigrated="false"
		}

	}
	if( $maxminMigrated -eq "false"){

		confirmDialog -TitleText "We need to update your SRM shortcuts and for that we will close Steam. When completed you'll be able to use the new CloudSync visual notifications instead of the audio notifications"

		taskkill /IM steam.exe /F
		SRM_resetLaunchers

		$steamRegPath = "HKCU:\Software\Valve\Steam"
		$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
		$steamInstallPath = $steamInstallPath.Replace("/", "\")

		$folders = Get-ChildItem -Path ("$steamInstallPath\userdata") -Directory

		foreach ($folder in $folders) {

			$filePath = "$steamInstallPath\userdata\$folder\config\shortcuts.vdf"
			if (Test-Path -Path "$filePath") {
				$shorcutsPath = "$filePath"
			}
		}

		sedFile "$shorcutsPath" '/max' '/min'
	}else{
		echo "nothing to do"
	}

}