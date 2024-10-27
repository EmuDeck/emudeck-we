function generateGameLists() {
    pegasus_setPaths
    mkdir "$HOME/emudeck/cache/" -ErrorAction SilentlyContinue
    python "$env:APPDATA\EmuDeck/backend/tools/retroLibrary/generate_game_lists.py" "$romsPath"
}

function generateGameListsJson {

    python "$env:APPDATA\EmuDeck\backend\tools\retroLibrary\generate_game_lists.py" "$romsPath"

    Get-Content "$HOME\emudeck\cache\roms_games.json"

    # Comprueba si .romlibrary_first existe y ejecuta la lógica de generación de arte
    # if (Test-Path "$HOME\emudeck\cache\.romlibrary_first") {
    #      generateGameLists_artwork 0
    # }else {
    #     for ($i = 1; $i -le 5; $i++) {
    #         generateGameLists_artwork $i
    #         #Start-Sleep -Seconds 1
    #     }
    #     # Crea el archivo .romlibrary_first
    #     New-Item -ItemType File -Path "$HOME\emudeck\cache\.romlibrary_first" | Out-Null
    # }
}


function generateGameLists_artwork {
    param (
        [int]$number_log
    )

    # Define las rutas necesarias
    $cacheFolder = "$HOME\emudeck\cache\"
    $logFolder = "$HOME\emudeck\logs\"
    $jsonFile = "$cacheFolder\roms_games.json"
    $logFileName = "$logFolder\library_$number_log.log"

    $steamRegPath = "HKCU:\Software\Valve\Steam"
    $steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
    $steamInstallPath = $steamInstallPath.Replace("/", "\\")
    $steamPath = "$steamInstallPath\userdata"

    $accountFolder = (Get-ChildItem -Directory $steamPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    $destFolder = "$accountFolder\config\grid\emudeck\"
    $processedGames = @{}

    # Crea los directorios necesarios
    New-Item -ItemType Directory -Force -Path $cacheFolder | Out-Null
    New-Item -ItemType Directory -Force -Path $destFolder | Out-Null
    "" | Out-File -Encoding utf8 $logFileName

    # Lee el contenido del archivo JSON
    $jsonContent = Get-Content $jsonFile | Out-String | ConvertFrom-Json

    # Determina las plataformas
    if ($number_log -eq 1) {
        $platforms = $jsonContent | ForEach-Object { $_.id }
    } else {
        $platforms = ($jsonContent | ForEach-Object { $_.id }) | Get-Random -Count ($jsonContent.Count)
    }

    foreach ($platform in $platforms) {
        "`nProcessing platform: $platform" | Out-File -Append -Encoding utf8 $logFileName

        if ($number_log -eq 1) {
            $games = $jsonContent | Where-Object { $_.id -eq $platform } | ForEach-Object { $_.games.name }
        } else {
            $games = ($jsonContent | Where-Object { $_.id -eq $platform } | ForEach-Object { $_.games.name })
        }

        $downloadArray = @()
        $downloadDestPaths = @()

        foreach ($game in $games) {
            $fileToCheck = "$destFolder$($game -replace ' ', '_').jpg"
            if (!(Test-Path $fileToCheck) -and -not $processedGames.ContainsKey($game)) {
                "`nGAME: $game" | Out-File -Append -Encoding utf8 $logFileName

                # Procesamiento fuzzy
                $fuzzygame = python "$env:APPDATA\EmuDeck\backend\tools\retroLibrary\fuzzy_search_rom.py" $game | Out-String
                #$fuzzygame = $fuzzygame -replace '[\s:./&!]', ''
                "`nFUZZY: $fuzzygame" | Out-File -Append -Encoding utf8 $logFileName

                # Realiza la consulta de imagen
                Invoke-WebRequest -Uri "https://bot.emudeck.com/steamdbimg.php?name=$fuzzygame" -OutFile "$cacheFolder\response.json"
                $response = Get-Content "$cacheFolder\response.json" | ConvertFrom-Json
                $gameImgUrl = $response.img
                $destPath = "$destFolder$game.jpg"

                if (!(Test-Path $destPath) -and $gameImgUrl -ne "null") {
                    "`nAdded to the list: $gameImgUrl" | Out-File -Append -Encoding utf8 $logFileName
                    $downloadArray += $gameImgUrl
                    $downloadDestPaths += $destPath
                    $processedGames[$game] = $true
                } else {
                    Invoke-WebRequest -Uri "https://bot.emudeck.com/steamdbimg.php?name=$game" -OutFile "$cacheFolder\response.json"
                    $response = Get-Content "$cacheFolder\response.json" | ConvertFrom-Json
                    $gameImgUrl = $response.img
                    $destPath = "$destFolder$game.jpg"

                    if ($gameImgUrl -ne "null") {
                        "`nAdded to the list (NO FUZZY): $gameImgUrl" | Out-File -Append -Encoding utf8 $logFileName
                        $downloadArray += $gameImgUrl
                        $downloadDestPaths += $destPath
                        $processedGames[$game] = $true
                    } else {
                        "`n - No picture" | Out-File -Append -Encoding utf8 $logFileName
                    }
                }
            }

            # Descargar en lotes de 10
            if ($downloadArray.Count -ge 10) {
                "`nStart batch" | Out-File -Append -Encoding utf8 $logFileName
                for ($i = 0; $i -lt $downloadArray.Count; $i++) {
                    Start-Job -ScriptBlock {
                        param ($url, $destPath)
                        Invoke-WebRequest -Uri $url -OutFile $destPath
                    } -ArgumentList $downloadArray[$i], $downloadDestPaths[$i]
                }
                Get-Job | Wait-Job | Remove-Job
                "`nCompleted batch" | Out-File -Append -Encoding utf8 $logFileName
                $downloadArray = @()
                $downloadDestPaths = @()
            }
        }

        # Descargar imágenes restantes
        if ($downloadArray.Count -ne 0) {
            for ($i = 0; $i -lt $downloadArray.Count; $i++) {
                Start-Job -ScriptBlock {
                    param ($url, $destPath)
                    Invoke-WebRequest -Uri $url -OutFile $destPath
                } -ArgumentList $downloadArray[$i], $downloadDestPaths[$i]
            }
            Get-Job | Wait-Job | Remove-Job
        }

        "`nCompleted search for platform: $platform" | Out-File -Append -Encoding utf8 $logFileName
    }
}


function saveImage {
    param (
        [string]$url,
        [string]$name
    )

    # Define la carpeta de destino
    $accountFolder = (Get-ChildItem -Directory "$HOME\.steam\steam\userdata" | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    $destFolder = "$accountFolder\config\grid\emudeck"
    $destPath = "$destFolder\$name.jpg"

    # Crea el directorio de destino si no existe
    New-Item -ItemType Directory -Force -Path $destFolder | Out-Null

    # Descarga la imagen desde la URL proporcionada
    download $url $destPath
}
