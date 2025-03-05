$MSG="$emudeckFolder/logs/msg.log"


function generateGameLists {
    Move-Item -Path "$storagePath/retrolibrary/assets/alekfull/carousel-icons" -Destination "$storagePath/retrolibrary/assets/default/carousel-icons" -Force
    generate_pythonEnv *> $null

    $accountfolder = Get-ChildItem "$HOME/.steam/steam/userdata" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $dest_folder = "$accountfolder/config/grid/retrolibrary/artwork/"

    "Starting to build database" | Out-File -FilePath "$MSG"
    New-Item -ItemType Directory -Path "$storagePath/retrolibrary/artwork" -Force
    New-Item -ItemType Directory -Path "$storagePath/retrolibrary/cache" -Force
    New-Item -ItemType Directory -Path "$accountfolder/config/grid/retrolibrary/" -Force

    Get-ChildItem "$storagePath/retrolibrary/artwork" -File | Where-Object { $_.Length -eq 0 } | Remove-Item -Force

    New-Item -ItemType SymbolicLink -Path "$accountfolder/config/grid/retrolibrary/artwork" -Target "$storagePath/retrolibrary/artwork" -Force
    New-Item -ItemType SymbolicLink -Path "$accountfolder/config/grid/retrolibrary/cache" -Target "$storagePath/retrolibrary/cache" -Force

    generateGameLists_downloadAchievements
    generateGameLists_downloadData
    generateGameLists_downloadAssets

    robocopy "$emudeckBackend/roms/" "$storagePath/retrolibrary/artwork" /E /XD roms txt
    pegasus_setPaths
    python "$emudeckBackend/tools/retro-library/generate_game_lists.py" "$romsPath"
    generateGameLists_artwork *> $null &
}

function generateGameListsJson {
    generate_pythonEnv *> $null
    "Adding Games" | Out-File -FilePath "$MSG"
    "Games Added" | Out-File -FilePath "$MSG"
    Get-Content "$storagePath/retrolibrary/cache/roms_games.json"
}

function generateGameLists_artwork {
    generate_pythonEnv *> $null
    "Searching for missing artwork" | Out-File -FilePath "$MSG"
    python "$emudeckBackend/tools/retro-library/missing_artwork_platforms.py" "$romsPath" "$storagePath/retrolibrary/artwork"
    python "$emudeckBackend/tools/retro-library/download_art_platforms.py" "$storagePath/retrolibrary/artwork"
    python "$emudeckBackend/tools/retro-library/missing_artwork_nohash.py" "$romsPath" "$storagePath/retrolibrary/artwork"
    python "$emudeckBackend/tools/retro-library/download_art_nohash.py" "$storagePath/retrolibrary/artwork" &
    "Artwork finished. Restart if you see this message" | Out-File -FilePath "$MSG"
}

function saveImage {
    param(
        [string]$url, [string]$name, [string]$system
    )

    $accountfolder = Get-ChildItem "$HOME/.steam/steam/userdata" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $dest_folder = "$storagePath/retrolibrary/artwork/$system/media/box2dfront/"
    $dest_path = "$dest_folder/$name.jpg"
    Invoke-WebRequest -Uri $url -OutFile $dest_path
}

function addGameListsArtwork {
    param(
        [string]$file, [string]$appID, [string]$platform
    )

    $accountfolder = Get-ChildItem "$HOME/.steam/steam/userdata" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $vertical = "$storagePath/retrolibrary/artwork/$platform/media/box2dfront/$file.jpg"
    $destination_vertical = "$accountfolder/config/grid/${appID}p.png"
    $destination_hero = "$accountfolder/config/grid/${appID}_hero.png"
    $destination_grid = "$accountfolder/config/grid/${appID}.png"

    Remove-Item -Path $destination_vertical -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $destination_hero -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $destination_grid -Force -ErrorAction SilentlyContinue

    New-Item -ItemType SymbolicLink -Path $destination_vertical -Target $vertical -Force
    New-Item -ItemType SymbolicLink -Path $destination_hero -Target $vertical -Force
    New-Item -ItemType SymbolicLink -Path $destination_grid -Target $vertical -Force
}

Set-Alias generateGameLists generateGameLists
Set-Alias generateGameListsJson generateGameListsJson
Set-Alias generateGameLists_artwork generateGameLists_artwork
Set-Alias saveImage saveImage
Set-Alias addGameListsArtwork addGameListsArtwork
