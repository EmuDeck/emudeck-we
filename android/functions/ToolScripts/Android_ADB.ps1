$Android_ADB_path = "$env:USERPROFILE\emudeck\android\platform-tools"
$Android_ADB_url = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$env:PATH += ";$Android_ADB_path"

function Android_ADB_isInstalled {
	if (Test-Path -Path $Android_ADB_path -PathType Container) {
		Write-Output "true"
		return 0
	} else {
		Write-Output "false"
		return 1
	}
}

function Android_ADB_connected {
	$adbOutput = adb devices
	if ($adbOutput -like '*List of devices attached*') {
		$devices = $adbOutput -split "`n" | Select-String "device"

		if ($devices.Count -gt 1) {
			Write-Host "true"
		} else {
			Write-Host "false"
		}
	} else {
		Write-Host "false"
	}
}

function Android_download {
	param (
		[string]$outFile,
		[string]$url
	)

	$outDir = "$env:USERPROFILE\emudeck\android"
	$tempFile = "$outDir\$outFile.temp"

	New-Item -ItemType Directory -Force -Path $outDir | Out-Null

	$webRequest = Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing -ErrorAction SilentlyContinue
	Move-Item -Path $tempFile -Destination "$outDir\$outFile"
	Write-Output "true"

}

function Android_ADB_install {
	$outFile = "adb.zip"
	$outDir = "$env:USERPROFILE\emudeck\android"

	Android_download $outFile $Android_ADB_url

	if ($?) {
		Expand-Archive -Path "$outDir\$outFile" -DestinationPath $outDir -Force
		Remove-Item -Path "$outDir\$outFile" -Force
		Write-Output "true"
		return 0
	}
}

function Android_ADB_push {
	param (
		[string]$origin,
		[string]$destination
	)

	$env:PATH += ";$Android_ADB_path"
	adb push $origin $destination
}

function Android_ADB_installAPK {
	param (
		[string]$apk
	)

	$env:PATH += ";$Android_ADB_path"
	adb install $apk
	Remove-Item -Path $apk -Force
}

function Android_ADB_dl_installAPK {
	param (
		[string]$temp_emu,
		[string]$temp_url
	)

	Android_download "$temp_emu.apk" $temp_url
	Android_ADB_installAPK "$env:USERPROFILE\emudeck\android\$temp_emu.apk"
}

function Android_ADB_getSDCard {
	adb shell sm list-volumes public | ForEach-Object { $_.Split()[-1] }
}

function Android_ADB_init {

	$jsonResultado = @{
		isConnected = Android_ADB_connected
		SDCardName = Android_ADB_getSDCard
	} | ConvertTo-Json

	Write-Output $jsonResultado
}