function CreateStructureUSB {
    param(
        [string]$destination
    )

        # Crear directorios si no existen
        New-Item -Path "$destination\bios\" -ItemType Directory -Force
        New-Item -Path "$destination\bios\dc" -ItemType Directory -Force
        New-Item -Path "$destination\bios\yuzu\firmware" -ItemType Directory -Force
        New-Item -Path "$destination\bios\yuzu\keys" -ItemType Directory -Force
        New-Item -Path "$destination\roms\" -ItemType Directory -Force

        $readmeContent = @"
# Where to put your bios?
First of all, don't create any new subdirectory. ***
# System -> folder
Playstation 1 / Duckstation -> bios/
Playstation 2 / PCSX2 -> bios/
Nintendo DS / melonDS -> bios/
Playstation 3 / RPCS3 -> Download it from https://www.playstation.com/en-us/support/hardware/ps3/system-software/
Dreamcast / RetroArch -> bios/dc
Switch / Yuzu -> bios/yuzu/firmware and bios/yuzu/keys
Those are the only mandatory bios, the rest are optional
"@

        $readmePath = "$destination\bios\readme.txt"
        $readmeContent | Out-File -FilePath $readmePath -Encoding UTF8

        # Copiar archivos excluyendo los archivos .txt
        robocopy "$env:APPDATA\EmuDeck\backend\roms" "$destination\roms" /E /XO /XF *.txt
        if ($LASTEXITCODE -eq 0) {
            Write-Output "true"
        } else {
            Write-Output "false"
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
