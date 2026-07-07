. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

$flatpaktool=''
$dolphintool=''

if (-not $EMUDECKGIT) {
    $EMUDECKGIT = "$env:APPDATA\EmuDeck\backend"
}

# Whitelist arrays
$chdfolderWhiteList = @("3do", "amiga", "amiga1200", "amiga600",
"amigacd32", "atomiswave", "cdimono1", "cdtv", "dreamcast", "genesis",
 "megacd", "megacdjp", "megadrive", "megadrivejp", "naomi",
 "naomigd", "neogeocd", "neogeocdjp", "pcenginecd", "pcfx",
"ps2", "psx", "saturn", "saturnjp", "sega32x", "sega32xjp",
"sega32xna", "segacd", "tg-cd", "tg16")

$rvzfolderWhiteList = @("gc", "wii", "primehacks")
$csofolderWhiteList = @("psp")
$n3dsfolderWhiteList = @("n3ds")
$xboxfolderWhiteList = @("xbox")
$sevenzipfolderWhiteList = @("atari2600", "atarilynx", "famicom", "gamegear",
"gb", "gbc", "gba", "genesis", "mastersystem", "megacd",
"n64", "n64dd", "nes", "ngp", "ngpc", "saturn",
"sega32x", "segacd", "sfc", "snes", "snesna", "wonderswan",
"wonderswancolor")

# File extensions
$chdFileExtensions = @("gdi", "cue", "iso", "chd")
$rvzFileExtensions = @("gcm", "iso", "rvz")
$csoFileExtensions = @("iso", "cso")
$xboxFileExtensions = @("iso")
$n3dsFileExtensions = @("3ds")
$sevenzipFileExtensions = @("ngp", "ngc", "a26", "lnx", "ws", "pc2",
"wsc", "ngc", "n64", "ndd", "v64", "z64",
"gb", "dmg", "gba", "gbc", "nes", "fds",
"unf", "unif", "bs", "fig", "sfc", "smc",
"swx", "32x", "gg", "gen", "md", "smd")

# Combine file extensions arrays
$combinedFileExtensions = @(
    $n3dsFileExtensions +
    $chdFileExtensions +
    $rvzFileExtensions +
    $csoFileExtensions +
    $xboxFileExtensions +
    $sevenzipFileExtensions
)


# Obtener el timestamp en formato "YYYYMMDD_HHMMSS"
$TIMESTAMP = Get-Date -Format "yyyyMMdd_HHmmss"

# Crear el directorio si no existe
$logDirectory = "$HOME\emudeck\logs\compression"
New-Item -ItemType Directory -Path $logDirectory -Force

# Definir el nombre del archivo de log
$LOGFILE = "$logDirectory\chdman-$TIMESTAMP.log"

# Redireccionar la salida y errores a un archivo de log
Start-Transcript -Path $LOGFILE -Append

$chdman5 = "$env:APPDATA\EmuDeck\backend\tools\chdconv\chdman.exe";
$ciso = "$env:APPDATA\EmuDeck\backend\tools\chdconv\ciso.exe";
$3dstool = "$env:APPDATA\EmuDeck\backend\tools\chdconv\3dstool.exe";
$extractXiso = "$env:APPDATA\EmuDeck\backend\tools\chdconv\extract-xiso.exe";
$dolphintool = "$HOME\EmuDeck\EmulationStation-DE\Emulators\Dolphin-x64\DolphinTool.exe";


function Compress-CHD {
    param (
        [string]$file
    )

    # Obtener la extensión del archivo
    $fileType = [System.IO.Path]::GetExtension($file).TrimStart(".")
    $CUEDIR = [System.IO.Path]::GetDirectoryName($file)
    $successful = $false

    Write-Host "Compressing $($file -replace '\.[^.]+$', '.chd')"

    # Ejecutar el comando chdman y verificar si es exitoso
    $chdmanResult = & $chdman5 createcd -i $file -o ($file -replace '\.[^.]+$', '.chd')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "Converting $file to CHD using the createcd flag."
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.chd')"

        if ($fileType -ne 'iso' -and $fileType -ne 'ISO') {
            Get-ChildItem -Path $CUEDIR -File | ForEach-Object {
                $fileName = $_.Name
                $found = Select-String -Pattern $fileName -Path $file

                if ($found) {
                    Write-Host "Deleting $($_.FullName)"
                    Remove-Item -Path $_.FullName -Force
                }
            }
        }

        Remove-Item -Path $file -Force
    } else {
        Write-Host "Conversion of $file failed."
        Remove-Item -Path ($file -replace '\.[^.]+$', '.chd') -Force
    }
}


function Compress-CHDDVD {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $chdman5 createdvd -i $file -o ($file -replace '\.[^.]+$', '.chd') -c zstd

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "Converting $file to CHD using the createdvd flag and hunksize 16348."
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.chd')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Conversion of $file failed."
        Remove-Item -Path ($file -replace '\.[^.]+$', '.chd') -Force
    }
}

function Compress-CHDDVDLowerHunk {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $chdman5 createdvd --hunksize 2048 -i $file -o ($file -replace '\.[^.]+$', '.chd')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "Converting $file to CHD using the createdvd flag and hunksize 2048."
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.chd')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Conversion of $file failed."
        Remove-Item -Path ($file -replace '\.[^.]+$', '.chd') -Force
    }
}

function Compress-RVZ {
    param (
        [string]$file,
        [string]$dolphintool
    )

    $successful = $false
    $result = & $dolphintool convert -f rvz -b 131072 -c zstd -l 5 -i $file -o ($file -replace '\.[^.]+$', '.rvz')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.rvz')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Error converting $file"
        Remove-Item -Path ($file -replace '\.[^.]+$', '.rvz') -Force
    }
}

function Compress-CSO {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $ciso 9 $file ($file -replace '\.[^.]+$', '.cso')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.cso')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Error converting $file"
        Remove-Item -Path ($file -replace '\.[^.]+$', '.cso') -Force
    }
}

function Trim-3DS {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $3dstool -r -f $file

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "Successfully trimmed $($file -replace '\.[^.]+$', '.3ds')"
        Rename-Item -Path $file -NewName ($file -replace '\.[^.]+$', '(Trimmed).3ds')
    } else {
        Write-Host "Error trimming $file"
    }
}

function Compress-XISO {
    param (
        [string]$file
    )

    $successful = $false
    $xisoDir = [System.IO.Path]::GetDirectoryName($file)
    $result = & $extractXiso -r $file -d $xisoDir

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.xiso.iso')"
        Rename-Item -Path $file -NewName ($file -replace '\.[^.]+$', '.xiso.iso')
        Remove-Item -Path ($file -replace '\.[^.]+$', '.iso.old') -Force
    } else {
        Write-Host "Error converting $file"
    }
}

function Compress-7Z {
    param (
        [string]$file
    )

    $successful = $false
    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    $result = 7z a -mx=9 ($file -replace '\.[^.]+$', '.7z') $file

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "$file successfully compressed to $($file -replace '\.[^.]+$', '.7z')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Error compressing $file"
    }
}

function Decompress-CHDISO {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $chdman5 extractdvd -i $file -o ($file -replace '\.[^.]+$', '.iso')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "Decompressing $file to ISO using the extractdvd flag."
        Write-Host "$file successfully decompressed to $($file -replace '\.[^.]+$', '.iso')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Conversion of $file failed."
        Remove-Item -Path ($file -replace '\.[^.]+$', '.iso') -Force
    }
}

function Decompress-CHDCD {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $chdman5 extractcd -i $file -o ($file -replace '\.[^.]+$', '.cue')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "Decompressing $file to CUE/BIN using the extractcd flag."
        Write-Host "$file successfully decompressed to $($file -replace '\.[^.]+$', '.cue')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Conversion of $file failed."
        Remove-Item -Path ($file -replace '\.[^.]+$', '.cue') -Force -ErrorAction SilentlyContinue
        Remove-Item -Path ($file -replace '\.[^.]+$', '.bin') -Force -ErrorAction SilentlyContinue
    }
}

function Decompress-CSOISO {
    param (
        [string]$file
    )

    $successful = $false
    $result = & $ciso 0 $file ($file -replace '\.[^.]+$', '.iso')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "$file successfully converted to $($file -replace '\.[^.]+$', '.iso')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Error converting $file"
        Remove-Item -Path ($file -replace '\.[^.]+$', '.iso') -Force
    }
}

function Decompress-RVZ {
    param (
        [string]$file,
        [string]$dolphintool
    )

    $successful = $false
    $result = & $dolphintool convert -f iso -b 131072 -c zstd -l 5 -i $file -o ($file -replace '\.[^.]+$', '.iso')

    if ($LASTEXITCODE -eq 0) {
        $successful = $true
    }

    if ($successful) {
        Write-Host "$file successfully decompressed to $($file -replace '\.[^.]+$', '.iso')"
        Remove-Item -Path $file -Force
    } else {
        Write-Host "Error converting $file"
        Remove-Item -Path ($file -replace '\.[^.]+$', '.iso') -Force
    }
}


$optionsList = @("Bulk Compression", "Bulk Decompression", "Select a ROM")
$selection = showListDialog 'Welcome to the EmuDeck Compression Tool' 'Select a compression method from the list below.' $optionsList

switch ($selection) {
    "Bulk Compression" {
        $compressionSelection = "Bulk Compression"
    }
    "Bulk Decompression" {
        $compressionSelection = "Bulk Decompression"
    }
    "Select a ROM" {
        $compressionSelection = "Select a ROM"
    }
    Default {
        $compressionSelection = "Exit"
    }
}

echo $compressionSelection

if ($compressionSelection -eq "Bulk Compression") {

    Write-Host "Checking $romsPath for files eligible for conversion."

    # Encontrar archivos compatibles en carpetas permitidas
    foreach ($romfolder in $chdfolderWhiteList) {
        Write-Host "Checking $romsPath\$romfolder\"
        $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.gdi, *.cue, *.iso
        if ($files.Count -gt 0) {
            Write-Host "found in $romfolder"
            $searchFolderList += $romfolder
        }
    }

    # Verificar la existencia de herramientas antes de continuar
    if (Test-Path $dolphintool) {
        foreach ($romfolder in $rvzfolderWhiteList) {
            Write-Host "Checking $romsPath\$romfolder\"
            $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.gcm, *.iso
            if ($files.Count -gt 0) {
                Write-Host "found in $romfolder"
                $searchFolderList += $romfolder
            }
        }
    }

    foreach ($romfolder in $n3dsfolderWhiteList) {
        Write-Host "Checking $romsPath\$romfolder\"
        $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.3ds | Where-Object { $_.Name -notmatch '\(Trimmed\)' }
        if ($files.Count -gt 0) {
            Write-Host "found in $romfolder"
            $searchFolderList += $romfolder
        }
    }

    foreach ($romfolder in $csofolderWhiteList) {
        Write-Host "Checking $romsPath\$romfolder\"
        $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.iso
        if ($files.Count -gt 0) {
            Write-Host "found in $romfolder"
            $searchFolderList += $romfolder
        }
    }

    foreach ($romfolder in $xboxfolderWhiteList) {
        Write-Host "Checking $romsPath\$romfolder\"
        $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.iso | Where-Object { $_.Name -notmatch '\.xiso\.iso' }
        if ($files.Count -gt 0) {
            Write-Host "found in $romfolder"
            $searchFolderList += $romfolder
        }
    }

    if (Get-Command "7za" -ErrorAction SilentlyContinue) {
        Write-Host "7za found"
        foreach ($romfolder in $sevenzipfolderWhiteList) {
            Write-Host "Checking $romsPath\$romfolder\"
            foreach ($ext in $sevenzipFileExtensions) {
                $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.$ext
                if ($files.Count -gt 0) {
                    Write-Host "found in $romfolder"
                    $searchFolderList += $romfolder
                }
            }
        }
    }

    if ($searchFolderList.Count -eq 0) {

        confirmDialog -TitleText "EmuDeck" -MessageText "No suitable ROMs were found for conversion."
        exit
    }

    $height = $searchFolderList.Count * 100

    $folderstoconvert = showListDialog 'Welcome to the EmuDeck Compression Tool' 'Which folders do you want to convert?' $searchFolderList


    # CHD Conversion
    foreach ($romfolder in $folderstoconvert) {
        if ($chdfolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.gdi, *.cue | ForEach-Object {
                Write-Host "Converting: $_ using the createcd flag"
                Compress-CHD $_.FullName
            }
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.iso | ForEach-Object {
                Write-Host "Converting: $_ using the createdvd flag"
                Compress-CHDDVD $_.FullName
            }
        }
    }

    # RVZ Conversion
    foreach ($romfolder in $folderstoconvert) {
        if ($rvzfolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.gcm, *.iso | ForEach-Object {
                Write-Host "Converting: $_"
                Compress-RVZ $_.FullName $dolphintool
            }
        }
    }

    # CSO Conversion
    foreach ($romfolder in $folderstoconvert) {
        if ($csofolderWhiteList -contains $romfolder) {
            $pspBulkSelection = [System.Windows.Forms.MessageBox]::Show("Would you like to compress your PlayStation Portable ROM(s) to CSO or CHD?`n`nYes = CHD, No = CSO", "PSP Compression", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)

            if ($pspBulkSelection -eq [System.Windows.Forms.DialogResult]::Yes) {
                Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.iso | ForEach-Object {
                    Write-Host "Converting: $_ using the createdvd flag and 2048 hunksize"
                    Compress-CHDDVDLowerHunk $_.FullName
                }
            } elseif ($pspBulkSelection -eq [System.Windows.Forms.DialogResult]::No) {
                Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.iso | ForEach-Object {
                    Write-Host "Converting: $_"
                    Compress-CSO $_.FullName
                }
            } else {
                Write-Host "No valid ROM found"
                exit
            }
        }
    }

    # 3DS Trim
    foreach ($romfolder in $folderstoconvert) {
        if ($n3dsfolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.3ds | Where-Object { $_.Name -notmatch '\(Trimmed\)' } | ForEach-Object {
                Write-Host "Converting: $_"
                Trim-3DS $_.FullName
            }
        }
    }

    # XISO Conversion
    foreach ($romfolder in $folderstoconvert) {
        if ($xboxfolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.iso | Where-Object { $_.Name -notmatch '\.xiso\.iso' } | ForEach-Object {
                Write-Host "Converting: $_"
                Compress-XISO $_.FullName
            }
        }
    }

    # 7z Compression
    foreach ($romfolder in $folderstoconvert) {
        if ($sevenzipfolderWhiteList -contains $romfolder) {
            foreach ($ext in $sevenzipFileExtensions) {
                Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.$ext | ForEach-Object {
                    Write-Host "Converting: $_"
                    Compress-7Z $_.FullName
                }
            }
        }
    }


}elseif ($compressionSelection -eq "Bulk Decompression") {

    Write-Host "Checking $romsPath for files eligible for decompression."

    # CHD folders -> .chd
    foreach ($romfolder in $chdfolderWhiteList) {
        Write-Host "Checking $romsPath\$romfolder\"
        $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.chd
        if ($files.Count -gt 0) {
            Write-Host "found in $romfolder"
            $searchFolderList += $romfolder
        }
    }

    # CSO folders -> .cso / .chd (PSP puede comprimirse a CSO o CHD)
    foreach ($romfolder in $csofolderWhiteList) {
        Write-Host "Checking $romsPath\$romfolder\"
        $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.cso, *.chd
        if ($files.Count -gt 0) {
            Write-Host "found in $romfolder"
            $searchFolderList += $romfolder
        }
    }

    # RVZ folders -> .rvz
    if (Test-Path $dolphintool) {
        foreach ($romfolder in $rvzfolderWhiteList) {
            Write-Host "Checking $romsPath\$romfolder\"
            $files = Get-ChildItem "$romsPath\$romfolder\" -Recurse -File -Include *.rvz
            if ($files.Count -gt 0) {
                Write-Host "found in $romfolder"
                $searchFolderList += $romfolder
            }
        }
    }

    if ($searchFolderList.Count -eq 0) {
        confirmDialog -TitleText "EmuDeck" -MessageText "No suitable ROMs were found for decompression."
        exit
    }

    $folderstoconvert = showListDialog 'Welcome to the EmuDeck Compression Tool' 'Which folders do you want to decompress?' $searchFolderList

    foreach ($romfolder in $folderstoconvert) {
        if ($chdfolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.chd | ForEach-Object {
                if ($romfolder -eq 'ps2') {
                    Write-Host "Decompressing: $_ using the extractdvd flag"
                    Decompress-CHDISO $_.FullName
                } else {
                    Write-Host "Decompressing: $_ using the extractcd flag"
                    Decompress-CHDCD $_.FullName
                }
            }
        }
        if ($csofolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.cso | ForEach-Object {
                Write-Host "Decompressing: $_"
                Decompress-CSOISO $_.FullName
            }
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.chd | ForEach-Object {
                Write-Host "Decompressing: $_ using the extractdvd flag"
                Decompress-CHDISO $_.FullName
            }
        }
        if ($rvzfolderWhiteList -contains $romfolder) {
            Get-ChildItem "$romsPath\$romfolder" -Recurse -File -Include *.rvz | ForEach-Object {
                Write-Host "Decompressing: $_"
                Decompress-RVZ $_.FullName $dolphintool
            }
        }
    }

}elseif ($compressionSelection -eq "Select a ROM") {

    Add-Type -AssemblyName System.Windows.Forms

    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = "Select a ROM to compress or decompress"
    if (Test-Path $romsPath) { $dialog.InitialDirectory = $romsPath }
    $dialog.Filter = "ROMs|*.gdi;*.cue;*.iso;*.gcm;*.chd;*.cso;*.rvz;*.3ds;*.7z;*.zip|All files (*.*)|*.*"

    if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        Write-Host "No file selected."
        exit
    }

    $file = $dialog.FileName
    $ext = [System.IO.Path]::GetExtension($file).TrimStart(".").ToLower()

    # Averiguar la carpeta del sistema (primer segmento bajo $romsPath)
    $romfolder = ''
    if ($file.StartsWith($romsPath)) {
        $relative = $file.Substring($romsPath.Length).TrimStart('\')
        $romfolder = ($relative -split '\\')[0]
    }
    Write-Host "Selected: $file (system: $romfolder)"

    # Si el archivo ya está comprimido, confirmar antes de descomprimir
    if ($ext -in @("chd", "cso", "rvz")) {
        $confirm = [System.Windows.Forms.MessageBox]::Show(
            "The selected file is compressed and will be DECOMPRESSED:`n`n$file`n`nDo you want to continue?",
            "Confirm decompression",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Warning)

        if ($confirm -ne [System.Windows.Forms.DialogResult]::Yes) {
            Write-Host "Decompression cancelled by user."
            exit
        }
    }

    switch ($ext) {
        # --- Decompression ---
        "chd" {
            if ($romfolder -eq 'ps2' -or ($csofolderWhiteList -contains $romfolder)) {
                Write-Host "Decompressing using the extractdvd flag"
                Decompress-CHDISO $file
            } else {
                Write-Host "Decompressing using the extractcd flag"
                Decompress-CHDCD $file
            }
        }
        "cso" {
            Decompress-CSOISO $file
        }
        "rvz" {
            if (Test-Path $dolphintool) {
                Decompress-RVZ $file $dolphintool
            } else {
                Write-Host "DolphinTool not found, cannot decompress RVZ."
            }
        }

        # --- Compression ---
        { $_ -in @("gdi", "cue") } {
            Compress-CHD $file
        }
        "gcm" {
            if (Test-Path $dolphintool) {
                Compress-RVZ $file $dolphintool
            } else {
                Write-Host "DolphinTool not found, cannot convert to RVZ."
            }
        }
        "3ds" {
            Trim-3DS $file
        }
        "iso" {
            if ($rvzfolderWhiteList -contains $romfolder) {
                if (Test-Path $dolphintool) {
                    Compress-RVZ $file $dolphintool
                } else {
                    Write-Host "DolphinTool not found, cannot convert to RVZ."
                }
            } elseif ($xboxfolderWhiteList -contains $romfolder) {
                Compress-XISO $file
            } elseif ($csofolderWhiteList -contains $romfolder) {
                $pspSelection = [System.Windows.Forms.MessageBox]::Show("Would you like to compress your PlayStation Portable ROM to CSO or CHD?`n`nYes = CHD, No = CSO", "PSP Compression", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)
                if ($pspSelection -eq [System.Windows.Forms.DialogResult]::Yes) {
                    Compress-CHDDVDLowerHunk $file
                } elseif ($pspSelection -eq [System.Windows.Forms.DialogResult]::No) {
                    Compress-CSO $file
                } else {
                    Write-Host "Cancelled."
                    exit
                }
            } else {
                # CD/DVD systems del chdfolderWhiteList: ISO -> createdvd
                Compress-CHDDVD $file
            }
        }
        default {
            if ($sevenzipFileExtensions -contains $ext) {
                if (Get-Command "7za" -ErrorAction SilentlyContinue) {
                    Compress-7Z $file
                } else {
                    Write-Host "7za not found, cannot compress $file."
                }
            } else {
                Write-Host "Unsupported file type: .$ext"
            }
        }
    }
}

echo "All files converted!"
