$BigPEmu_configFile="$emusPath/bigpemu/config.ini"

function BigPEmu_install(){
    setMSG "Downloading BigPEmu"
    $url_BigPEmu = "https://www.richwhitehouse.com/jaguar/builds/BigPEmu_v117.zip"
    download $url_BigPEmu "bigpemu.zip"
    moveFromTo "$temp\bigpemu\BigPEmu" "$emusPath\BigPEmu"
    createLauncher "BigPEmu"
}

function BigPEmu_init(){
    $destination="$emusPath\bigpemu"
    copyFromTo "$env:APPDATA\EmuDeck\backend\configs\bigpemu" "$destination"
    BigPEmu_setEmulationFolder
    BigPEmu_setupSaves
}

function BigPEmu_update(){
    Write-Output "true"
}

function BigPEmu_setEmulationFolder(){
    sedFile $BigPEmu_configFile "/run/media/mmcblk0p1/Emulation" "$emulationPath"
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
    $test=Test-Path -Path "$emusPath\bigpemu\BigPEmu.exe"
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
