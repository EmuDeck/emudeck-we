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
				confirmDialog -TitleText "We need to update your SRM shortcuts" -MessageText "We will close Steam now. When the update is completed you'll be able to use the new CloudSync visual notifications instead of the audio notifications"
				taskkill /IM steam.exe /F
				sedFile "$filePath" '/max' '/min'
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