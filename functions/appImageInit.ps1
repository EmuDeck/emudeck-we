function appImageInit(){

	if ( "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1"  -like "*$NYI*"){
		confirmDialog -TitleText "Corrupted installation" -MessageText "EmuDeck will reinstall after clicking OK, nothing will be deleted. This could take a few seconds to download"
		$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
		download $url_emudeck "emudeck_install.exe"
		&"$temp/emudeck_install.exe"
-ForegroundColor Cyan
		break
		exit
	}

    rm -fo "$userFolder\cloud.lock" -ErrorAction SilentlyContinue
	SRM_init
	setScreenDimensionsScale

	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"

	$subfolders = Get-ChildItem -Path $sourceFolder -Directory

	if ($subfolders.Count -gt 0) {
		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			Copy-Item -Path "$subfolderPath\*" -Destination $destinationFolder -Recurse
		}

		$sourceFolder = "$savesPath/RetroArch/states"
		$destinationFolder = "$sourceFolder"

		$subfolders = Get-ChildItem -Path $sourceFolder -Directory

		foreach ($subfolder in $subfolders) {
			$subfolderPath = $subfolder.FullName
			Copy-Item -Path "$subfolderPath\*" -Destination $destinationFolder -Recurse
		}

		setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
		setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
		setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
		setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
		setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile
	}

	echo "true"

}
