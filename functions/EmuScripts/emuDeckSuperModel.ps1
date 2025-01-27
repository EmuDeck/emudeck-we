$Supermodel_configFile="$emusPath/Supermodel/Config/Supermodel.ini"
$Supermodel_gamesList="https://raw.githubusercontent.com/trzy/Supermodel/master/Config/Games.xml"

function SuperModel_install(){
	setMSG "Installing Supermodel"
    $url_Supermodel = "https://www.supermodel3.com/Files/Git_Snapshots/Supermodel_0.3a-git-d043dc0_Win64.zip" # URL del instalador
    download $url_Supermodel "supermodel.zip"
    moveFromTo "$temp\supermodel" "$emusPath\Supermodel"
    createLauncher "Supermodel"
}
function SuperModel_init(){

	$destination="$emusPath\Supermodel"
    
    mkdir -Force "$destination\Analysis"
    mkdir -Force "$destination\Log"

    $sourcePath = "$env:APPDATA\EmuDeck\backend\configs\supermodel\Supermodel.ini"
    $destinationPath = "$emusPath\Supermodel\Config\Supermodel.ini"
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force

    if (Test-Path "$destination\Config\Games.xml") {
        Remove-Item "$destination\Config\Games.xml" -Force
    }
    Invoke-WebRequest -Uri $Supermodel_gamesList -OutFile "$destination\Config\Games.xml"
    Supermodel_setEmulationFolder
    Supermodel_setupSaves
}

function SuperModel_update(){
	Write-Output "NYI"
}

function SuperModel_setEmulationFolder(){
	sedFile $Supermodel_configFile "ROMs" "$emulationPath\\roms\\model3"
    sedFile $Supermodel_configFile ":\" ":\\"
}

function SuperModel_setupSaves() {

    setMSG "Supermodel - Saves Links"

    mkdir "$emusPath\Supermodel" -ErrorAction SilentlyContinue

    $simLinkPath = "$emusPath\Supermodel\saves"
    $emuSavePath = "$emulationPath\saves\supermodel\saves"
    createSaveLink $simLinkPath $emuSavePath
}

function SuperModel_setupStorage(){
	Write-Output "NYI"
}
function SuperModel_wipe(){
	Write-Output "NYI"
}
function SuperModel_uninstall(){
	Remove-Item -path "$emusPath\SuperModel"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function SuperModel_migrate(){
	Write-Output "NYI"
}
function SuperModel_setABXYstyle(){
	Write-Output "NYI"
}
function SuperModel_wideScreenOn(){
	Write-Output "NYI"
}
function SuperModel_wideScreenOff(){
	Write-Output "NYI"
}
function SuperModel_bezelOn(){
	Write-Output "NYI"
}
function SuperModel_bezelOff(){
	Write-Output "NYI"
}
function SuperModel_finalize(){
	Write-Output "NYI"
}
function SuperModel_IsInstalled(){
	$test=Test-Path -Path "$emusPath\SuperModel"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function SuperModel_resetConfig(){
	Supermodel_init
    if ($?) {
        Write-Output "true"
    } else {
        Write-Output "false"
    }
}