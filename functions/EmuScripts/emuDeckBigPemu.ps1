$BigPEmu_configFile="$emusPath/BigPEmu/BigPEmuConfig.bigpcfg"

function BigPEmu_install(){
    setMSG "Downloading BigPEmu"
    $url_BigPEmu = "https://www.richwhitehouse.com/jaguar/builds/BigPEmu_v117.zip"
    download $url_BigPEmu "bigpemu.zip"
    moveFromTo "$temp\bigpemu" "$emusPath\BigPEmu"
    createLauncher "BigPEmu"
}

function BigPEmu_init(){
    $destination="$emusPath\BigPEmu"
    copyFromTo "$env:APPDATA\EmuDeck\backend\configs\bigpemu" "$destination"
    BigPEmu_setEmulationFolder
    BigPEmu_setupSaves
}

function BigPEmu_update(){
    Write-Output "true"
}

function BigPEmu_setEmulationFolder(){
    sedFile $BigPEmu_configFile "Z:\\home\\deck\\Emulation" "$emulationPath"
    sedFile $BigPEmu_configFile ":\" ":\\"
}

function BigPEmu_setupSaves(){
    mkdir "$savesPath/bigpemu/saves" -ErrorAction SilentlyContinue
    mkdir "$savesPath/bigpemu/states" -ErrorAction SilentlyContinue
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
