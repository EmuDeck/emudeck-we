$MSG="$emudeckFolder/logs/msg.log"

function generate_pythonEnv() {
  if ((Get-Command python).Source -match "Program Files") {
    Write-Output "Python already installed."
  } else {
    Write-Host "Installing Python, please wait..."
    $PYinstaller = "python-3.11.0-amd64.exe"
    $url = "https://www.python.org/ftp/python/3.11.0/$PYinstaller"
    download $url $PYinstaller
    Start-Process "$temp\$PYinstaller" -Wait -Args "/passive InstallAllUsers=1 PrependPath=1 Include_test=0"
  }

  check_for_pip 'requests'
  check_for_pip 'vdf'
}

function generateGameLists {
    # Invoca la función generate_pythonEnv y redirige la salida a null
    generate_pythonEnv | Out-Null

    # Obtiene la carpeta de usuario de Steam más reciente
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $destFolder = "$accountFolder/config/grid/retrolibrary/artwork"
    Write-Output "Starting to build database" | Set-Content -Path $MSG

    # Crea los directorios necesarios
    New-Item -ItemType Directory -Force -Path "$storagePath/retrolibrary/artwork"
    New-Item -ItemType Directory -Force -Path "$storagePath/retrolibrary/cache"
    New-Item -ItemType Directory -Force -Path "$accountFolder/config/grid/retrolibrary"

    # Elimina archivos vacíos en el directorio de artwork
    Get-ChildItem "$storagePath/retrolibrary/artwork" -File | Where-Object { $_.Length -eq 0 } | Remove-Item -Force

    # Crea junctions
    mkdir "$accountFolder/config/grid/retrolibrary" -ErrorAction SilentlyContinue
    $simLinkPath = "$accountFolder\config\grid\retrolibrary\artwork"
    $emuSavePath = "$storagePath\retrolibrary\artwork"
    createSaveLink $simLinkPath $emuSavePath

    $simLinkPath = "$accountFolder\config\grid\retrolibrary\cache"
    $emuSavePath = "$storagePath\retrolibrary\cache"
    createSaveLink $simLinkPath $emuSavePath

    # Llama a las funciones de descarga
    generateGameLists_downloadAchievements
    generateGameLists_downloadData
    generateGameLists_downloadAssets

    # Sincroniza archivos usando RoboCopy
    robocopy "$emudeckBackend/roms/" "$storagePath/retrolibrary/artwork" /MIR /XD roms txt /SL

    # Configura las rutas de Pegasus
    pegasus_setPaths

    Write-Output "Database built" | Set-Content -Path $MSG

    # Ejecuta el script de Python
    python "$emudeckBackend/tools/retro-library/generate_game_lists.py" "$romsPath"

    # Llama a la función para manejar artwork en segundo plano
    #Start-Job { generateGameLists_artwork } | Out-Null
}

function generateGameListsJson {
    # Invoca la función generate_pythonEnv y redirige la salida a null
    generate_pythonEnv | Out-Null

    # Escribe mensajes en el archivo de mensaje
    Write-Output "Adding Games" | Set-Content -Path $MSG
    Write-Output "Games Added" | Set-Content -Path $MSG

    # Muestra el contenido del archivo JSON
    Get-Content "$storagePath/retrolibrary/cache/roms_games.json"
}

function generateGameLists_artwork {
    # Invoca la función generate_pythonEnv y redirige la salida a null
    generate_pythonEnv | Out-Null

    # Escribe mensaje inicial en el archivo de mensaje
    Write-Output "Searching for missing artwork" | Set-Content -Path $MSG

    # Ejecuta los scripts de Python para buscar y descargar artwork
    python "$emudeckBackend/tools/retro-library/missing_artwork_platforms.py" "$romsPath" "$storagePath/retrolibrary/artwork" | Out-Null
    python "$emudeckBackend/tools/retro-library/download_art_platforms.py" "$storagePath/retrolibrary/artwork" | Out-Null

    # Ejecuta los scripts de Python adicionales en segundo plano
    Start-Job {
        python "$emudeckBackend/tools/retro-library/missing_artwork_nohash.py" "$romsPath" "$storagePath/retrolibrary/artwork" | Out-Null
        python "$emudeckBackend/tools/retro-library/download_art_nohash.py" "$storagePath/retrolibrary/artwork" | Out-Null
    } | Out-Null

    # Escribe mensaje final en el archivo de mensaje
    Write-Output "Artwork finished. Restart if you see this message" | Set-Content -Path $MSG
}

function saveImage($url, $name, $system){

    # Obtiene la carpeta de usuario de Steam más reciente
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$accountFolder = $accountFolder.FullName

    # Define las rutas de destino
    $destFolder = "$storagePath/retrolibrary/artwork/$system/media/box2dfront/"
    $destPath = "$destFolder/$name.jpg"

    # Crea el directorio si no existe
    if (-not (Test-Path -Path $destFolder)) {
        New-Item -ItemType Directory -Force -Path $destFolder | Out-Null
    }

    # Descarga la imagen desde la URL
    Invoke-WebRequest -Uri $url -OutFile $destPath -UseBasicParsing -Quiet
}

function addGameListsArtwork($file, $appID, $platform){

    # Obtiene la carpeta de usuario de Steam más reciente
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $accountFolder = $accountFolder.FullName
    # Define las rutas de origen y destino
    $vertical = "$storagePath/retrolibrary/artwork/$platform/media/box2dfront/$file.jpg"
    $grid = $vertical
    $destinationVertical = "$accountFolder/config/grid/${appID}p.png"
    $destinationHero = "$accountFolder/config/grid/${appID}_hero.png"
    $destinationGrid = "$accountFolder/config/grid/${appID}.png"

    # Elimina los archivos existentes en los destinos
    Remove-Item -Path $destinationVertical -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $destinationHero -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $destinationGrid -Force -ErrorAction SilentlyContinue

    # Crea enlaces simbólicos (junctions)
    createSaveLink $destinationVertical $vertical
    createSaveLink $destinationHero $grid
    createSaveLink $destinationGrid $grid

}

function generateGameLists_getPercentage {
    # Invoca la función generate_pythonEnv y redirige la salida a null
    generate_pythonEnv | Out-Null

    # Obtiene la carpeta de usuario de Steam más reciente
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $accountFolder = $accountFolder.FullName
    # Define las rutas necesarias
    $destFolder = "$storagePath/retrolibrary/artwork/"
    $jsonFile = "$storagePath/retrolibrary/cache/roms_games.json"
    $jsonFileArtwork = "$storagePath/retrolibrary/cache/missing_artwork_no_hash.json"

    # Ejecuta el script de Python para generar datos de artworks faltantes
    python "$emudeckBackend/tools/retro-library/missing_artwork_nohash.py" "$romsPath" "$destFolder" | Out-Null

    # Cargar y procesar los datos de JSON
    if (-Not (Test-Path $jsonFile) -or -Not (Test-Path $jsonFileArtwork)) {
        Write-Output "Required JSON files are missing."
        return
    }

    # Leer el contenido de los archivos JSON
    $games = (Get-Content $jsonFile | ConvertFrom-Json | ForEach-Object { $_.games } | Measure-Object).Count
    $artworkMissing = (Get-Content $jsonFileArtwork | ConvertFrom-Json | ForEach-Object { $_.games } | Measure-Object).Count

    if ($games -eq 0 -or -Not $games) {
        Write-Output "No games found in the JSON file."
        return
    }

    # Calcular juegos procesados y el porcentaje
    $parsedGames = $games - $artworkMissing
    $percentage = [math]::Floor((100 * $parsedGames) / $games)

    # Mostrar el resultado
    Write-Output "$parsedGames / $games ($percentage%)"
}




function generateGameLists_retroAchievements($hash, $system) {

    # Define la ruta local para los datos
    $localDataPath = "$storagePath/retrolibrary/achievements/$system.json"

    # Ejecuta el script de Python para gestionar retroachievements
    python "$emudeckBackend/tools/retro-library/retro_achievements.py" "$cheevos_username" "$hash" "$localDataPath"
}

function generateGameLists_downloadAchievements {
    # Define la carpeta de logros
    $folder = "$storagePath/retrolibrary/achievements"
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $accountFolder = $accountFolder.FullName
    $destFolder = "$accountFolder/config/grid/retrolibrary/achievements"

    # Comprueba si la carpeta existe, si no, la crea y descarga los datos
    if (-not (Test-Path -Path $folder)) {
        Write-Output "Downloading Retroachievements Data" | Set-Content -Path $MSG
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
        createSaveLink $destFolder $folder
        download "https://bot.emudeck.com/achievements/achievements.zip" "achievements.zip"
        moveFromTo "$temp/achievements" "$storagePath\retrolibrary\achievements"
        Write-Output "Retroachievements Data Downloaded" | Set-Content -Path $MSG
    }
}

function generateGameLists_downloadData {
    # Define la carpeta de datos
    $folder = "$storagePath/retrolibrary/data"
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $accountFolder = $accountFolder.FullName
    $destFolder = "$accountFolder/config/grid/retrolibrary/data"

    # Crea la carpeta y descarga los datos si no existe
    if (-not (Test-Path -Path $folder)) {
        Write-Output "Downloading Metadata" | Set-Content -Path $MSG
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
        createSaveLink $destFolder $folder
        download "https://bot.emudeck.com/data/data.zip" "data.zip"
        moveFromTo "$temp/data" "$storagePath\retrolibrary\data"
        Write-Output "Metadata Downloaded" | Set-Content -Path $MSG
    }
}

function generateGameLists_downloadAssets {
    # Define la carpeta de assets
    $folder = "$storagePath/retrolibrary/assets"
    $accountFolder = Get-ChildItem "$steamInstallPath/userdata" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $accountFolder = $accountFolder.FullName
    $destFolder = "$accountFolder/config/grid/retrolibrary/assets"

    # Crea la carpeta y descarga los assets si no existe
    if (-not (Test-Path -Path $folder)) {
        Write-Output "Downloading Assets" | Set-Content -Path $MSG
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
        createSaveLink $destFolder $folder
        download "https://bot.emudeck.com/assets/alekfull/alekfull.zip" "alekfull.zip"
        moveFromTo "$temp/alekfull" "$storagePath\retrolibrary\assets"
        Write-Output "Assets Downloaded" | Set-Content -Path $MSG
    }
}