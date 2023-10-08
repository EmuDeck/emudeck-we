function appImageInit(){

	setScreenDimensionsScale

	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"

	$subfolders = Get-ChildItem -Path $sourceFolder -Directory

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

}
