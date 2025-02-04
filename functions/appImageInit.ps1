function appImageInit(){


	#emudeck folder relocation
	$path = "$env:USERPROFILE/EmuDeck"
	if (Test-Path -Path $path -PathType Container) {

	   confirmDialog -TitleText "Migration" -MessageText "We are going to move the $env:USERPROFILE/EmuDeck folder to $env:APPDATA\EmuDeck.Please wait until a new message confirms the migration"

		$destination = "$env:APPDATA/EmuDeck"
			# We copy the saves to the Emulation/saves Folder and we create a backup
		echo "Creating saves symlink"
		$originalFolderName = Split-Path $path -Leaf
		$newFolderName = Split-Path $destination -Leaf

		Get-ChildItem -Path "$path" | ForEach-Object {
			$destinationPath = Join-Path -Path $destination -ChildPath $_.Name
			if (-Not (Test-Path -Path $destinationPath)) {
			   Write-Host "Moving: $_.FullName to $destination" -ForegroundColor Blue
			   Move-Item -Path $_.FullName -Destination $destination
			} else {
				Write-Host "El elemento ya existe en el destino: $destinationPath" -ForegroundColor Yellow
			}
		}

		#createSaveLink $path "$env:APPDATA\EmuDeck\"

		 . "$env:APPDATA/EmuDeck/settings.ps1"
		 . "$env:APPDATA/EmuDeck/backend/vars.ps1"

		 SRM_resetLaunchers
		 SRM_createParsers
		 ESDE_init

		 Remove-Item -Path $path -Recurse -Force

		 $folders = Get-ChildItem -Path ("$steamInstallPath\userdata") -Director

		   foreach ($folder in $folders) {

			   $filePath = "$steamInstallPath\userdata\$folder\config\shortcuts.vdf"
			   if (Test-Path -Path "$filePath") {

				   $shorcutsPath = "$filePath"
			   }
		   }
		  Copy-Item "$shorcutsPath" -Destination "$shorcutsPath.baknew" -ErrorAction SilentlyContinue
		  $filePath = "$shorcutsPath"
		  $content = Get-Content -Raw -Encoding Default $filePath
		  $newContent = $content -replace [regex]::Escape("EmuDeck\Emulators"), "AppData\Roaming\EmuDeck\Emulators"
		  $newContent = $newContent -replace [regex]::Escape("EmuDeck\EmulationStation-DE\Emulators"), "AppData\Roaming\EmuDeck\Emulators"
		  Set-Content -Path $filePath -Value $newContent -Encoding Default

		 confirmDialog -TitleText "Complete" -MessageText "Migration complete,you can now use EmuDeck as always. The Emulation folder is still at $emulationPath"
	 }

	# Copy-Item "$shorcutsPath" -Destination "$shorcutsPath.bak" -ErrorAction SilentlyContinue


	$folders = Get-ChildItem -Path ("$steamInstallPath\userdata") -Director

	   foreach ($folder in $folders) {

		   $filePath = "$steamInstallPath\userdata\$folder\config\shortcuts.vdf.bak"
		   if (Test-Path -Path "$filePath") {
			  $shorcutsPath = "$filePath"
			  $result = yesNoDialog -TitleText "SRM Backup" -MessageText "Is your Steam Library corrupted? Do you want to restore your last backup?" -OKButtonText "Yes" -CancelButtonText "No"

			  if ($result -eq "OKButton") {
				 $steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
				 if ($steamRunning) {
					 taskkill /IM steam.exe /F
				 }
				 Rename-Item -Path "$steamInstallPath\userdata\$folder\config\shortcuts.vdf" -NewName "$steamInstallPath\userdata\$folder\config\shortcuts.vdf.bak2"
				 Copy-Item "$shorcutsPath" -Destination "$steamInstallPath\userdata\$folder\config\shortcuts.vdf" -ErrorAction SilentlyContinue
				 Rename-Item -Path "$shorcutsPath" -NewName "$shorcutsPath.restored"


			  }else{
				 Rename-Item -Path "$shorcutsPath" -NewName "$shorcutsPath.cancel"
			  }

		   }
	   }

	 $folders = Get-ChildItem -Path ("$steamInstallPath\userdata") -Director

		foreach ($folder in $folders) {

			$filePath = "$steamInstallPath\userdata\$folder\config\shortcuts.vdf"
			if (Test-Path -Path "$filePath") {

				$shorcutsPath = "$filePath"
			}
		}
	   Copy-Item "$shorcutsPath" -Destination "$shorcutsPath.baknew" -ErrorAction SilentlyContinue
	   $filePath = "$shorcutsPath"
	   $content = Get-Content -Raw -Encoding Default $filePath
	   $newContent = $content -replace [regex]::Escape("EmuDeck\Emulators"), "AppData\Roaming\EmuDeck\Emulators"
	   $newContent = $newContent -replace [regex]::Escape("EmuDeck\EmulationStation-DE\Emulators"), "AppData\Roaming\EmuDeck\Emulators"
	   Set-Content -Path $filePath -Value $newContent -Encoding Default


	 $path = "$esdePath/Emulators"
	 if (Test-Path -Path $path -PathType Container) {
	  $item = Get-Item $path
	  if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
		Write-Output "$path it's a junction."
	  } else {
		Write-Output "$path it's a directory."
		Move-Item -Path $path -Destination $emusPath
		createSaveLink $path $emusPath
		SRM_resetLaunchers
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
