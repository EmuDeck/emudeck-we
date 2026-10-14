$Ryujinx_configFile="$emusPath\Ryujinx\portable\Config.json"

function Ryujinx_install() {
	statInstall "ryujinx"
	setMSG "Downloading Ryujinx"

	#$apiUrl  = "https://git.ryujinx.app/api/v1/repos/Ryubing/Canary/releases/latest"
	#$headers = @{ "User-Agent" = "EmuDeck" }
	#$release = Invoke-RestMethod -Uri $apiUrl -Headers $headers
	#$url_Ryujinx = $release.assets |
	#	Where-Object { $_.browser_download_url -match "win_x64" -and $_.browser_download_url -like "*.zip" } |
	#	Select-Object -ExpandProperty browser_download_url -First 1
	$url_Ryujinx = "https://codeberg.org/attachments/468dd04b-7538-46c4-bdb0-1600000023f7"

	if (-not $url_Ryujinx) {
		setMSG "Ryujinx: no Windows ZIP file was found in the latest release."
		return $false
	}

	download $url_Ryujinx "ryujinx.zip"
	moveFromTo "$temp\ryujinx\publish\" "$emusPath\Ryujinx"
	createLauncher "Ryujinx"
}


function Ryujinx_init(){
	setMSG "Ryujinx - Configuration"
	$destination="$emusPath\Ryujinx"
	mkdir "$destination\portable" -ErrorAction SilentlyContinue
	Copy-Item -Path "$env:APPDATA\EmuDeck\backend\configs\Ryujinx\Config.json" -Destination "$destination\portable\Config.json" -Force
	Ryujinx_setEmulationFolder
	Ryujinx_setupSaves
	Ryujinx_setResolution $yuzuResolution


	sedFile "$destination\portable\Config.json" "C:\\Emulation" "$emulationPath"
	sedFile "$destination\portable\Config.json" ":\Emulation" ":\\Emulation"

}

function Ryujinx_update(){
	Write-Output "NYI"
}
function Ryujinx_setEmulationFolder(){
	$destination="$emusPath\Ryujinx"
	sedFile $destination\portable\Config.json "/run/media/mmcblk0p1/Emulation/roms/switch" "$romsPath/switch"
}
function Ryujinx_setupSaves(){

	setMSG "Ryujinx - Creating Keys  Links"
	#Firmware
	mkdir "$emusPath\Ryujinx\portable" -ErrorAction SilentlyContinue
	mkdir "$biosPath\ryujinx" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\Ryujinx\portable\system"
	$emuSavePath = "$emulationPath\bios\ryujinx\keys"
	createSaveLink $simLinkPath $emuSavePath

	setMSG "Ryujinx - Saves Links"
	mkdir "$emusPath\Ryujinx\portable\bis\user" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\Ryujinx\portable\bis\user\save"
	$emuSavePath = "$emulationPath\saves\ryujinx\saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\Ryujinx\portable\bis\system\save"
	$emuSavePath = "$emulationPath\saves\ryujinx\system_saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\Ryujinx\portable\bis\user\saveMeta"
	$emuSavePath = "$emulationPath\saves\ryujinx\saveMeta"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\Ryujinx\portable\system"
	$emuSavePath = "$emulationPath\saves\ryujinx\system"
	createSaveLink $simLinkPath $emuSavePath

	#cloud_sync_save_hash "$savesPath\ryujinx"

}

function Ryujinx_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 1;  $docked="false"}
		"1080P" { $multiplier = 1; $docked="true"   }
		"1440P" { $multiplier = 2;  $docked="false" }
		"4K" { $multiplier = 2; $docked="true" }
		default { $multiplier = 1; $docked="false" }
	}

	$configPath = "$emusPath\Ryujinx\portable\Config.json"
	if ( -not (Test-Path -Path $configPath) ){
		return
	}

	$jsonConfig = Get-Content -Path $configPath -Raw | ConvertFrom-Json
	$jsonConfig.docked_mode = [System.Convert]::ToBoolean($docked)
	$jsonConfig.res_scale = [int]$multiplier
	$jsonConfig | ConvertTo-Json -Depth 100 | Set-Content -Path $configPath -Encoding UTF8
}
function Ryujinx_setupStorage(){
	Write-Output "NYI"
}
function Ryujinx_wipe(){
	Write-Output "NYI"
}
function Ryujinx_uninstall(){
	Remove-Item -path "$emusPath\Ryujinx" -recurse -force
	if($?){
		Write-Output "true"
	}
}
function Ryujinx_migrate(){
	Write-Output "NYI"
}
function Ryujinx_setABXYstyle(){
	if (-not (Test-Path $Ryujinx_configFile)) {
		return
	}
	$content = Get-Content -Raw -Path $Ryujinx_configFile
	$content = $content -replace '"button_x":(\s*)"Y"', '"button_x":$1"X"'
	$content = $content -replace '"button_b":(\s*)"A"', '"button_b":$1"B"'
	$content = $content -replace '"button_y":(\s*)"X"', '"button_y":$1"Y"'
	$content = $content -replace '"button_a":(\s*)"B"', '"button_a":$1"A"'
	[System.IO.File]::WriteAllText($Ryujinx_configFile, $content, (New-Object System.Text.UTF8Encoding($false)))
}
function Ryujinx_setBAYXstyle(){
	if (-not (Test-Path $Ryujinx_configFile)) {
		return
	}
	$content = Get-Content -Raw -Path $Ryujinx_configFile
	$content = $content -replace '"button_x":(\s*)"X"', '"button_x":$1"Y"'
	$content = $content -replace '"button_b":(\s*)"B"', '"button_b":$1"A"'
	$content = $content -replace '"button_y":(\s*)"Y"', '"button_y":$1"X"'
	$content = $content -replace '"button_a":(\s*)"A"', '"button_a":$1"B"'
	[System.IO.File]::WriteAllText($Ryujinx_configFile, $content, (New-Object System.Text.UTF8Encoding($false)))
}
function Ryujinx_wideScreenOn(){
	Write-Output "NYI"
}
function Ryujinx_wideScreenOff(){
	Write-Output "NYI"
}
function Ryujinx_bezelOn(){
	Write-Output "NYI"
}
function Ryujinx_bezelOff(){
	Write-Output "NYI"
}
function Ryujinx_finalize(){
	Write-Output "NYI"
}
function Ryujinx_IsInstalled(){
	$test=Test-Path -Path "$emusPath\Ryujinx"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Ryujinx_resetConfig(){
	Ryujinx_init
	if($?){
		Write-Output "true"
	}
}


function Ryujinx_findSdlLib(){
	foreach ($sdlLib in @("$emusPath\Ryujinx\SDL3.dll")) {
		if (Test-Path $sdlLib) {
			return $sdlLib
		}
	}
	return $null
}

function Ryujinx_gamepadCount(){
	$sdlLib = Ryujinx_findSdlLib
	if (-not $sdlLib) {
		return 0
	}
	$count = runGamepadsTool "ryujinxGamepads.py" $sdlLib @{} @("--count")
	if ("$count" -match '^\d+$') {
		return [int]"$count"
	}
	return 0
}

function Ryujinx_getOrderedGamepads(){
	$sdlLib = Ryujinx_findSdlLib
	if (-not $sdlLib) {
		Write-Host "SDL3.dll not found"
		return $null
	}
	return runGamepadsTool "ryujinxGamepads.py" $sdlLib @{} @()
}

function Ryujinx_set_gamepad_name(){
	if ("$autoMapSwitch" -eq "false") {
		return
	}

	if ($controllerLayout -eq "bayx" -or $controllerLayout -eq "baxy") {
		Ryujinx_setBAYXstyle
	} else {
		Ryujinx_setABXYstyle
	}

	if ((Ryujinx_gamepadCount) -gt 1) {
		$env:SDL_GAMECONTROLLER_IGNORE_DEVICES = "0x28de/0x11ff"
		$env:SDL_JOYSTICK_IGNORE_DEVICES = "0x28de/0x11ff"
	}

	$pads = "$(Ryujinx_getOrderedGamepads)"
	if (-not $pads -or $pads -eq "[]") {
		Write-Host "No controller detected, keeping default input config"
		return
	}
	$pads = $pads | ConvertFrom-Json

	Write-Host "Detected gamepads: $(($pads | ForEach-Object { "$($_.player): $($_.name)" }) -join ', ')"

	$json = Get-Content -Raw -Path $Ryujinx_configFile | ConvertFrom-Json
	$tmpl = @($json.input_config | Where-Object { "$($_.backend)".StartsWith("Gamepad") })[0]
	if (-not $tmpl) {
		$tmpl = @($json.input_config)[0]
	}
	if (-not $tmpl) {
		Write-Host "No gamepad entry to update in $Ryujinx_configFile"
		return
	}
	$backend = "GamepadSDL3"
	if ("$($tmpl.backend)".StartsWith("Gamepad")) {
		$backend = $tmpl.backend
	}

	$json.input_config = @($pads | ForEach-Object {
		$entry = $tmpl | ConvertTo-Json -Depth 100 | ConvertFrom-Json
		$entry.player_index = $_.player
		$entry.id = $_.id
		$entry.name = $_.name
		$entry.backend = $backend
		$entry
	})

	[System.IO.File]::WriteAllText($Ryujinx_configFile, ($json | ConvertTo-Json -Depth 100), (New-Object System.Text.UTF8Encoding($false)))
}

function Ryujinx_launch_fixes(){
	Ryujinx_migrateToSDL3 | Out-Null
	Ryujinx_set_gamepad_name
}

function Ryujinx_configIsSDL2($configFile){
	if([string]::IsNullOrEmpty($configFile)){ $configFile = $Ryujinx_configFile }
	if(-not (Test-Path $configFile)){ return $false }

	try {
		$cfg = Get-Content -Raw -Path $configFile | ConvertFrom-Json
	} catch {
		# A broken config is not a reason to reinstall the emulator behind the user's back
		Write-Host "Ryujinx: could not parse $configFile, skipping the SDL3 migration"
		return $false
	}

	foreach($entry in @($cfg.input_config)){
		if("$($entry.backend)".StartsWith("GamepadSDL2")){ return $true }
	}
	return $false
}

function Ryujinx_migrateToSDL3(){
	if((Ryujinx_IsInstalled) -ne "true"){ return $false }
	if(-not (Ryujinx_configIsSDL2)){ return $false }

	confirmDialog -TitleText "Ryujinx SDL3 Migration" -MessageText "Ryujinx will update itself now to fix controller detection issues"

	$installOutput = Ryujinx_install
	if(@($installOutput) -contains $false){
		Write-Host "Ryujinx: update failed, leaving the existing config untouched"
		return $false
	}
	Ryujinx_init | Out-Null
	return $true
}

function Ryujinx_addToSteam(){
	setMSG "Adding Ryujinx to Steam"
	add_to_steam 'ryujinx' 'Ryujinx' "$toolsPath\launchers\ryujinx.ps1" "$emusPath\Ryujinx" "$emudeckFolder\backend\tools\launchers\icons\Ryujinx.ico" "Emulation"
}
