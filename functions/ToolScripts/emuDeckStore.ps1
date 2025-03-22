function Store_installGame {
    param(
        [string]$system, [string]$name, [string]$url
    )

    $name_cleaned = $name -replace '\(.*?\)', '' -replace '\[.*?\]', ''
    $name_cleaned = $name_cleaned -replace ' ', '_' -replace '-', '_'
    $name_cleaned = $name_cleaned -replace '_+', '_'
    $name_cleaned = $name_cleaned -replace '[+&!''.]', '' -replace '_decrypted', '' -replace 'decrypted', '' -replace '.ps3', ''
    $name_cleaned = $name_cleaned.ToLower()

    $zipPath = "$romsPath/$system/$name.zip"
    $screenshotPath = "$storagePath/retrolibrary/artwork/$system/media/screenshot/$name_cleaned.jpg"
    $boxartPath = "$storagePath/retrolibrary/artwork/$system/media/box2dfront/$name_cleaned.jpg"

    Invoke-WebRequest -Uri $url -OutFile $zipPath
    Invoke-WebRequest -Uri "https://f005.backblazeb2.com/file/emudeck-artwork/$system/media/screenshot/$name.png" -OutFile $screenshotPath
    Invoke-WebRequest -Uri "https://f005.backblazeb2.com/file/emudeck-artwork/$system/media/box2dfront/$name.png" -OutFile $boxartPath

    if (Test-Path $zipPath -and Test-Path $screenshotPath -and Test-Path $boxartPath) {
        Write-Output "true"
    } else {
        Write-Output "false"
    }
}

function Store_uninstallGame {
    param(
        [string]$system, [string]$name, [string]$url
    )

    $name_cleaned = $name -replace '\(.*?\)', '' -replace '\[.*?\]', ''
    $name_cleaned = $name_cleaned -replace ' ', '_' -replace '-', '_'
    $name_cleaned = $name_cleaned -replace '_+', '_'
    $name_cleaned = $name_cleaned -replace '[+&!''.]', '' -replace '_decrypted', '' -replace 'decrypted', '' -replace '.ps3', ''
    $name_cleaned = $name_cleaned.ToLower()

    $zipPath = "$romsPath/$system/$name.zip"
    $screenshotPath = "$storagePath/retrolibrary/artwork/$system/media/screenshot/$name_cleaned.jpg"
    $boxartPath = "$storagePath/retrolibrary/artwork/$system/media/box2dfront/$name_cleaned.jpg"

    Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $screenshotPath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $boxartPath -Force -ErrorAction SilentlyContinue

    if (-Not (Test-Path $zipPath) -and -Not (Test-Path $screenshotPath) -and -Not (Test-Path $boxartPath)) {
        Write-Output "true"
    } else {
        Write-Output "false"
    }
}

function Store_isGameInstalled {
    param(
        [string]$system, [string]$name, [string]$url
    )

    $zipPath = "$romsPath/$system/$name.zip"

    if (Test-Path $zipPath) {
        Write-Output "true"
    } else {
        Write-Output "false"
    }
}
