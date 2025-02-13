$BigPEmu_configFile="$env:APPDATA/BigPEmu/BigPEmuConfig.bigpcfg"
$BigPEmu_appData="$env:APPDATA/BigPEmu"
function BigPEmu_install(){
    setMSG "Downloading BigPEmu"
    $url_BigPEmu = "https://www.richwhitehouse.com/jaguar/builds/BigPEmu_v117.zip"
    download $url_BigPEmu "bigpemu.zip"
    moveFromTo "$temp\bigpemu" "$emusPath\BigPEmu"
    createLauncher "BigPEmu"
}

function BigPEmu_init(){
    copyFromTo "$env:APPDATA\EmuDeck\backend\configs\bigpemu" "$BigPEmu_appData"
    BigPEmu_setEmulationFolder
    BigPEmu_setupSaves
    BigPEmu_setupStorage
}

function BigPEmu_update(){
    Write-Output "true"
}

function BigPEmu_setEmulationFolder(){
    $jsonContent = Get-Content -Path $BigPEmu_configFile | ConvertFrom-Json
    $jsonContent.BigPEmuConfig.ROMPath = "$emulationPath\roms\atarijaguar"
    $jsonContent | ConvertTo-Json -Depth 100 | Set-Content -Path $BigPEmu_configFile
}

function BigPEmu_setupSaves(){

    setMSG "BigPEmu - Saves Links"

    mkdir $BigPEmu_appData -ErrorAction SilentlyContinue

    $simLinkPath = "$BigPEmu_appData"
    $emuSavePath = "$emulationPath\saves\BigPEmu\saves"
    createSaveLink $simLinkPath $emuSavePath

}

function BigPEmu_setupStorage {

    mkdir "$storagePath/BigPEmu/screenshots" -ErrorAction SilentlyContinue
    createSymlink "$BigPEmu_appData/screenshots" "$storagePath/BigPEmu/screenshots"

}



function BigPEmu_uninstall(){
    rm -fo -r "$emusPath\BigPEmu"
    if($?){
        Write-Output "true"
    }
}

function BigPEmu_IsInstalled(){
    $test=Test-Path -Path "$emusPath\BigPEmu\BigPEmu.exe"
    if($test){
        Write-Output "true"
    }else{
        Write-Output "false"
    }
}

function BigPEmu_resetConfig(){
    BigPEmu_init
    if($?){
        Write-Output "true"
    }
}
