$Yuzu_configFile="${emusPath}\yuzu\yuzu-windows-msvc\user\config\qt-config.ini"

function Yuzu_install(){
	setMSG "Downloading Yuzu"
	winget install Microsoft.VCRedist.2015+.x64 --accept-package-agreements --accept-source-agreements
	$url_yuzu = getLatestReleaseURLGH "yuzu-emu/yuzu-mainline" "7z" "windows"
	#$url_yuzu = "https://github.com/yuzu-emu/yuzu-mainline/releases/download/mainline-0-1476/yuzu-windows-msvc-20230621-e3122c5b4.7z"
	download $url_yuzu "yuzu.7z"
	moveFromTo "$temp/yuzu/yuzu-windows-msvc" "$emusPath\yuzu\yuzu-windows-msvc"
	Remove-Item -Recurse -Force yuzu -ErrorAction SilentlyContinue
	createLauncher "yuzu"
}
function Yuzu_init(){

	setMSG "Yuzu - Configuration"
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered" -ErrorAction SilentlyContinue
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\keys" -ErrorAction SilentlyContinue

	$destination="$emusPath\yuzu\yuzu-windows-msvc\user\config"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\yuzu\config" "$destination"

	#SDL fix
	Copy-Item "$env:APPDATA\EmuDeck\backend\configs\yuzu\SDL2.dll" -Destination "$emusPath\yuzu\yuzu-windows-msvc\" -ErrorAction SilentlyContinue -Force

	sedFile $destination\qt-config.ini "C:\Emulation" $emulationPath

	Yuzu_setupStorage
#	Yuzu_setupSaves
	Yuzu_setResolution $yuzuResolution


}
function Yuzu_update(){
	Write-Output "NYI"
}
function Yuzu_setEmulationFolder(){
	Write-Output "NYI"
}
function Yuzu_setupSaves(){

	setMSG "Yuzu - Creating Keys & Firmware Links"
	#Firmware
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\Contents"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\Contents\registered"
	$emuSavePath = "$emulationPath\bios\yuzu\firmware"
	createSaveLink $simLinkPath $emuSavePath

	#DLCs
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\nand\user\Contents"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\user\Contents\registered"
	$emuSavePath = "$storagePath\yuzu\storage"
	createSaveLink $simLinkPath $emuSavePath

	#Keys
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\keys"
	$emuSavePath = "$emulationPath\bios\yuzu\keys"
	createSaveLink $simLinkPath $emuSavePath

	setMSG "Yuzu - Saves Links"
	mkdir "$emusPath\yuzu\yuzu-windows-msvc\user\nand\user"  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\user\save"
	$emuSavePath = "$emulationPath\saves\yuzu\saves"
	createSaveLink $simLinkPath $emuSavePath

	mkdir $emusPath\yuzu\yuzu-windows-msvc\user\nand\system\save\8000000000000010\su\  -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\yuzu\yuzu-windows-msvc\user\nand\system\save\8000000000000010\su\avators"
	$emuSavePath = "$emulationPath\saves\yuzu\profiles"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\yuzu"


}
function Yuzu_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2;  $docked="false"}
		"1080P" { $multiplier = 2; $docked="true"   }
		"1440P" { $multiplier = 3;  $docked="false" }
		"4K" { $multiplier = 3; $docked="true" }
	}

	setConfig "resolution_setup" $multiplier "$emusPath\yuzu\yuzu-windows-msvc\user\config\qt-config.ini"
	setConfig "use_docked_mode" $docked "$emusPath\yuzu\yuzu-windows-msvc\user\config\qt-config.ini"

}
function Yuzu_setupStorage(){
	mkdir "$emulationPath\storage\yuzu\screenshots" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\yuzu\dump" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\yuzu\load" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\yuzu\nand" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\yuzu\sdmc" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\storage\yuzu\tas" -ErrorAction SilentlyContinue
}
function Yuzu_wipe(){
	Write-Output "NYI"
}
function Yuzu_uninstall(){
	Remove-Item -path "$emusPath\yuzu"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Yuzu_migrate(){
	Write-Output "NYI"
}
function Yuzu_setABXYstyle(){
	Write-Output "NYI"
}
function Yuzu_wideScreenOn(){
	Write-Output "NYI"
}
function Yuzu_wideScreenOff(){
	Write-Output "NYI"
}
function Yuzu_bezelOn(){
	Write-Output "NYI"
}
function Yuzu_bezelOff(){
	Write-Output "NYI"
}
function Yuzu_finalize(){
	Write-Output "NYI"
}
function Yuzu_IsInstalled(){
	$test=Test-Path -Path "$emusPath\yuzu\yuzu-windows-msvc"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Yuzu_resetConfig(){
	Yuzu_init
	if($?){
		Write-Output "true"
	}
}


### Yuzu EA
function YuzuEA_install($tokenValue) {
	$jwtHost = "https://api.yuzu-emu.org/jwt/installer/"
	$yuzuEaHost = "https://api.yuzu-emu.org/downloads/earlyaccess/"
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

		$yuzuEaMetadata = curl  "https://api.yuzu-emu.org/downloads/earlyaccess/" | ConvertFrom-Json

		$url_yuzuEA = ($yuzuEaMetadata.files | Where-Object { $_.name -match ".*\.7z" }).url

		$jwtHost = "https://api.yuzu-emu.org/jwt/installer/"

		$headers = @{
			"X-Username" = $user
			"X-Token" = $auth
			"User-Agent" = "EmuDeck"
		}

		$response = Invoke-WebRequest -Uri $jwtHost -Method Post -Headers $headers
		$BEARERTOKEN = $response.Content


		rm -r -fo "$temp/yuzuEA"-ErrorAction SilentlyContinue > $null
		download $url_yuzuEA "yuzuEA.7z" $BEARERTOKEN > $null
		xcopy "$temp\yuzuEA\yuzu-windows-msvc-early-access\" "$emusPath\yuzu\yuzu-windows-msvc\" /H /E /Y > $null
		rm -r -fo "$temp/yuzuEA" -ErrorAction SilentlyContinue > $null
		#createLauncher "yuzu"

		#SDL fix
		Copy-Item "$env:APPDATA\EmuDeck\backend\configs\yuzu\SDL2.dll" -Destination "$emusPath\yuzu\yuzu-windows-msvc\" -ErrorAction SilentlyContinue -Force

		Write-Host "true"

	} else {
		Write-Host "invalid"
	}

}

function YuzuEA_addToken($tokenValue){
	YuzuEA_install $tokenValue
}

function YuzuEA_IsInstalled() {
	$test=Test-Path -Path "$emusPath\yuzu\yuzu-windows-msvc"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}

function YuzuEA_uninstall() {
	echo "Begin Yuzu EA uninstall"
	Write-Output "NYI"
}
