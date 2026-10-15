function CreateStructureUSB {
    param(
        [string]$destination
    )

    $tmpDir = Join-Path $env:TEMP "emudeck_quickstart"
    Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null
    $ProgressPreference = 'SilentlyContinue'

    try {
        Invoke-WebRequest -Uri "https://github.com/EmuDeck/quickstart/archive/refs/heads/main.zip" -OutFile "$tmpDir\quickstart.zip" -UseBasicParsing -ErrorAction Stop
        Expand-Archive -Path "$tmpDir\quickstart.zip" -DestinationPath $tmpDir -Force -ErrorAction Stop

        robocopy "$tmpDir\quickstart-main\EmuDeckBackup" "$destination\EmuDeckBackup" /E /XC /XN /XO /NJH /NJS /NP | Out-Null
        $robocopyCode = $LASTEXITCODE
        if (-not (Test-Path "$destination\README.md")) {
            Copy-Item -Path "$tmpDir\quickstart-main\README.md" -Destination "$destination\" -ErrorAction Stop
        }

        if ($robocopyCode -lt 8) {
            Write-Output "true"
        } else {
            Write-Output "false"
        }
    } catch {
        Write-Output "false"
    } finally {
        Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}



function CopyGames {
    param(
        [string]$origin
    )

    $neededSpace = (Get-ChildItem -Recurse -Force -File -Path $origin | Measure-Object -Sum Length).Sum
    $neededSpaceInHuman = [math]::round($neededSpace / 1GB, 2)


    $driveLetter = (Split-Path -Qualifier $emulationPath)

    $volume = Get-Volume -DriveLetter $driveLetter.TrimEnd(':')

    $freeSpace = $volume.SizeRemaining
    $freeSpaceInHuman = [math]::round($freeSpace / 1GB, 2)
    $difference = $freeSpace - $neededSpace

    if ($difference -lt 0) {

        $result = yesNoDialog -TitleText "CloudSync Force" -MessageText "Make sure you have enough space in $emulationPath. You need to have at least $neededSpaceInHuman GB available" -OKButtonText "Continue" -CancelButtonText "Cancel"

        if ($result -eq "OKButton") {
            $dialog = steamToast  -MessageText "Uploading all systems... don't turn off your device"
            cloud_sync_uploadEmuAll
            $dialog.Close()
        } else {
            exit
            $dialog.Close()
        }
    }


    foreach ($entry in Get-ChildItem -Path "$origin\roms\" -Directory) {
        $files = Get-ChildItem -Path $entry.FullName -Recurse -File | Where-Object { $_.Extension -ne ".txt" }
        if ($files.Count -gt 0) {
            $dir = $entry.Name

            # Copiar usando robocopy en lugar de rsync
            Write-Output "Importing your $dir games to $romsPath"
            robocopy "$origin\roms\$entry\" "$romsPath\$dir\" /E /XO /XD .* /NJH /NJS /NP
        }
    }

    Write-Output "Importing your bios to $biosPath"
    robocopy "$origin\bios" "$biosPath" /E /XO /NJH /NJS /NP

    confirmDialog -TitleText "Success" -MessageText "The contents of your USB Drive have been copied to your Emulation folder"
    Start-Sleep -Seconds 3
    Write-Output "3... 2... 1..."
}
