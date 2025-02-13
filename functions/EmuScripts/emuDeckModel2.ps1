$Model2_emuPath = "$emusPath\m2emulator\EMULATOR.EXE"
$Model2_configFile = "$emusPath\m2emulator\EMULATOR.INI"

$Model2_romsPath = "$emusPath\model2\roms"
$Model2_launcherPath = "$toolsPath\launchers\model-2-emulator.ps1"
$DesktopShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Model 2 Emulator.lnk"

function Model2_install() {
    setMSG "Installing Model 2 Emulator"
    $url_Model2 = "https://github.com/PhoenixInteractiveNL/edc-repo0004/raw/master/m2emulator/1.1a.7z"
    download $url_Model2 "model2.zip"
    moveFromTo "$temp\model2" "$emusPath\m2emulator"
    createLauncher "Model2"
}

function Model2_init(){

	$destination="$emusPath\m2emulator"

    mkdir -Force "$destination\pfx"

    $sourcePath = "$env:APPDATA\EmuDeck\backend\configs\model2\EMULATOR.ini"
    $destinationPath = "$emusPath\m2emulator\EMULATOR.ini"
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force

    $sourceCFG = "$env:APPDATA\EmuDeck\backend\configs\model2\CFG"
    $destinationCFG = "$destination\CFG"
    Copy-Item -Path $sourceCFG -Destination $destinationCFG -Recurse -Force

    $sourceNVDATA = "$env:APPDATA\EmuDeck\backend\configs\model2\NVDATA"
    $destinationNVDATA = "$destination\NVDATA"
    if (Test-Path $sourceNVDATA) {
        Copy-Item -Path "$sourceNVDATA\*" -Destination $destinationNVDATA -Recurse -Force
    }

    $sourceScripts = "$env:APPDATA\EmuDeck\backend\configs\model2\scripts"
    $destinationScripts = "$destination\scripts"
    if (Test-Path $sourceScripts) {
        Copy-Item -Path "$sourceScripts\*" -Destination $destinationScripts -Recurse -Force
    }

    Model2_setEmulationFolder

}

function Model2_setEmulationFolder(){
	sedFile $Model2_configFile "roms" "$emulationPath\\roms\\model2"
    sedFile $Model2_configFile ":\" ":\\"
}


function Model2_update(){
	 Write-Output "true"
}

function Model2_uninstall(){
	Remove-Item -path "$emusPath\m2emulator"-recurse -force
	if($?){
		Write-Output "true"
	}
}

function Model2_IsInstalled(){
	$test=Test-Path -Path "$emusPath\m2emulator"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}

function Model2_resetConfig(){
	Model2_init
    if ($?) {
        Write-Output "true"
    } else {
        Write-Output "false"
    }
}