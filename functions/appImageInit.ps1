function appImageInit(){

	#AutoFixes
	mkdir "$env:USERPROFILE/emudeck/feeds" -ErrorAction SilentlyContinue

	#Remove SRM BOM
	# $userConfigsFile="$toolsPath\userData\userConfigurations.json"
	# $content = Get-Content -Path $userConfigsFile -Raw
	# $killBOM = New-Object System.Text.UTF8Encoding $false
	# [System.IO.File]::WriteAllText($userConfigsFile, $content, $killBOM)


	#autofix_betaCorruption
	autofix_cloudSyncLockfile
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

	# Init functions
	setScreenDimensionsScale

	# $test=Test-Path "$toolsPath\launchers\srm\steamrommanager.ps1"
	# if ( -not $test ){
	# 	mkdir "$toolsPath\userData\" -ErrorAction SilentlyContinue
	# 	mkdir "$toolsPath\launchers\srm\" -ErrorAction SilentlyContinue
	# 	Copy-Item -Path "$env:APPDATA\EmuDeck\backend\tools\launchers\srm\steamrommanager.ps1" -Destination "$toolsPath\launchers\srm\" -Force
	# }


#	mkdir "$emulationPath\roms\genesiswide" -ErrorAction SilentlyContinue
#	mkdir "$emulationPath\storage\rpcs3\dev_hdd0\game"  -ErrorAction SilentlyContinue

	echo "true"


}
