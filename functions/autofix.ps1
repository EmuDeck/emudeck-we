#Put here your autofix functions, they should be load when EmuDeck Starts

function autofix_betaCorruption(){
	echo $MyInvocation.MyCommand.Name
	if ( "$env:APPDATA\EmuDeck\backend\functions\allCloud.ps1" -like "*NYI*" -and (-not (Test-Path "$toolsPath\cloudSync\WinSW-x64.exe"))){
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

function autofix_SRM(){
	createLauncher "srm\steamrommanager"
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
	if( -not $emuDreamcast -or -not $emuSCUMMVM ){
		setSetting emuDreamcast "multiemulator"
		setSetting emuSCUMMVM "scummvm"
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
		rm -fo -r "$userFolder\cloud.lock" -ErrorAction SilentlyContinue
	}
}

function autofix_raSavesFolders(){
	echo $MyInvocation.MyCommand.Name
	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory
	$doFixSaves = "false"
	if ($subfolders.Count -gt 0) {
		cloud_sync_createBackup "retroarch"
		foreach ($subfolder in $subfolders) {
			if ($subfolder -like "*Beetle Cygne*" -or $subfolder -like
				"*Beetle Lynx*" -or $subfolder -like
				"*Beetle NeoPop*" -or $subfolder -like
				"*Beetle PCE*" -or $subfolder -like
				"*Beetle PCE Fast*" -or $subfolder -like
				"*Beetle PSX*" -or $subfolder -like
				"*Beetle PSX HW*" -or $subfolder -like
				"*Beetle Saturn*" -or $subfolder -like
				"*Beetle WonderSwan*" -or $subfolder -like
				"*bsnes-hd beta*" -or $subfolder -like
				"*dolphin_emu*" -or $subfolder -like
				"*FinalBurn Neo*" -or $subfolder -like
				"*Flycast*" -or $subfolder -like
				"*Gambatte*" -or $subfolder -like
				"*Gearsystem*" -or $subfolder -like
				"*Genesis Plus GX*" -or $subfolder -like
				"*Handy*" -or $subfolder -like
				"*Kronos*" -or $subfolder -like
				"*MAME*" -or $subfolder -like
				"*MAME 2003-Plus*" -or $subfolder -like
				"*MAME 2010*" -or $subfolder -like
				"*melonDS*" -or $subfolder -like
				"*Mesen*" -or $subfolder -like
				"*mGBA*" -or $subfolder -like
				"*Mupen64Plus-Next*" -or $subfolder -like
				"*Nestopia*" -or $subfolder -like
				"*PAUE*" -or $subfolder -like
				"*PicoDrive*" -or $subfolder -like
				"*PPSSPP*" -or $subfolder -like
				"*PrBoom*" -or $subfolder -like
				"*PUAE*" -or $subfolder -like
				"*remaps*" -or $subfolder -like
				"*SameBoy*" -or $subfolder -like
				"*scummvm*" -or $subfolder -like
				"*Snes9x*" -or $subfolder -like
				"*Stella*" -or $subfolder -like
				"*SwanStation*" -or $subfolder -like
				"*YabaSanshiro*" -or $subfolder -like
				"*Yabause*"){
					$doFixSaves = "true"
					$subfolderPath = $subfolder.FullName
					moveFromTo "$subfolderPath" "$destinationFolder"
				}else{
					echo "Core directory not found, skip"
				}
		}
	}



	$sourceFolder = "$savesPath/RetroArch/saves"
	$destinationFolder = "$sourceFolder"
	$subfolders = Get-ChildItem -Path $sourceFolder -Directory
	$doFixStates= "false"
	if ($subfolders.Count -gt 0) {
		cloud_sync_createBackup "retroarch"
		foreach ($subfolder in $subfolders) {
			if ($subfolder -like "*Beetle Cygne*" -or $subfolder -like
				"*Beetle Lynx*" -or $subfolder -like
				"*Beetle NeoPop*" -or $subfolder -like
				"*Beetle PCE*" -or $subfolder -like
				"*Beetle PCE Fast*" -or $subfolder -like
				"*Beetle PSX*" -or $subfolder -like
				"*Beetle PSX HW*" -or $subfolder -like
				"*Beetle Saturn*" -or $subfolder -like
				"*Beetle WonderSwan*" -or $subfolder -like
				"*bsnes-hd beta*" -or $subfolder -like
				"*dolphin_emu*" -or $subfolder -like
				"*FinalBurn Neo*" -or $subfolder -like
				"*Flycast*" -or $subfolder -like
				"*Gambatte*" -or $subfolder -like
				"*Gearsystem*" -or $subfolder -like
				"*Genesis Plus GX*" -or $subfolder -like
				"*Handy*" -or $subfolder -like
				"*Kronos*" -or $subfolder -like
				"*MAME*" -or $subfolder -like
				"*MAME 2003-Plus*" -or $subfolder -like
				"*MAME 2010*" -or $subfolder -like
				"*melonDS*" -or $subfolder -like
				"*Mesen*" -or $subfolder -like
				"*mGBA*" -or $subfolder -like
				"*Mupen64Plus-Next*" -or $subfolder -like
				"*Nestopia*" -or $subfolder -like
				"*PAUE*" -or $subfolder -like
				"*PicoDrive*" -or $subfolder -like
				"*PPSSPP*" -or $subfolder -like
				"*PrBoom*" -or $subfolder -like
				"*PUAE*" -or $subfolder -like
				"*remaps*" -or $subfolder -like
				"*SameBoy*" -or $subfolder -like
				"*scummvm*" -or $subfolder -like
				"*Snes9x*" -or $subfolder -like
				"*Stella*" -or $subfolder -like
				"*SwanStation*" -or $subfolder -like
				"*YabaSanshiro*" -or $subfolder -like
				"*Yabause*"){
					$doFixStates = "true"
					$subfolderPath = $subfolder.FullName
					moveFromTo "$subfolderPath" "$destinationFolder"
				}else{
					echo "Core directory not found, skip"
				}
		}
	}

	if ( $doFixStates -eq "true" -or $doFixSaves -eq "true" ){
		confirmDialog -TitleText "Old RetroArch saves folders found" -MessageText "EmuDeck will create a backup of them in Emulation\saves-backup just in case, after that it will reorganize and delete the old subfolder. Please manually delete all subfolders you might have in your cloud provider ( EmuDeck/saves/retroarch/saves/* and EmuDeck/saves/retroarch/states/*)"
		setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
		setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
		setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
		setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
		setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile
	}
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
				echo "old parsers"
				#confirmDialog -TitleText "Old parsers detected" -MessageText "We've detected you are still using old launchers, please open Steam Rom Manager and parse all your games so they get updated to the new launchers"
			}
		}
	}else{
		echo "No /max detected"
	}
}

function autofix_junctions(){

	$globPath = $emulationPath[0] +":"

	$driveInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$globPath'"

	if ($driveInfo) {
		if ($driveInfo.DriveType -eq 4) {
			$VolumenName=$driveInfo.ProviderName
			setSetting networkInstallation "true"
		}else{
			setSetting networkInstallation "false"
			SRM_resetLaunchers
		}
	}

}

function autofix_showDialogController($emuName){

	$configVariable = $emuName + "_configFile"
	$configFile = (Get-Variable -Name $configVariable -ValueOnly)


	$initFunction = $emuName + "_init"
	switch($emuName){
		"Yuzu"{
			$string='*player_0_button_a="engine:sdl,port:0,guid:03000000de280000ff11000000007801,button:1"*'
		break
		}
		"Citra"{
			$string='*profiles\1\button_a="button:1,engine:sdl,guid:0300b969de280000ff11000000007200,port:0"*'
		break
		}
	}


	$configContent = Get-Content -Path "$configFile"
	if( $configContent -like "$string"){
		echo "$emuName controller config ok"
	}else{
		$result = yesNoDialog -TitleText "$emuName's controls misconfigured" -MessageText "We've detected that your $emuName controls are not our defaults, this will prevent Yuzu's hotkeys to work since Steam Input won't work" -OKButtonText "Fix it" -CancelButtonText "Don't"

			if ($result -eq "OKButton") {
				& $initFunction
			} else {
				echo "nope"
			}
	}

}

function autofix_controllerSettings(){
		echo $MyInvocation.MyCommand.Name

		autofix_showDialogController "Citra"
		autofix_showDialogController "Yuzu"

}

function autofix_gamecubeFolder(){
	$test=Test-Path "$romsPath\gc\metadata.txt"
	if ( -not $test ){

		mkdir "$romsPath\gc_temp"

		moveFromTo "$romsPath\gc" "$romsPath\gc_temp"
		moveFromTo "$romsPath\gamecube" "$romsPath\gc_temp"
		Rename-Item "$romsPath\gc_temp" "$romsPath\gc"

		$simLinkPath = "$romsPath\gamecube"
		$emuSavePath = "$romsPath\gc"
		createSaveLink "$simLinkPath" "$emuSavePath"
	}
}


function autofix_areInstalled(){
	setMSG 'Checking installation integrity'
	if ( $doInstallPrimeHack -eq "true" -and -not (PrimeHack_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected PrimeHack  was scheduled to install but was't properly installed, trying again now."

		Primehack_install; Primehack_init
	}
	if ( $doInstallRPCS3 -eq "true" -and -not (RPCS3_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected RPCS3  was scheduled to install but was't properly installed, trying again now."
		RPCS3_install; RPCS3_init
	}

	if ( $doInstallCitra -eq "true" -and -not (Citra_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Citra  was scheduled to install but was't properly installed, trying again now."
		Citra_install; Citra_init
	}
	if ( $doInstallDolphin -eq "true" -and -not (Dolphin_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected olphin  was scheduled to install but was't properly installed, trying again now."
		Dolphin_install; Dolphin_init
	}
	if ( $doInstallDuck -eq "true" -and -not (Duckstation_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Duckstation  was scheduled to install but was't properly installed, trying again now."
		DuckStation_install; DuckStation_init
	}
	if ( $doInstallPPSSPP -eq "true" -and -not (PPSSPP_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected PPSSPP  was scheduled to install but was't properly installed, trying again now."
		PPSSPP_install; PPSSPP_init
	}
	if ( $doInstallYuzu -eq "true" -and -not (Yuzu_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Yuzu  was scheduled to install but was't properly installed, trying again now."
		Yuzu_install; Yuzu_init
	}
	if ( $doInstallCemu -eq "true" -and -not (Cemu_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Cemu  was scheduled to install but was't properly installed, trying again now."
		Cemu_install; Cemu_init
	}
	if ( $doInstallXemu -eq "true" -and -not (Xemu_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Xemu  was scheduled to install but was't properly installed, trying again now."
		Xemu_install; Xemu_init
	}
	if ( $doInstallRyujinx -eq "true" -and -not (Ryujinx_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Ryujinx  was scheduled to install but was't properly installed, trying again now."
		Ryujinx_install; Ryujinx_init
	}
	if ( "$doInstallPCSX2" -eq "true" -and -not (PCSX2QT_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected PCSX2  was scheduled to install but was't properly installed, trying again now."
		PCSX2QT_install; PCSX2QT_init
	}
	# if ( "$doInstallSuperModel" -eq "true" -and -not (SuperModel_isInstalled -like "*true*")){
	# 	confirmDialog -TitleText "Error installing" -MessageText "We've detected SuperModel  was scheduled to install but was't properly installed, trying again now."
	# 	ESDE_install; 	# 	ESDE_init
	# }
	if ( $doInstallScummVM -eq "true" -and -not (ScummVM_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected ScummVM  was scheduled to install but was't properly installed, trying again now."
		ScummVM_install; ScummVM_init
	}
	if ( $doInstallVita3K -eq "true" -and -not (Vita3K_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Vita3K  was scheduled to install but was't properly installed, trying again now."
		Vita3K_install; Vita3K_init
	}
	if ( $doInstallMGBA -eq "true" -and -not (mGBA_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected mGBA  was scheduled to install but was't properly installed, trying again now."
		mGBA_install; mGBA_init
	}
	if ( $doInstallESDE -eq "true" -and -not (ESDE_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected ESDE  was scheduled to install but was't properly installed, trying again now."
		ESDE_install; ESDE_init
	}
	if ( $doInstallPegasus -eq "true" -and -not (pegasus_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Pegasus  was scheduled to install but was't properly installed, trying again now."
		pegasus_install; pegasus_init
	}
	# if ( $doInstallSRM -eq "true" -and -not (SRM_isInstalled -like "*true*")){
	# 	confirmDialog -TitleText "Error installing" -MessageText "We've detected Steam Rom Manager  was scheduled to install but was't properly installed, trying again now."
	# 	SRM_install; SRM_init
	# }
	if ( $doInstallRA -eq "true" -and -not (RetroArch_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected RetroArch  was scheduled to install but was't properly installed, trying again now."
		RetroArch_install; RetroArch_init
	}
	if ( $doInstallmelonDS -eq "true" -and -not (melonDS_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected melonDS  was scheduled to install but was't properly installed, trying again now."
		melonDS_install; melonDS_init
	}
	if ( $doInstallXenia -eq "true" -and -not (Xenia_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected Xenia  was scheduled to install but was't properly installed, trying again now."
		Xenia_install; Xenia_init
	}
	if ( $doInstallMAME -eq "true" -and -not (MAME_isInstalled -like "*true*")){
		confirmDialog -TitleText "Error installing" -MessageText "We've detected MAME  was scheduled to install but was't properly installed, trying again now."
		MAME_install; MAME_init
	}

}