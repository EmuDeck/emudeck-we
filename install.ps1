#We add WinRar folders to the Path
$env:path = $env:path + ";C:\Program Files\WinRaR"
$env:path = $env:path + ";C:\Program Files (x86)\WinRaR"

#We check for WinRar
$test=Test-Path -Path "C:\Program Files\WinRaR"
if(-not($test)){
	$test=Test-Path -Path "C:\Program Files (x86)\WinRaR"
	if(-not($test)){
		Write-Host "================ WinRar not detected ================" -ForegroundColor red -BackgroundColor black
		Write-Host "WinRar is a free program needed to install Emudeck." -ForegroundColor red -BackgroundColor black
		Write-Host "You can download it for free from winrar.com" -ForegroundColor red -BackgroundColor black
		Write-Host "Try to install EmuDeck again after installing it" -ForegroundColor red -BackgroundColor black
		waitForUser		
		exit
	}
}

$Host.UI.RawUI.WindowTitle = "EmuDeck Windows Edition Alpha Installer";

#
# Functions
#



. $env:USERPROFILE\EmuDeck\backend\functions\showListDialog.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\waitForWinRar.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\download.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\downloadCore.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\showNotification.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\moveFromTo.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\copyFromTo.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\waitForUser.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\sedFile.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\createLink.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\createLauncher.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\helperFunctions.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\showButtonQuestionImg.ps1

. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckCemu.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckCitra.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckDolphin.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckDuckStation.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckPCSX2.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckRetroArch.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckRPCS3.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckTemplate.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckXemu.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckXenia.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckYuzu.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckRyujinx.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\EmuScripts\emuDeckPPSSPP.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\ToolScripts\emuDeckESDE.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\ToolScripts\emuDeckSRM.ps1



#
# Variables
#
Clear-Host
. $env:USERPROFILE\EmuDeck\backend\vars.ps1

cp "$env:USERPROFILE\EmuDeck\backend\settings.ps1" "$env:USERPROFILE\EmuDeck\settings.ps1"

#
# UI & Settings creation
#
. $env:USERPROFILE\EmuDeck\backend\ui.ps1

#
# Installation
#

. $env:USERPROFILE\EmuDeck\settings.ps1

mkdir $emulationPath -ErrorAction SilentlyContinue
Set-Location $emulationPath
mkdir $biosPath -ErrorAction SilentlyContinue
mkdir $toolsPath -ErrorAction SilentlyContinue
mkdir $savesPath -ErrorAction SilentlyContinue
mkdir "$toolsPath\launchers" -ErrorAction SilentlyContinue
Clear-Host

Write-Output "Installing, please stand by..."
Write-Output ""

copyFromTo "$env:USERPROFILE\EmuDeck\backend\roms" "roms"

#Dowloading..ESDE
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\EmulationStation.exe"
if(-not($test)){
	ESDE_install
}


#SRM
$test=Test-Path -Path "$emulationPath\tools\srm.exe"
if(-not($test)){
	SRM_install
}

#
# Emulators Download
#

#RetroArch
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\RetroArch.exe"
if(-not($test)){
	RetroArch_install
}

#Dolphin
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\Dolphin-x64\Dolphin.exe"
if(-not($test)){
	Dolphin_install
}

#PCSX2 
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\PCSX2\pcsx2-qtx64-avx2.exe"
if(-not($test)){
	PCSX2_install
}

#RPCS3
#$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\RPCS3"
#if(-not($test)){
#	RPCS3_install
#}

#Xemu
#$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\xemu"
#if(-not($test)){
#	Xemu_install
#}

#Yuzu
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc\yuzu.exe"
if(-not($test)){
	Yuzu_install
}

#Citra
#$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\citra"
#if(-not($test)){
#	Citra_install
#}

#DuckStation
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\duckstation\duckstation-qt-x64-ReleaseLTCG.exe"
if(-not($test)){
	DuckStation_install
}

#Cemu
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\cemu\Cemu.exe"
if(-not($test)){
	Cemu_install
}

#Xenia
#$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\xenia"
#if(-not($test)){
#	Xenia_install
#}

#PPSSPP
$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\ppsspp_win\PPSSPPWindows64.exe"
if(-not($test)){
	PPSSPP_install
}


#
# Emus Configuration
# 

showNotification -ToastTitle 'Configuring Emulators'


#RetroArch Config
RetroArch_init

#DuckStation Config
DuckStation_init

#Dolphin
Dolphin_init

#Yuzu
Yuzu_init

#Ryujinx
Ryujinx_init

#Citra
#Citra_init

#Cemu
Cemu_init

#PCSX2
PCSX2_init

#RPCS3
#RPCS3_init

#Xemu
#Xemu_init

#Xenia
#Xenia_init

#PPSSPP
PPSSPP_init

#ESDE
ESDE_init

#SRM
SRM_init


#Launchers links



createLink "$env:USERPROFILE\EmuDeck\backend\update.bat" "$desktop_path\EmuDeck - Update Beta.lnk"


#Customization

#Resolution
echo "Setting Resolution Screen"
Dolphin_setResolution $dolphinResolution
DuckStation_setResolution $duckstationResolution
PCSX2_setResolution $pcsx2Resolution
Yuzu_setResolution $yuzuResolution


#PPSSPP_setResolution $ppssppResolution
#RPCS3_setResolution $screenResolution
#Ryujinx_setResolution $screenResolution
#Xemu_setResolution $screenResolution
#Xenia_setResolution $screenResolution

if($RABezels = 'ON'){
	RetroArch_bezelOnAll
}else{
	RetroArch_bezelOffAll
}
#if($arSega = '43'){
#	
#}else{
#	
#}
#if($arSnes = '43'){
#	
#}else{
#	
#}
#if($arClassic3D = '43'){
#	
#}else{
#	
#}
#if($arDolphin = '43'){
#	
#}else{
#	
#}
#if($arClassic3D = '43'){
#	
#}else{
#	
#}
#if($RAHandHeldShader = 'ON'){
#	
#}else{
#	
#}
#if($RAHandClassic2D = 'ON'){
#	
#}else{
#	
#}
#if($RAHandClassic3D = 'ON'){
#	
#}else{
#	
#}



Write-Output ""
Write-Host "================ Installation Complete! ================" -ForegroundColor green -BackgroundColor black
Write-Output ""
Write-Output "Copy your roms to $emulationPath\roms"
Write-Output "Copy all your bios inside $emulationPath\bios"
Write-Output "Copy your Yuzu Firmware inside $emulationPath\bios\yuzu\firmware"
Write-Output "Copy your Yuzu Keys inside $emulationPath\bios\yuzu\keys"
Write-Output ""
Write-Output ""
Write-Output "When you are done, press ENTER to open Steam Rom Manager to add your roms, emulators and EmulationStation to Steam"
Write-Output ""
waitForUser