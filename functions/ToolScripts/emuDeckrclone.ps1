$rclone_path="$toolsPath/rclone"
$rclone_bin="$rclone_path/rclone.exe"
$rclone_config="$rclone_path/rclone.conf"


function rclone_install($rclone_provider){	
	$rclone_releaseURL = getLatestReleaseURLGH 'rclone/rclone' 'zip' 'windows-amd64'
	download $rclone_releaseURL "rclone.zip"	
	
	$regex = '^.*\/(rclone-v\d+\.\d+\.\d+-windows-amd64\.zip)$'
	
	if ($rclone_releaseURL -match $regex) {
		
		$filename = $matches[1]
		
		$filename = $filename.Replace('.zip','')
		
		Rename-Item "temp\rclone\$filename" -NewName "rclone" 
		
		moveFromTo "temp/rclone/" "$toolsPath\"	
		Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"
		rm -fo  "temp\rclone" -Recurse
	}

	& $rclone_bin config update "$rclone_provider" 
	
	setSetting "rclone_provider" "$rclone_provider"
	. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
	
}

function rclone_uninstall(){	
	rm -fo  "$toolsPath/rclone"	
}

function rclone_downloadEmu($emuName){	
	if (Test-Path "$rclone_bin") {
	echo "Downloading $emuName States/Saves"
		$sh = New-Object -ComObject WScript.Shell
		if (Test-Path "$emulationPath\saves\$emuName\saves.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saves.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\saves" "$target"
		}
		if (Test-Path "$emulationPath\saves\$emuName\states.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\states.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\states" "$target"
		}
		if (Test-Path "$emulationPath\saves\$emuName\GC.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\GC.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\GC" "$target"
		}
		if (Test-Path "$emulationPath\saves\$emuName\WII.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\WII.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\WII" "$target"
		}
	}
}

function rclone_uploadEmu($emuName){	
	if (Test-Path "$rclone_bin") {
	echo "Uploading $emuName States/Saves"
		$sh = New-Object -ComObject WScript.Shell
		if (Test-Path "$emulationPath\saves\$emuName\saves.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saves.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\saves"
		}
		if (Test-Path "$emulationPath\saves\$emuName\states.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\states.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\states" 
		}
		if (Test-Path "$emulationPath\saves\$emuName\GC.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\GC.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\GC" 
		}
		if (Test-Path "$emulationPath\saves\$emuName\WII.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\WII.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\WII" 
		}
	}
}


function rclone_downloadEmuAll(){
	if ($doInstallRA -eq "true"){
		rclone_downloadEmu retroarch
	}
	if ($doInstallDolphin -eq "true"){
		rclone_downloadEmu dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		rclone_downloadEmu PCSX2
	}
	#if ($doInstallRPCS3 -eq "true"){
	#	rclone_downloadEmu RPCS3
	#}
	if ($doInstallYuzu -eq "true"){
		rclone_downloadEmu yuzu
	}
	#if ($doInstallCitra -eq "true"){
	#	rclone_downloadEmu citra
	#}
	if ($doInstallDuck -eq "true"){
		rclone_downloadEmu duckstation
	}
	if ($doInstallCemu -eq "true"){
		rclone_downloadEmu cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	rclone_downloadEmu xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		rclone_downloadEmu PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	rclone_downloadEmu xemu
	#}
}

function rclone_uploadEmuAll(){
	if ($doInstallRA -eq "true"){
		rclone_uploadEmu retroarch
	}
	if ($doInstallDolphin -eq "true"){
		rclone_uploadEmu dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		rclone_uploadEmu PCSX2
	}
	#if ($doInstallRPCS3 -eq "true"){
	#	rclone_uploadEmu RPCS3
	#}
	if ($doInstallYuzu -eq "true"){
		rclone_uploadEmu yuzu
	}
	#if ($doInstallCitra -eq "true"){
	#	rclone_uploadEmu citra
	#}
	if ($doInstallDuck -eq "true"){
		rclone_uploadEmu duckstation
	}
	if ($doInstallCemu -eq "true"){
		rclone_uploadEmu cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	rclone_uploadEmu xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		rclone_uploadEmu PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	rclone_uploadEmu xemu
	#}

}