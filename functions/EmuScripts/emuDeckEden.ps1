$Eden_configFile="${emusPath}\eden\user\config\qt-config.ini"

function Eden_install(){
	setMSG "Downloading Eden"
	winget install Microsoft.VCRedist.2015+.x64 --accept-package-agreements --accept-source-agreements
	$url_eden = getLatestReleaseURLGH "eden-emu/eden-mainline" "7z" "windows"
	#$url_eden = "https://github.com/eden-emu/eden-mainline/releases/download/mainline-0-1476/eden-windows-msvc-20230621-e3122c5b4.7z"
	download $url_eden "eden.7z"
	moveFromTo "$temp/eden/eden-windows-msvc" "$emusPath\eden"
	Remove-Item -Recurse -Force eden -ErrorAction SilentlyContinue
	createLauncher "eden"
}
function Eden_init(){

	setMSG "Eden - Configuration"
	mkdir "$emusPath\eden\user\nand\system\Contents\registered" -ErrorAction SilentlyContinue
	mkdir "$emusPath\eden\user\keys" -ErrorAction SilentlyContinue

	$destination="$emusPath\eden\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\eden\config" "$destination"

	#SDL fix
	Copy-Item "$env:APPDATA\EmuDeck\backend\configs\eden\SDL2.dll" -Destination "$emusPath\eden\" -ErrorAction SilentlyContinue -Force

	sedFile $destination\qt-config.ini "C:/Emulation" $emulationPath

	Eden_setupStorage
	Eden_setupSaves
	Eden_setResolution $edenResolution
	createLauncher "Eden"

	ESDE_refreshCustomEmus

}
function Eden_update(){
	Write-Output "NYI"
}
function Eden_setEmulationFolder(){
	Write-Output "NYI"
}
function Eden_setupSaves(){

	setMSG "Eden - Creating Keys & Firmware Links"
	#Firmware
	mkdir "$emusPath\eden\user\nand\system\Contents"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\eden\user\nand\system\Contents\registered"
	$emuSavePath = "$emulationPath\bios\eden\firmware"
	createSaveLink $simLinkPath $emuSavePath

	#DLCs
	mkdir "$emusPath\eden\user\nand\user\Contents"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\eden\user\nand\user\Contents\registered"
	$emuSavePath = "$storagePath\eden\storage"
	createSaveLink $simLinkPath $emuSavePath

	#Keys
	$simLinkPath = "$emusPath\eden\user\keys"
	$emuSavePath = "$emulationPath\bios\eden\keys"
	createSaveLink $simLinkPath $emuSavePath

	setMSG "Eden - Saves Links"
	mkdir "$emusPath\eden\user\nand\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\eden\user\nand\user\save"
	$emuSavePath = "$emulationPath\saves\eden\saves"
	createSaveLink $simLinkPath $emuSavePath

	mkdir $emusPath\eden\user\nand\system\save\8000000000000010\su\  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\eden\user\nand\system\save\8000000000000010\su\avators"
	$emuSavePath = "$emulationPath\saves\eden\profiles"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\eden"


}
function Eden_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2;  $docked="false"}
		"1080P" { $multiplier = 2; $docked="true"   }
		"1440P" { $multiplier = 3;  $docked="false" }
		"4K" { $multiplier = 3; $docked="true" }
	}

	setConfig "resolution_setup" $multiplier "$emusPath\eden\user\config\qt-config.ini"
	setConfig "use_docked_mode" $docked "$emusPath\eden\user\config\qt-config.ini"

}
function Eden_setupStorage(){
	mkdir "$emulationPath\storage\eden\screenshots" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\eden\dump" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\eden\load" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\eden\nand" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\eden\sdmc" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\eden\tas" -ErrorAction SilentlyContinue
}
function Eden_wipe(){
	Write-Output "NYI"
}
function Eden_uninstall(){
	Remove-Item -path "$emusPath\eden" -recurse -force
	if($?){
		Write-Output "true"
	}
}
function Eden_migrate(){
	Write-Output "NYI"
}
function Eden_setABXYstyle(){
	Write-Output "NYI"
}
function Eden_wideScreenOn(){
	Write-Output "NYI"
}
function Eden_wideScreenOff(){
	Write-Output "NYI"
}
function Eden_bezelOn(){
	Write-Output "NYI"
}
function Eden_bezelOff(){
	Write-Output "NYI"
}
function Eden_finalize(){
	Write-Output "NYI"
}
function Eden_IsInstalled(){
	$test=Test-Path -Path "$emusPath\eden-windows-msvc"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Eden_resetConfig(){
	Eden_init
	if($?){
		Write-Output "true"
	}
}


### Eden EA
function EdenEA_install($tokenValue) {
	$jwtHost = "https://api.eden-emu.org/jwt/installer/"
	$edenEaHost = "https://api.eden-emu.org/downloads/earlyaccess/"
	$user = $null
	$auth = $null

	$length = $tokenValue.Length
	$remainder = $length % 4
	if ($remainder -eq 1) {
		$tokenValue += "==="
	} elseif ($remainder -eq 2) {
		$tokenValue += "=="
	} elseif ($remainder -eq 3) {
		$tokenValue += "="
	}

	$decodedData = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$tokenValue"))
	$user, $auth = $decodedData.Split(':')

	if ($user -ne $null -and $auth -ne $null) {

		$edenEaMetadata = curl  "https://api.eden-emu.org/downloads/earlyaccess/" | ConvertFrom-Json

		$url_edenEA = ($edenEaMetadata.files | Where-Object { $_.name -match ".*\.7z" }).url

		$jwtHost = "https://api.eden-emu.org/jwt/installer/"

		$headers = @{
			"X-Username" = $user
			"X-Token" = $auth
			"User-Agent" = "EmuDeck"
		}

		$response = Invoke-WebRequest -Uri $jwtHost -Method Post -Headers $headers
		$BEARERTOKEN = $response.Content


		rm -r -fo "$temp/edenEA"-ErrorAction SilentlyContinue > $null
		download $url_edenEA "edenEA.7z" $BEARERTOKEN > $null
		xcopy "$temp\edenEA\eden-windows-msvc-early-access\" "$emusPath\eden\" /H /E /Y > $null
		rm -r -fo "$temp/edenEA" -ErrorAction SilentlyContinue > $null
		#createLauncher "eden"

		#SDL fix
		Copy-Item "$env:APPDATA\EmuDeck\backend\configs\eden\SDL2.dll" -Destination "$emusPath\eden\" -ErrorAction SilentlyContinue -Force

		Write-Host "true"

	} else {
		Write-Host "invalid"
	}

}

function EdenEA_addToken($tokenValue){
	EdenEA_install $tokenValue
}

function EdenEA_IsInstalled() {
	$test=Test-Path -Path "$emusPath\eden-windows-msvc"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}

function EdenEA_uninstall() {
	echo "Begin Eden EA uninstall"
	Write-Output "NYI"
}
