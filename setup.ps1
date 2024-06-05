function setMSGTemp($message){
	$progressBarValue = Get-Content -Path "$env:APPDATA\EmuDeck\msg.log" -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+1

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii "$env:APPDATA\EmuDeck\msg.log"
	Write-Output $message
	Add-Content "$env:APPDATA\EmuDeck\msg.log" "# $message" -NoNewline -Encoding UTF8
	Start-Sleep -Seconds 0.5
}
setMSGTemp 'Creating configuration files. please wait'

Write-Output "" > "$env:USERPROFILE\EmuDeck\logs\EmuDeckSetup.log"

Start-Sleep -Seconds 1.5

Start-Transcript "$env:USERPROFILE\EmuDeck\logs\EmuDeckSetup.log"

#We install 7zip - Now its on the appimage
#winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements

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
Remove-Item "$userFolder\AppData\Roaming\EmuDeck\msg.log" -ErrorAction SilentlyContinue
Write-Output "Installing, please stand by..."
Write-Output ""


#Android ADB
if ( Android_ADB_isInstalled -eq "false" ){
	Android_ADB_install
}

copyFromTo "$env:APPDATA\EmuDeck\backend\roms" "$romsPath"


#Dowloading..ESDE
$test=Test-Path -Path "$esdePath\ES-DE.exe"
if(-not($test) -and $doInstallESDE -eq "true" ){
	ESDE_install
}

$test=Test-Path -Path "$env:USERPROFILE\EmuDeck\Pegasus\pegasus-fe.exe"
if(-not($test) -and $doInstallPegasus -eq "true" ){
	pegasus_install
}

#SRM
SRM_install


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


setMSG 'Configuring Save folders'
$setupSaves = $setupSaves.Substring(0, $setupSaves.Length - 1)
Invoke-Expression $setupSaves

autofix_areInstalled

Stop-Transcript