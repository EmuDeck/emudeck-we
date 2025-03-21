function setMSGTemp($message){
	$logFilePath = "$env:APPDATA\emudeck\logs\msg.log"

	$line = Get-Content -Path $logFilePath -TotalCount 1 -ErrorAction SilentlyContinue

	$progressBarValue = ($line -split '#')[0]

	if ($progressBarValue -match '^\d+$') {
		$progressBarUpdate = [int]$progressBarValue + 5
	} else {
		$progressBarUpdate = 5
	}

	if ($progressBarUpdate -ge 95) {
		$progressBarUpdate = 90
	}

	"$progressBarUpdate# $Message" | Out-File -Encoding ASCII $logFilePath

	Start-Sleep -Seconds 0.5
}
setMSGTemp 'Creating configuration files. please wait'

Write-Output "" > "$env:APPDATA\EmuDeck\logs\EmuDeckSetup.log"

Start-Sleep -Seconds 1.5

Start-Transcript "$env:APPDATA\EmuDeck\logs\EmuDeckSetup.log"

# JSON Parsing to ps1 file
. "$env:APPDATA\EmuDeck\backend\functions\JSONtoPS1.ps1"
JSONtoPS1


#
# Functions, settings and vars
#

. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

setScreenDimensionsScale

mkdir "$emulationPath" -ErrorAction SilentlyContinue
mkdir "$biosPath" -ErrorAction SilentlyContinue
mkdir "$toolsPath" -ErrorAction SilentlyContinue
mkdir "$toolsPath\launchers" -ErrorAction SilentlyContinue
mkdir "$savesPath" -ErrorAction SilentlyContinue

#
# Installation
#
#
#Clear old installation msg log
Remove-Item "$emudeckFolder\logs\msg.log" -ErrorAction SilentlyContinue
Write-Output "Installing, please stand by..."
Write-Output ""


#Android ADB
if ( Android_ADB_isInstalled -eq "false" ){
	Android_ADB_install
}

copyFromTo "$env:APPDATA\EmuDeck\backend\roms" "$romsPath"

$test=Test-Path -Path "$env:APPDATA\emudeck\Pegasus\pegasus-fe.exe"
if(-not($test) -and $doInstallPegasus -eq "true" ){
	pegasus_install
}


#SRM

#Forced install on easy
if($doInstallSRM -eq "true" ){
	SRM_install
}

if($doInstallESDE -eq "true" ){
	ESDE_install
}




#
# Emulators Download
#

#RetroArch
$test=Test-Path -Path "$emusPath\RetroArch\RetroArch.exe"
if(-not($test) -and $doInstallRA -eq "true" ){
	RetroArch_install
}

#Dolphin
$test=Test-Path -Path "$emusPath\Dolphin-x64\Dolphin.exe"
if(-not($test) -and $doInstallDolphin -eq "true" ){
	Dolphin_install
}

#PCSX2
$test=Test-Path -Path "$emusPath\PCSX2-Qt\pcsx2-qtx64-avx2.exe"
if(-not($test) -and $doInstallPCSX2 -eq "true" ){
	PCSX2QT_install
}

#RPCS3
$test=Test-Path -Path "$emusPath\RPCS3\rpcs3.exe"
if(-not($test) -and $doInstallRPCS3 -eq "true" ){
	RPCS3_install
}

#Xemu
$test=Test-Path -Path "$emusPath\xemu\xemu.exe"
if(-not($test) -and $doInstallXemu -eq "true" ){
	Xemu_install
}

#Yuzu
$test=Test-Path -Path "$emusPath\yuzu\yuzu-windows-msvc\yuzu.exe"
if(-not($test) -and $doInstallYuzu -eq "true" ){
	Yuzu_install
}

#Citra
$test=Test-Path -Path "$emusPath\citra\citra-qt.exe"
if(-not($test) -and $doInstallCitra -eq "true" ){
	Citra_install
}
#Citra
$test=Test-Path -Path "$emusPath\azahar\azahar-qt.exe"
if(-not($test) -and $doInstallAzahar -eq "true" ){
	Azahar_install
}
#melonDS
$test=Test-Path -Path "$emusPath\melonDS\melonDS.exe"
if(-not($test) -and $doInstallmelonDS -eq "true" ){
	melonDS_install
}

#Ryujinx
$test=Test-Path -Path "$emusPath\Ryujinx\Ryujinx.exe"
if(-not($test) -and $doInstallRyujinx -eq "true" ){
	Ryujinx_install
}

#DuckStation
$test=Test-Path -Path "$emusPath\duckstation\duckstation-qt-x64-ReleaseLTCG.exe"
if(-not($test) -and $doInstallDuck -eq "true" ){
	DuckStation_install
}

#Cemu
$test=Test-Path -Path "$emusPath\cemu\Cemu.exe"
if(-not($test) -and $doInstallCemu -eq "true" ){
	Cemu_install
}

#Xenia
$test=Test-Path -Path "$emusPath\xenia\xenia.exe"
if(-not($test) -and $doInstallXenia -eq "true" ){
	Xenia_install
}

#Vita3K
$test=Test-Path -Path "$emusPath\Vita3K\Vita3K.exe"
if(-not($test) -and $doInstallVita3K -eq "true" ){
	Vita3K_install
}

#MAME
$test=Test-Path -Path "$emusPath\mame\mame.exe"
if(-not($test) -and $doInstallMAME -eq "true" ){
	MAME_install
}

#Primehack
$test=Test-Path -Path "$emusPath\Primehack\Primehack.exe"
if(-not($test) -and $doInstallPrimehack -eq "true" ){
	Primehack_install
}

#PPSSPP
$test=Test-Path -Path "$emusPath\ppsspp_win\PPSSPPWindows64.exe"
if(-not($test) -and $doInstallPPSSPP -eq "true" ){
	PPSSPP_install
}
#mGBA
$test=Test-Path -Path "$emusPath\mgba\mgba.exe"
if(-not($test) -and $doInstallMGBA -eq "true" ){
	mGBA_install
}

#Scumm
$test=Test-Path -Path "$emusPath\scummvm\scummvm.exe"
if(-not($test) -and $doInstallScummVM -eq "true" ){
	ScummVM_install
}

#ShadPS4
$test=Test-Path -Path "$emusPath\shadps4-qt\shadps4.exe"
if(-not($test) -and $doInstallShadPS4 -eq "true" ){
	ShadPS4_install
}

#BigPEmu
$test = Test-Path -Path "$emusPath\BigPEmu\BigPEmu.exe"
if (-not($test) -and $doInstallBigPEmu -eq "true") {
    BigPEmu_install
}

#Supermodel
$test = Test-Path -Path "$emusPath\Supermodel\Supermodel.exe"
if (-not($test) -and $doInstallBigPEmu -eq "true") {
    SuperModel_install
}


#
# Emus Configuration
#

setMSG 'Configuring Emulators'

if ( "$doSetupESDE" -eq "true" ){
	ESDE_init
	#$setupSaves+="ESDE_setupSaves;"
}

if ( "$doSetupPegasus" -eq "true" ){
	pegasus_init
}

if ( "$doSetupSRM" -eq "true" ){
	SRM_init
}

$setupSaves=''
if ( "$doSetupRA" -eq "true" ){
	RetroArch_init
	$setupSaves+="RetroArch_setupSaves;"
}

if ( "$doSetupDuck" -eq "true" ){
	DuckStation_init
	$setupSaves+="DuckStation_setupSaves;"
}

if ( "$doSetupDolphin" -eq "true" ){
	Dolphin_init
	$setupSaves+="Dolphin_setupSaves;"
}

if ( "$doSetupYuzu" -eq "true" ){
	Yuzu_init
	$setupSaves+="Yuzu_setupSaves;"
}

if ( "$doSetupRyujinx" -eq "true" ){
	Ryujinx_init
	$setupSaves+="Ryujinx_setupSaves;"
}

if ( "$doSetupCitra" -eq "true" ){
	Citra_init
	$setupSaves+="Citra_setupSaves;"
}

if ( "$doSetupAzahar" -eq "true" ){
	Azahar_init
	$setupSaves+="Azahar_setupSaves;"
}

if ( "$doSetupCemu" -eq "true" ){
	Cemu_init
	$setupSaves+="Cemu_setupSaves;"
}

if ( "$doSetupPCSX2" -eq "true" ){
	PCSX2QT_init
	$setupSaves+="PCSX2QT_setupSaves;"
}

if ( "$doSetupRPCS3" -eq "true" ){
	RPCS3_init
	$setupSaves+="RPCS3_setupSaves;"
}


if ( "$doSetupPPSSPP" -eq "true" ){
	PPSSPP_init
	$setupSaves+="PPSSPP_setupSaves;"
}


if ( "$doSetupmelonDS" -eq "true" ){
	melonDS_init
	$setupSaves+="melonDS_setupSaves;"
}

if ( "$doSetupXemu" -eq "true" ){
	Xemu_init
	$setupSaves+="Xemu_setupSaves;"
}

if ( "$doSetupXenia" -eq "true" ){
	Xenia_init
	$setupSaves+="Xenia_setupSaves;"
}

if ( "$doSetupVita3K" -eq "true" ){
	Vita3K_init
	$setupSaves+="Vita3K_setupSaves;"
}

if ( "$doSetupScummVM" -eq "true" ){
	ScummVM_init
	$setupSaves+="ScummVM_setupSaves;"
}

if ( "$doSetupMGBA" -eq "true" ){
	mGBA_init
	$setupSaves+="mGBA_setupSaves;"
}

if ( "$doSetupShadPS4" -eq "true" ){
	ShadPS4_init
	$setupSaves+="ShadPS4_setupSaves;"
}

if ("$doSetupBigPEmu" -eq "true") {
    BigPEmu_init
    $setupSaves += "BigPEmu_setupSaves;"
}

if ("$doSetupSupermodel" -eq "true") {
    SuperModel_init
    $setupSaves += "SuperModel_setupSaves;"
}

if ("$doSetupModel2" -eq "true") {
    Model2_init
    $setupSaves += "Model2_setupSaves;"
}


setMSG 'Configuring Save folders'
$setupSaves = $setupSaves.Substring(0, $setupSaves.Length - 1)
Invoke-Expression $setupSaves

autofix_areInstalled

Stop-Transcript