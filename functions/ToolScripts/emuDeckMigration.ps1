function Migration_init {
    param (
        [string]$destination
    )

    $neededSpace = (Get-ChildItem -Path $emulationPath -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $neededSpaceInHuman = "{0:N1} GB" -f ($neededSpace / 1GB)

    $freeSpace = (New-Object System.IO.DriveInfo($destination)).AvailableFreeSpace
    if ($freeSpace -lt $neededSpace) {
        $ans = confirmDialog -TitleText "EmuDeck Migration tool" -MessageText "Make sure you have enough space in $destination. You need to have at least $neededSpaceInHuman available" -OKButtonText "Continue" -CancelButtonText "Exit"
        if ($ans -eq "OKButton") {
            Write-Host "Continue..."
        } else {
            exit
        }
    }

    if (Migration_move $emulationPath $destination $neededSpaceInHuman) {
        Migration_updatePaths $emulationPath (Join-Path $destination "Emulation")
    }
}

function Migration_move {
    param (
        [string]$origin,
        [string]$destination,
        [string]$size
    )

    Write-Host "Migrating your current $size Emulation folder to $destination"
    $target = Join-Path $destination "Emulation"
    $robocopy = Start-Process -FilePath "robocopy" -ArgumentList "`"$origin`" `"$target`" /E /XJ /MT:16 /R:5 /W:5" -PassThru -Wait
    return $robocopy.ExitCode -lt 8
}

function Migration_replacePath {
    param (
        [string]$file,
        [string]$origin,
        [string]$destination
    )

    if (-not (Test-Path $file)) {
        Write-Host "Config file not found: $file"
        return
    }

    $latin1 = [System.Text.Encoding]::GetEncoding(28591)
    $content = $latin1.GetString([System.IO.File]::ReadAllBytes($file))
    $newContent = $content
    foreach ($separator in @('\\', '/', '\')) {
        $old = $latin1.GetString([System.Text.Encoding]::UTF8.GetBytes($origin.Replace('\', $separator)))
        $new = $latin1.GetString([System.Text.Encoding]::UTF8.GetBytes($destination.Replace('\', $separator)))
        $newContent = $newContent.Replace($old, $new)
    }
    if ($newContent -cne $content) {
        [System.IO.File]::WriteAllBytes($file, $latin1.GetBytes($newContent))
    }
}

function Migration_updatePaths {
    param (
        [string]$origin,
        [string]$destination
    )

    setSetting "emulationPath" "$destination"
    setSetting "toolsPath" "$destination\tools"
    setSetting "romsPath" "$destination\roms"
    setSetting "biosPath" "$destination\bios"
    setSetting "savesPath" "$destination\saves"
    setSetting "storagePath" "$destination\storage"
    setSetting "ESDEscrapData" "$destination\tools\downloaded_media"

    . "$emudeckFolder\settings.ps1"

    Migration_replacePath $Azahar_configFile $origin $destination
    Migration_replacePath "$emusPath\cemu\settings.xml" $origin $destination
    Migration_replacePath $Citron_configFile $origin $destination
    Migration_replacePath $Dolphin_configFile $origin $destination
    Migration_replacePath $DuckStation_configFile $origin $destination
    Migration_replacePath $Eden_configFile $origin $destination
    Migration_replacePath "$esdePath\ES-DE\settings\es_settings.xml" $origin $destination
    Migration_replacePath $Flycast_configFile $origin $destination
    Migration_replacePath $MAME_configFile $origin $destination
    Migration_replacePath $melonD_configFile $origin $destination
    Migration_replacePath $mGBA_configFile $origin $destination
    Migration_replacePath $PCSX2QT_configFile $origin $destination
    Migration_replacePath $PPSSP_configFile $origin $destination
    Migration_replacePath $Primehack_configFile $origin $destination
    Migration_replacePath $RetroArch_configFile $origin $destination
    Migration_replacePath "$emusPath\RPCS3\config\vfs.yml" $origin $destination
    Migration_replacePath $Ryujinx_configFile $origin $destination
    Migration_replacePath $ShadPS4_configFile $origin $destination
    Migration_replacePath $ScummVM_configFile $origin $destination
    Migration_replacePath $Vita3K_configFile $origin $destination
    Migration_replacePath $Xemu_configFile $origin $destination
    Migration_replacePath $Xenia_configFile $origin $destination
    Migration_replacePath $Yuzu_configFile $origin $destination
    Migration_updateSRM $origin $destination

    Get-Command -Name "*_IsInstalled" -CommandType Function | ForEach-Object {
        $func = $_.Name
        Write-Host $func
        if ("$(& $func)" -eq "true") {
            $setup_func = $func -replace '_IsInstalled$', '_setupSaves'
            Write-Host $setup_func
            if (Get-Command -Name $setup_func -ErrorAction SilentlyContinue) {
                & $setup_func
            }
        }
    }

    confirmDialog -TitleText "EmuDeck" -MessageText "Success! Your library has been moved to $destination. Please restart Steam now to apply the changes"

    Write-Host "Valid"
}

function Migration_updateSRM {
    param (
        [string]$origin,
        [string]$destination
    )

    Get-ChildItem -Path "$steamInstallPath\userdata\*\config\shortcuts.vdf" -ErrorAction SilentlyContinue | ForEach-Object {
        Migration_replacePath $_.FullName $origin $destination
    }

    SRM_init
}

function Migration_ESDE {
    ESDE_setEmulationFolder
}
