$Citron_configFile="${emusPath}\citron\user\config\qt-config.ini"

function Citron_install(){
	setMSG "Downloading Citron"
	winget install Microsoft.VCRedist.2015+.x64 --accept-package-agreements --accept-source-agreements
	$url_citron = getLatestReleaseURLGH "citron-emu/citron-mainline" "7z" "windows"
	#$url_citron = "https://github.com/citron-emu/citron-mainline/releases/download/mainline-0-1476/citron-windows-msvc-20230621-e3122c5b4.7z"
	download $url_citron "citron.7z"
	moveFromTo "$temp/citron/citron-windows-msvc" "$emusPath\citron"
	Remove-Item -Recurse -Force citron -ErrorAction SilentlyContinue
	createLauncher "citron"
}
function Citron_init(){

	setMSG "Citron - Configuration"
	mkdir "$emusPath\citron\user\nand\system\Contents\registered" -ErrorAction SilentlyContinue
	mkdir "$emusPath\citron\user\keys" -ErrorAction SilentlyContinue

	$destination="$emusPath\citron\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\citron\config" "$destination"

	#SDL fix
	Copy-Item "$env:APPDATA\EmuDeck\backend\configs\citron\SDL2.dll" -Destination "$emusPath\citron\" -ErrorAction SilentlyContinue -Force

	sedFile $destination\qt-config.ini "C:/Emulation" $emulationPath

	Citron_setupStorage
#	Citron_setupSaves
	Citron_setResolution $citronResolution
	createLauncher "Citron"

}
function Citron_update(){
	Write-Output "NYI"
}
function Citron_setEmulationFolder(){
	Write-Output "NYI"
}
function Citron_setupSaves(){

	setMSG "Citron - Creating Keys & Firmware Links"
	#Firmware
	mkdir "$emusPath\citron\user\nand\system\Contents"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\citron\user\nand\system\Contents\registered"
	$emuSavePath = "$emulationPath\bios\citron\firmware"
	createSaveLink $simLinkPath $emuSavePath

	#DLCs
	mkdir "$emusPath\citron\user\nand\user\Contents"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\citron\user\nand\user\Contents\registered"
	$emuSavePath = "$storagePath\citron\storage"
	createSaveLink $simLinkPath $emuSavePath

	#Keys
	$simLinkPath = "$emusPath\citron\user\keys"
	$emuSavePath = "$emulationPath\bios\citron\keys"
	createSaveLink $simLinkPath $emuSavePath

	setMSG "Citron - Saves Links"
	mkdir "$emusPath\citron\user\nand\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\citron\user\nand\user\save"
	$emuSavePath = "$emulationPath\saves\citron\saves"
	createSaveLink $simLinkPath $emuSavePath

	mkdir $emusPath\citron\user\nand\system\save\8000000000000010\su\  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\citron\user\nand\system\save\8000000000000010\su\avators"
	$emuSavePath = "$emulationPath\saves\citron\profiles"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\citron"


}
function Citron_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2;  $docked="false"}
		"1080P" { $multiplier = 2; $docked="true"   }
		"1440P" { $multiplier = 3;  $docked="false" }
		"4K" { $multiplier = 3; $docked="true" }
	}

	setConfig "resolution_setup" $multiplier "$emusPath\citron\user\config\qt-config.ini"
	setConfig "use_docked_mode" $docked "$emusPath\citron\user\config\qt-config.ini"

}
function Citron_setupStorage(){
	mkdir "$emulationPath\storage\citron\screenshots" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\citron\dump" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\citron\load" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\citron\nand" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\citron\sdmc" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\citron\tas" -ErrorAction SilentlyContinue
}
function Citron_wipe(){
	Write-Output "NYI"
}
function Citron_uninstall(){
	Remove-Item -path "$emusPath\citron"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Citron_migrate(){
	Write-Output "NYI"
}
function Citron_setABXYstyle(){
	Write-Output "NYI"
}
function Citron_wideScreenOn(){
	Write-Output "NYI"
}
function Citron_wideScreenOff(){
	Write-Output "NYI"
}
function Citron_bezelOn(){
	Write-Output "NYI"
}
function Citron_bezelOff(){
	Write-Output "NYI"
}
function Citron_finalize(){
	Write-Output "NYI"
}
function Citron_IsInstalled(){
	$test=Test-Path -Path "$emusPath\citron"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Citron_resetConfig(){
	Citron_init
	if($?){
		Write-Output "true"
	}
}


### Citron EA
function CitronEA_install($tokenValue) {
	$jwtHost = "https://api.citron-emu.org/jwt/installer/"
	$citronEaHost = "https://api.citron-emu.org/downloads/earlyaccess/"
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

		$citronEaMetadata = curl  "https://api.citron-emu.org/downloads/earlyaccess/" | ConvertFrom-Json

		$url_citronEA = ($citronEaMetadata.files | Where-Object { $_.name -match ".*\.7z" }).url

		$jwtHost = "https://api.citron-emu.org/jwt/installer/"

		$headers = @{
			"X-Username" = $user
			"X-Token" = $auth
			"User-Agent" = "EmuDeck"
		}

		$response = Invoke-WebRequest -Uri $jwtHost -Method Post -Headers $headers
		$BEARERTOKEN = $response.Content


		rm -r -fo "$temp/citronEA"-ErrorAction SilentlyContinue > $null
		download $url_citronEA "citronEA.7z" $BEARERTOKEN > $null
		xcopy "$temp\citronEA\citron-windows-msvc-early-access\" "$emusPath\citron\" /H /E /Y > $null
		rm -r -fo "$temp/citronEA" -ErrorAction SilentlyContinue > $null
		#createLauncher "citron"

		#SDL fix
		Copy-Item "$env:APPDATA\EmuDeck\backend\configs\citron\SDL2.dll" -Destination "$emusPath\citron\" -ErrorAction SilentlyContinue -Force

		Write-Host "true"

	} else {
		Write-Host "invalid"
	}

}

function CitronEA_addToken($tokenValue){
	CitronEA_install $tokenValue
}

function CitronEA_IsInstalled() {
	$test=Test-Path -Path "$emusPath\citron"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}

function CitronEA_uninstall() {
	echo "Begin Citron EA uninstall"
	Write-Output "NYI"
}
