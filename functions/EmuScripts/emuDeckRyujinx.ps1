$Ryujinx_configFile="$emusPath\Ryujinx\portable\Config.json"

function Ryujinx_install(){
	setMSG "Downloading Ryujinx"

	# Obtiene la última URL válida del release para Windows x64 desde GitLab
	$apiUrl = "https://git.ryujinx.app/api/v4/projects/1/releases"
	try {
		$releases = Invoke-RestMethod -Uri $apiUrl
		# Ordena las releases por fecha descendente y coge la más reciente
		$latestRelease = $releases | Sort-Object { [datetime]$_.released_at } -Descending | Select-Object -First 1
		# Busca el asset que sea un ZIP para Windows x64
		$asset = $latestRelease.assets.links | Where-Object { $_.name -match "win_x64\.zip$" }
		if (-not $asset) {
			throw "No se encontró asset de Windows x64 en la última release."
		}
		$url_ryujinx = $asset.url
	}
	catch {
		Write-Host "Error obteniendo URL de descarga: $($_.Exception.Message)"
		return
	}

	download $url_ryujinx "ryujinx.zip"
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
	}

	$jsonConfig = Get-Content -Path "$emusPath\Ryujinx\portable\Config.json" | ConvertFrom-Json
	$jsonConfig.docked_mode = $docked
	$jsonConfig.res_scale = $multiplier
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
	Write-Output "NYI"
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
