function Cemu_install(){
	statInstall "cemu"
	setMSG "Downloading Cemu"
	$url_cemu = getReleaseURLGH 'cemu-project/Cemu' 'zip' 'windows-x64' "ubuntu"
	download $url_cemu "cemu.zip"

	$folderPath = "$temp/cemu"
	$subfolders = Get-ChildItem -Path $folderPath -Directory

	foreach ($subfolder in $subfolders) {
		$subfolderName = $subfolder.Name
		moveFromTo "$temp/cemu/$subfolderName" "$emusPath\cemu"
	}

	Remove-Item -Recurse -Force cemu -ErrorAction SilentlyContinue
	createLauncher "Cemu"

}
function Cemu_init(){
	setMSG "Cemu - Configuration"
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\cemu" "$emusPath\cemu"
	sedFile "$emusPath\cemu\controllerProfiles\controller0.xml" "DSUController" "XInput"
	#sedFile "$emusPath\cemu\controllerProfiles\Deck-Gamepad-Gyro.xml" "DSUController" "XInput"
	sedFile "$emusPath\cemu\settings.xml" "C:\Emulation" "$emulationPath"

	Cemu_setupSaves



}
function Cemu_update(){
	Write-Output "NYI"
}
function Cemu_setEmulationFolder(){
	Write-Output "NYI"
}

function Cemu_setupSaves(){
	setMSG "Cemu - Saves Links"
	mkdir "$emusPath\cemu\mlc01\usr\" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\cemu\mlc01\usr\save"
	$emuSavePath = "$emulationPath/saves\Cemu\saves"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\Cemu"
}

function Cemu_setResolution($resolution){
	Write-Output $resolution
}

function Cemu_setupStorage(){
	Write-Output "NYI"
}
function Cemu_wipe(){
	Write-Output "NYI"
}
function Cemu_uninstall(){
	Remove-Item -path "$emusPath\Cemu" -recurse -force
	if($?){
		Write-Output "true"
	}
}
function Cemu_migrate(){
	Write-Output "NYI"
}
function Cemu_setButtonStyle($rules){
	Get-ChildItem -Path "$emusPath\cemu\controllerProfiles" -Filter "controller*.xml" -ErrorAction SilentlyContinue | ForEach-Object {
		$content = Get-Content -Raw -Path $_.FullName
		$api = "SDL"
		if ($content -match '<api>XInput</api>') {
			$api = "XInput"
		}
		foreach ($rule in $rules[$api]) {
			$content = $content -replace "(<mapping>$($rule[0])</mapping>\s*<button>)$($rule[1])(</button>)", "`${1}$($rule[2])`$2"
		}
		[System.IO.File]::WriteAllText($_.FullName, $content, (New-Object System.Text.UTF8Encoding($false)))
	}
}
function Cemu_setABXYstyle(){
	Cemu_setButtonStyle @{ SDL = @(@(1, 1, 0), @(2, 0, 1), @(3, 3, 2), @(4, 2, 3)); XInput = @(@(1, 13, 12), @(2, 12, 13), @(3, 15, 14), @(4, 14, 15)) }
}
function Cemu_setBAYXstyle(){
	Cemu_setButtonStyle @{ SDL = @(@(1, 0, 1), @(2, 1, 0), @(3, 2, 3), @(4, 3, 2)); XInput = @(@(1, 12, 13), @(2, 13, 12), @(3, 14, 15), @(4, 15, 14)) }
}
function Cemu_setControllers(){
	if ("$autoMapCemu" -eq "false") {
		return
	}
	$controllerDir = "$emusPath\cemu\controllerProfiles"
	if (-not (Test-Path $controllerDir)) {
		return
	}
	foreach ($sdlLib in @("$emusPath\eden-windows-msvc\SDL2.dll", "$env:APPDATA\EmuDeck\backend\configs\eden\SDL2.dll")) {
		if (-not (Test-Path $sdlLib)) {
			continue
		}
		ignoreSteamVirtualGamepad $sdlLib
		runGamepadsTool "cemuGamepads.py" $sdlLib @{ CEMU_CONTROLLER_DIR = $controllerDir; CEMU_TEMPLATE_DIR = "$env:APPDATA\EmuDeck\backend\configs\cemu\controllerTemplates" } @("--write") | Out-Null
		if ($controllerLayout -eq "bayx" -or $controllerLayout -eq "baxy") {
			Cemu_setBAYXstyle
		} else {
			Cemu_setABXYstyle
		}
		return
	}
}
function Cemu_launch_fixes(){
	Cemu_setControllers
}
function Cemu_wideScreenOn(){
	Write-Output "NYI"
}
function Cemu_wideScreenOff(){
	Write-Output "NYI"
}
function Cemu_bezelOn(){
	Write-Output "NYI"
}
function Cemu_bezelOff(){
	Write-Output "NYI"
}
function Cemu_finalize(){
	Write-Output "NYI"
}
function Cemu_IsInstalled(){
	$test=Test-Path -Path "$emusPath\cemu"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Cemu_resetConfig(){
	Cemu_init
	if($?){
		Write-Output "true"
	}
}

function Cemu_addToSteam(){
	setMSG "Adding Cemu to Steam"
	add_to_steam 'cemu' 'Cemu' "$toolsPath\launchers\Cemu.ps1" "$emusPath\cemu" "$emudeckFolder\backend\tools\launchers\icons\cemu.ico" "Emulation"
}
