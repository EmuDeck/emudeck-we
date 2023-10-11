function appImageInit(){

	setScreenDimensionsScale

# 	$sourceFolder = "$savesPath/RetroArch/saves"
# 	$destinationFolder = "$sourceFolder"
#
# 	$subfolders = Get-ChildItem -Path $sourceFolder -Directory
#
# 	if ($subfolders.Count -gt 0) {
# 		foreach ($subfolder in $subfolders) {
# 			$subfolderPath = $subfolder.FullName
# 			Copy-Item -Path "$subfolderPath\*" -Destination $destinationFolder -Recurse
# 		}
#
# 		$sourceFolder = "$savesPath/RetroArch/states"
# 		$destinationFolder = "$sourceFolder"
#
# 		$subfolders = Get-ChildItem -Path $sourceFolder -Directory
#
# 		foreach ($subfolder in $subfolders) {
# 			$subfolderPath = $subfolder.FullName
# 			Copy-Item -Path "$subfolderPath\*" -Destination $destinationFolder -Recurse
# 		}
#
# 		setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
# 		setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
# 		setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
# 		setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
# 		setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile
# 	}

}
