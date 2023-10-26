#Put here your autofix functions, they should be load when EmuDeck Starts

function autofix_betaCorruption(){
	if ( "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1"  -like "*NYI*" -and -not Test-path "$toolsPath\cloudSync"){
			confirmDialog -TitleText "Corrupted installation" -MessageText "EmuDeck will reinstall after clicking OK, nothing will be deleted. This could take a few seconds to download"
			$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
			download $url_emudeck "emudeck_install.exe"
			&"$temp/emudeck_install.exe"
	-ForegroundColor Cyan
			break
			exit
		}
}

function autofix_lnk(){
	$sourceFolder = "$savesPath"

	if ( Get-ChildItem -Path "$sourceFolder" -Filter *.lnk ){
		confirmDialog -TitleText "Old .lnk files found in Emulation/saves/" -MessageText "We will delete them since they are no longer neccesary and can cause problems. Make sure to delete them in your cloud provider in every subfolder"
	}

	Get-ChildItem -Path "$sourceFolder" -Filter *.lnk | ForEach-Object {
		$filePath="$_.FullName"
		Remove-Item –path "$filePath" -force
	}
}

function autofix_cloudSyncLockfile(){
	confirmDialog -TitleText "Corrupted installation" -MessageText "EmuDeck will reinstall after clicking OK, nothing will be deleted. This could take a few seconds to download"
	rm -fo "$userFolder\cloud.lock" -ErrorAction SilentlyContinue
}

function autofix_raSavesFolders(){

	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory

	if ($subfolders.Count -gt 0) {
		cloud_sync_createBackup "retroarch"
		confirmDialog -TitleText "Old RetroArch saves folders found" -MessageText "EmuDeck will create a backup of them in Emulation\saves-backup just in case, after that it will reorganize and delete the old subfolder. Please manually delete all subfolders you might have in your cloud provider ( EmuDeck/saves/retroarch/saves/* and EmuDeck/saves/retroarch/states/*)"
		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
			Remove-Item -Path $subfolderPath -Force -Recurse
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

	#setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
	#setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
	#setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
	#setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
	#setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile

}