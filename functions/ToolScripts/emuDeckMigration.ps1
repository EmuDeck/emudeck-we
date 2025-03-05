function Migration_init {
    param (
        [string]$destination
    )

    # Tamaño de los archivos en el destino
    $neededSpace = (Get-ChildItem -Recurse -ErrorAction SilentlyContinue -Path $emulationPath | Measure-Object -Property Length -Sum).Sum / 1KB
    $neededSpaceInHuman = (Get-ChildItem -Recurse -ErrorAction SilentlyContinue -Path $emulationPath | Measure-Object -Property Length -Sum).Sum / 1MB

    # Espacio libre en el destino
    $driveInfo = Get-PSDrive -Name (Get-Item $destination).PSDrive.Name
    $freeSpace = $driveInfo.Free / 1KB
    $freeSpaceInHuman = $driveInfo.Free / 1MB

    $difference = $freeSpace - $neededSpace
    if ($difference -lt 0) {

        # Mostrar un cuadro de diálogo para continuar o salir
       confirmDialog -TitleText "EmuDeck" -MessageText "Make sure you have enough space in $destination. You need to have at least $neededSpaceInHuman MB available."
    }

    # Llamar a las funciones de migración (suponiendo que estén definidas)
    Migration_move $emulationPath $destination $neededSpaceInHuman
    #Migration_updatePaths $emulationPath "$destination\Emulation\"
}

function Migration_move {
    param (
        [string]$origin,
        [string]$destination,
        [string]$size
    )

    Add-Type -AssemblyName System.Windows.Forms
    mkdir "$destination/Emulation" -ErrorAction SilentlyContinue

    # Crear el diálogo de progreso
    $progressForm = New-Object System.Windows.Forms.Form
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Minimum = 0
    $progressBar.Maximum = 100
    $progressBar.Value = 0
    $progressBar.Width = 350
    $progressBar.Height = 20

    $progressForm.Text = "Migrating your current $size Emulation folder to $destination"
    $progressForm.Width = 400
    $progressForm.Height = 120
    $progressForm.StartPosition = 'CenterScreen'
    $progressForm.Controls.Add($progressBar)

    $progressLabel = New-Object System.Windows.Forms.Label
    $progressLabel.Text = "Scanning..."
    $progressLabel.Top = 30
    $progressLabel.Left = 10
    $progressForm.Controls.Add($progressLabel)

    $progressForm.Show()

    # Mover todo el contenido de Emulation a su nuevo destino
    $items = Get-ChildItem -Path $origin
    $totalItems = $items.Count
    $movedItems = 0

    foreach ($item in $items) {
        try {
            # Copiar item al nuevo destino
            $destinationPath = "$destination\Emulation\$($item.Name)"
            Copy-Item -Path $item.FullName -Destination $destinationPath -Recurse -Force

            # Si la copia fue exitosa, eliminar el origen
            Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction SilentlyContinue

            # Incrementar el contador de items movidos
            $movedItems++
        } catch {
            Write-Host "Error moving item: $($item.FullName)"
        }

        # Actualizar progreso
        $progressBar.Value = [math]::Round(($movedItems / $totalItems) * 100)
        $progressLabel.Text = "Migrating... ($movedItems of $totalItems)"
    }

    # Actualizar los paths tras la migración
    Migration_updatePaths $origin "$destination\Emulation"

    # Forzar la eliminación de la carpeta de origen tras la migración y actualización de paths
    Start-Sleep -Seconds 2  # Esperar un poco para asegurar que no haya procesos abiertos
    if (Test-Path $origin) {
        Remove-Item -Path $origin -Recurse -Force -ErrorAction SilentlyContinue
        if (-Not (Test-Path $origin)) {
            Write-Host "Source folder successfully deleted: $origin"
        } else {
            Write-Host "Warning: Failed to delete the source folder. It may contain locked files."
        }
    }

    # Finalizar progreso
    $progressBar.Value = 100
    $progressLabel.Text = "Migration completed."

    Start-Sleep -Seconds 2
    $progressForm.Close()

    Write-Host "Migration completed."
}


function Migration_updatePaths {
    param (
        [string]$origin,
        [string]$destination
    )

    # Actualización de las nuevas rutas
    setSetting "emulationPath" $destination
    setSetting "toolsPath" "$destination\tools"
    setSetting "romsPath" "$destination\roms"
    setSetting "biosPath" "$destination\bios"
    setSetting "savesPath" "$destination\saves"
    setSetting "storagePath" "$destination\storage"
    setSetting "ESDEscrapData" "$destination\tools\downloaded_media"

    # Función para reemplazar rutas en archivos de configuración
    function Update-ConfigFile {
        param (
            [string]$configFile,
            [string]$origin,
            [string]$destination
        )

        if (Test-Path $configFile) {
            (Get-Content $configFile) -replace [regex]::Escape($origin), $destination | Set-Content $configFile
        } else {
            Write-Host "Config file not found: $configFile"
        }
    }

    # Actualización de los archivos de configuración de emuladores
    Update-ConfigFile $Lime3DS_configFile $origin $destination
    Update-ConfigFile $Citra_configFile $origin $destination
    Update-ConfigFile $Dolphin_configFile $origin $destination
    Update-ConfigFile $DuckStation_configFileNew $origin $destination
    Update-ConfigFile $MAME_configFile $origin $destination
    Update-ConfigFile $melonDS_configFile $origin $destination
    Update-ConfigFile $mGBA_configFile $origin $destination
    Update-ConfigFile $PCSX2QT_configFile $origin $destination
    Update-ConfigFile $PPSSP_configFile $origin $destination
    Update-ConfigFile $Primehack_configFile $origin $destination
    Update-ConfigFile $RetroArch_configFile $origin $destination
    Update-ConfigFile $RMG_configFile $origin $destination
    Update-ConfigFile $RPCS3_configFile $origin $destination
    Update-ConfigFile $Ryujinx_configFile $origin $destination
    Update-ConfigFile $ScummVM_configFile $origin $destination
    Update-ConfigFile $Vita3K_configFile $origin $destination
    Update-ConfigFile $Xemu_configFile $origin $destination
    Update-ConfigFile $Xenia_XeniaSettings $origin $destination
    Update-ConfigFile $Yuzu_configFile $origin $destination

    # Llamar a la función de actualización de SRM
    Migration_updateSRM $origin $destination

    # Recargar las ubicaciones de las partidas guardadas
    Write-Host "Reconfigurando los enlaces simbólicos de saves..."
    Get-Command -Name "*_IsInstalled" | ForEach-Object {
        $func = $_.Name
        Write-Host "Checking emulator: $func"
        if (& $func) {
            $setup_func = $func -replace '_IsInstalled$', '_setupSaves'
            Write-Host "Setup function: $setup_func"
            if (Get-Command -Name $setup_func -ErrorAction SilentlyContinue) {
                Write-Host "Executing: $setup_func"
                & $setup_func
            } else {
                Write-Host "Setup function not found: $setup_func"
            }
        }
    }
    Write-Host "Junctions recreados correctamente."

    # Mensaje de éxito
    confirmDialog -TitleText "EmuDeck" -MessageText "Your library has been moved to $destination."

    Write-Host "Valid"
}

function Migration_updateSRM {
    param (
        [string]$origin,        # Ruta antigua
        [string]$destination    # Ruta nueva
    )

    $steamRegPath = "HKCU:\Software\Valve\Steam"
    $steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath

    # Reemplazar rutas en "shortcuts.vdf"
    Get-ChildItem $steamInstallPath -Recurse -Filter "shortcuts.vdf" | ForEach-Object {
        (Get-Content $_.FullName) -creplace [regex]::Escape($origin), $destination | Set-Content $_.FullName
    }

    # Actualizar "userSettings.json"
    $settingsFile = "$destination\tools\userData\userSettings.json"

    if (Test-Path $settingsFile) {
        $jsonText = Get-Content $settingsFile -Raw
        $settings = $jsonText | ConvertFrom-Json

        # Actualizar la ruta de ROMs
        $settings.environmentVariables.romsDirectory = "$destination\roms"

        # Guardar cambios
        $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
    } else {
        Write-Host "userSettings.json no encontrado, saltando actualización."
    }

    # Actualizar "userConfigurations.json"
    $configFile = "$destination\tools\userData\userConfigurations.json"

    if (Test-Path $configFile) {
        $jsonText = Get-Content $configFile -Raw
        $config = $jsonText | ConvertFrom-Json

        # Reemplazar solo si `executableArgs` contiene la ruta original
        foreach ($entry in $config) {
            if ($entry.executableArgs -match [regex]::Escape($origin)) {
                $entry.executableArgs = $entry.executableArgs -creplace [regex]::Escape($origin), $destination
            }
        }

        # Guardar cambios
        $config | ConvertTo-Json -Depth 10 | Set-Content $configFile
        Write-Host "userConfigurations.json actualizado correctamente."
    } else {
        Write-Host "userConfigurations.json no encontrado, saltando actualización."
    }

    # Reiniciar SRM después de la actualización
    SRM_init
}


function Migration_ESDE {
    ESDE_setEmulationFolder
}



#Migration_init "C:/users/rsedano/Desktop/bios"