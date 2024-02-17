function appImageInit(){

	$ESDE_oldConfigDirectory="$esdePath\.emulationstation"
	$ESDE_newConfigDirectory="$esdePath\ES-DE"
	if (Test-Path -Path $ESDE_oldConfigDirectory) {
		Rename-Item $ESDE_oldConfigDirectory $ESDE_newConfigDirectory
		Write-Output "EmulationStation-DE config directory successfully migrated and linked."
	}



	#AutoFixes
	mkdir "$env:USERPROFILE/emudeck/feeds" -ErrorAction SilentlyContinue

	#Remove SRM BOM
	# $userConfigsFile="$toolsPath\userData\userConfigurations.json"
	# $content = Get-Content -Path $userConfigsFile -Raw
	# $killBOM = New-Object System.Text.UTF8Encoding $false
	# [System.IO.File]::WriteAllText($userConfigsFile, $content, $killBOM)


	#autofix_betaCorruption
	autofix_cloudSyncLockfile
	autofix_areInstalled
	#autofix_raSavesFolders
	#autofix_lnk
	#autofix_ESDE
	#autofix_dynamicParsers
	#autofix_oldParsersBAT
	#autofix_emulatorInitLaunchers
	#autofix_MAXMIN
	#autofix_junctions
	#autofix_controllerSettings
	#autofix_gamecubeFolder

	#ADB
	if ( Android_ADB_isInstalled -eq "false" ){
		Android_ADB_install
	}

	# Init functions
	setScreenDimensionsScale

	$test=Test-Path "$toolsPath\launchers\srm\steamrommanager.ps1"
	if ( -not $test ){
		mkdir "$toolsPath\launchers\srm\" -ErrorAction SilentlyContinue
		Copy-Item -Path "$env:APPDATA\EmuDeck\backend\tools\launchers\srm\steamrommanager.ps1" -Destination "$toolsPath\launchers\srm\" -Force
	}


#	mkdir "$emulationPath\roms\genesiswide" -ErrorAction SilentlyContinue
#	mkdir "$emulationPath\storage\rpcs3\dev_hdd0\game"  -ErrorAction SilentlyContinue

	echo "true"


}
