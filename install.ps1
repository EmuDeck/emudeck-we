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



. $USERHOME\EmuDeck\backend\functions\showListDialog.ps1
. $USERHOME\EmuDeck\backend\functions\waitForWinRar.ps1
. $USERHOME\EmuDeck\backend\functions\download.ps1
. $USERHOME\EmuDeck\backend\functions\downloadCore.ps1
. $USERHOME\EmuDeck\backend\functions\showNotification.ps1
. $USERHOME\EmuDeck\backend\functions\moveFromTo.ps1
. $USERHOME\EmuDeck\backend\functions\copyFromTo.ps1
. $USERHOME\EmuDeck\backend\functions\waitForUser.ps1
. $USERHOME\EmuDeck\backend\functions\sedFile.ps1
. $USERHOME\EmuDeck\backend\functions\createLink.ps1
. $USERHOME\EmuDeck\backend\functions\createLauncher.ps1


. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckCemu.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckCitra.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckDolphin.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckDuckStation.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckPCSX2.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckRetroArch.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckRPCS3.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckTemplate.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckXemu.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckXenia.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckYuzu.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckRyujinx.ps1
. $USERHOME\EmuDeck\backend\functions\EmuScripts\emuDeckPPSSPP.ps1
. $USERHOME\EmuDeck\backend\functions\ToolScripts\emuDeckESDE.ps1
. $USERHOME\EmuDeck\backend\functions\ToolScripts\emuDeckSRM.ps1



#
# Variables
#
Clear-Host
#We need to pick the HD first thing so we can set the rest of the path variables
$drives = (Get-PSDrive -PSProvider FileSystem).Root
$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
. $USERHOME\EmuDeck\backend\vars.ps1

# Draw welcome screen
Write-Host  -ForegroundColor blue -BackgroundColor black " _____               ______          _      _    _ _____ "
Write-Host  -ForegroundColor blue -BackgroundColor black "|  ___|              |  _  \        | |    | |  | |  ___|"
Write-Host  -ForegroundColor blue -BackgroundColor black "| |__ _ __ __   _   _| | | |___  ___| | __ | |  | | |__  "
Write-Host  -ForegroundColor blue -BackgroundColor black "|  __| '_ ` _ \ | | | | | | / _ \/ __| |/ / | |/\| |  __| "
Write-Host  -ForegroundColor blue -BackgroundColor black "| |__| | | | | | |_| | |/ /  __/ (__|   <  \  /\  / |___ "
Write-Host  -ForegroundColor blue -BackgroundColor black "\____/_| |_| |_|\__,_|___/ \___|\___|_|\_\  \/  \/\____/ "

Write-Output ""
Write-Host "================ Welcome to EmuDeck Windows Edition ================" -ForegroundColor blue -BackgroundColor black
Write-Output ""
Write-Output "This script will create an Emulation folder in $emulationPath"
Write-Output "and in there we will download all the Emulators, EmulationStation, Steam Rom Manager and Rom Folder Structure."
Write-Output ""
Write-Output "Before you continue make sure you have WinRar installed"
Write-Output "You can download Winrar from https://www.win-rar.com/download.html"
Write-Output ""
Write-Host "================ Changelog ================" -ForegroundColor green -BackgroundColor black
Write-Output "Added Emulators: RetroArch, Duckstation, RPCS2, Yuzu, Cemu, Dolphin"
Write-Output ""
Write-Host "================ Missing on this release ================" -ForegroundColor red -BackgroundColor black
Write-Output "RPCS3, Xenia, Vita3K, Citra, Ryujinx"
Write-Output "Hotkeys for: Duckstation, Yuzu, Cemu, PPSSPP, PCSX2"
Write-Output "Better support for 16:9 Screens"
Write-Output ""
waitForUser

Clear-Host

#Customization Dialogs
#$RABezels=showTwoButtonQuestionImg "bezels.png" 'Configure game bezels' 'You can use our preconfigured bezels to hide the vertical black vars on Retro Games' 'ON' 'OFF'
#$arSega=showTwoButtonQuestionImg "ar43.png" 'Configure Aspect Ratio for Classic Sega Games' 'Choose your aspect ratio for your Classic Sega Games' '43' '32'
#$arSnes=showTwoButtonQuestionImg "ar43snes.png" 'Configure Aspect Ratio  Super NES' 'Choose your aspect ratio for Super Nintendo games' '43' '87'
#$arClassic3D=showTwoButtonQuestionImg "ar433d.png" 'Configure Aspect Ratio for Classic 3D Games' 'Choose your aspect ratio for Dreamcast and Nintendo 64' '43' '169'
#$arDolphin=showTwoButtonQuestionImg "ar43gc.png" 'Configure Aspect Ratio for GameCube' 'Choose your aspect ratio for GameCube games. You can change this
#  setting in game anytime with a hotkey.' '43' '169'
#$RAHandHeldShader=showTwoButtonQuestionImg "lcdon.png" 'Configure LCD Shader Handhelds' 'The LCD Shader simulates the old LCD Matrix screens of handheld systems' 'ON' 'OFF'
#$RAHandClassic2D=showTwoButtonQuestionImg "classic-shader-on.png" 'Configure CRT Shader Classic 2d Games' 'The CRT Shader gives your classic systems a faux retro CRT vibe' 'ON' 'OFF'
#$RAHandClassic3D=showTwoButtonQuestionImg "classic-3d-shader-on.png" 'Configure CRT Shader Classic 3d Games' 'The CRT Shader gives your classic systems a faux retro CRT vibe' 'ON' 'OFF'

# Creating folders

mkdir $emulationPath -ErrorAction SilentlyContinue
Set-Location $emulationPath
mkdir $biosPath -ErrorAction SilentlyContinue
mkdir $toolsPath -ErrorAction SilentlyContinue
mkdir $savesPath -ErrorAction SilentlyContinue
copyFromTo "$USERHOME\EmuDeck\backend\roms" "roms"

Clear-Host

Write-Output "Installing, please stand by..."
Write-Output ""


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


# Deleting temp folders
showNotification -ToastTitle 'Cleaning up...'
Remove-Item -Recurse -Force cemu -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ra -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force dolphin -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force esde -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force pcsx2 -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force yuzu -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force temp -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force citra -ErrorAction SilentlyContinue
Write-Host "Done!" -ForegroundColor green -BackgroundColor black


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



mkdir 'tools\launchers' -ErrorAction SilentlyContinue
createLauncher "cemu" "Cemu"
createLauncher "Dolphin-x64" "Dolphin-emu"
createLauncher "duckstation" "duckstation-qt-x64-ReleaseLTCG"
createLauncher "PCSX2" "pcsx2-qtx64-avx2"
createLauncher "RetroArch" "retroarch"
createLauncher "yuzu\yuzu-windows-msvc" "yuzu"

#createLauncher "citra" "citra-emulator"
#createLauncher "RPCS3" "rpcs3"
#createLauncher "xemu" "xemu"
#createLauncher "xenia" "xenia"

createLink "$USERHOME\EmuDeck\backend\update.bat" "$USERHOME\Desktop\EmuDeck - Update Beta.lnk"


#Customization

#if($RABezels = 'ON'){
#	
#}else{
#	
#}
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