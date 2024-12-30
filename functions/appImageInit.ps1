function appImageInit(){

	#Folder Migration
	$path = "$env:USERPROFILE/EmuDeck"
	if (Test-Path -Path $path -PathType Container) {

		$item = Get-Item $path

		if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
			Write-Output "$path it's a junction."
		} else {

			Get-ChildItem -Path "$env:USERPROFILE/EmuDeck" -Recurse -Directory | ForEach-Object {
				if ((Get-Item $_.FullName).Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
					Write-Host "Eliminando junction: $($_.FullName)" -ForegroundColor Yellow
					Remove-Item -Path $_.FullName -Recurse -Force
				}
			}
			#Write-Output "$path it's a directory."
			confirmDialog -TitleText "Migration" -MessageText "We are going to move the $env:USERPROFILE/EmuDeck folder to $env:APPDATA\EmuDeck.Please wait until a new message confirms the migration"

			moveFromTo "$path" "$env:APPDATA\EmuDeck"
			createSaveLink $path "$env:APPDATA\EmuDeck"
			SRM_resetLaunchers

			confirmDialog -TitleText "Complete" -MessageText "Migration complete,you can now use EmuDeck as always. The Emulation folder is still at $emulationPath"
		}
	}

	#AutoFixes
	mkdir "$emudeckFolder/feeds" -ErrorAction SilentlyContinue

	#Python
	if (Get-Command python -ErrorAction SilentlyContinue) {
	   Write-Output "Python already installed."
	} else {
	   Write-Host "Installing Python, please wait..."
	   $PYinstaller = "python-3.11.0-amd64.exe"
	   $url = "https://www.python.org/ftp/python/3.11.0/$PYinstaller"
	   download $url $PYinstaller
	   Start-Process "$temp\$PYinstaller" -Wait -Args "/passive InstallAllUsers=1 PrependPath=1 Include_test=0"
	}


	#CHD
	mkdir "$toolsPath\chdconv" -ErrorAction SilentlyContinue
	Copy-Item -Path "$env:APPDATA\EmuDeck\backend\tools\chdconv\chddeck.ps1" -Destination "$toolsPath\chdconv\" -Force

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
