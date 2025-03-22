function appImageInit(){

	SRM_resetLaunchers

	#Emulators new Path Junction
	$carpetaReal = "$env:USERPROFILE/EmuDeck/Emulators"
	$carpetaSymlink = "$env:APPDATA/EmuDeck/Emulators"

	# Verificar si la carpeta real existe como un directorio
	$esDirectorioReal = Test-Path $carpetaReal -PathType Container

	# Verificar si la carpeta symlink no existe o si existe pero no es un junction
	$existeSymlink = Test-Path $carpetaSymlink -PathType Container
	$esJunctionSymlink = $false

	if ($existeSymlink) {
		$esJunctionSymlink = (Get-Item $carpetaSymlink).Attributes -match "ReparsePoint"
	}

	# Si la carpeta real existe y la symlink no existe o no es un junction, crear el symlink
	if ($esDirectorioReal -and (-not $existeSymlink -or -not $esJunctionSymlink)) {
		createSaveLink $carpetaReal $carpetaSymlink
	}

	#ESDE new Path Junction
	$carpetaReal = "$env:USERPROFILE/EmuDeck/EmulationStation-DE"
	$carpetaSymlink = "$env:APPDATA/EmuDeck/EmulationStation-DE"

	# Verificar si la carpeta real existe como un directorio
	$esDirectorioReal = Test-Path $carpetaReal -PathType Container

	# Verificar si la carpeta symlink no existe o si existe pero no es un junction
	$existeSymlink = Test-Path $carpetaSymlink -PathType Container
	$esJunctionSymlink = $false

	if ($existeSymlink) {
		$esJunctionSymlink = (Get-Item $carpetaSymlink).Attributes -match "ReparsePoint"
	}

	# Si la carpeta real existe y la symlink no existe o no es un junction, crear el symlink
	if ($esDirectorioReal -and (-not $existeSymlink -or -not $esJunctionSymlink)) {
		createSaveLink $carpetaReal $carpetaSymlink
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
