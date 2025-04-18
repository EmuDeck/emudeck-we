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
			Write-Output "true"
		} else {
			Write-Output "false"
		}
	} else {
		Write-Output "false"
	}
}

function Android_ADB_testWrite{
	adb shell ls /storage/emulated/0/
	if($?){
		setSetting "android_writable" "true"
		. "$env:APPDATA\emudeck\settings.ps1" -ErrorAction SilentlyContinue
	}else{
		setSetting "android_writable" "false"
		. "$env:APPDATA\emudeck\settings.ps1" -ErrorAction SilentlyContinue
	}
}


function Android_ADB_install {
	setMSG "Installing Android Tools..."
	$outFile = "adb.zip"
	$outDir = "$env:APPDATA\emudeck\android"

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
	echo "push"
	#if ( $android_writable -eq "true" ){
	#	$env:PATH += ";$Android_ADB_path"
	#	adb push $origin $destination
	#}
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
	Android_ADB_installAPK "$env:APPDATA\emudeck\android\$temp_emu.apk"
}

function Android_ADB_getSDCard {
	$volumes = adb shell sm list-volumes public | ForEach-Object { $_.Split()[-1] }

	if ($volumes -eq '{}' -or $volumes.Count -eq 0) {
		return "false"
	} else {
		return $volumes
	}
}

function Android_ADB_init {

	$jsonResult = @{
		isConnected = Android_ADB_connected
		SDCardName = Android_ADB_getSDCard
	} | ConvertTo-Json -Compress

	$jsonResult = $jsonResult.TrimEnd("`r", "`n")

	Write-Output $jsonResult
}








function Android_download {
	param (
		[string]$outFile,
		[string]$url
	)
	$outDir = "$env:APPDATA\emudeck\android"
	$wc = New-Object net.webclient
	$wc.Downloadfile($url, "$outDir\$outFile")
	Write-Output "true"

}
function Android_downloadCore($url, $core) {
	$wc = New-Object net.webclient
	$destination="$Android_RetroArch_temp/downloads/$core.zip"
	$wc.Downloadfile($url, $destination)

	foreach ($line in $destination) {
		$extn = [IO.Path]::GetExtension($line)
		if ($extn -eq ".zip" ){
			& $7z x -o"$Android_RetroArch_temp/downloads/" -aoa $destination
			Start-Sleep -Seconds 0.5
			Remove-Item $destination
		}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}