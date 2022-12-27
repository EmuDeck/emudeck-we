#We need to pick the HD first thing so we can set the rest of the path variables
$drives = (Get-PSDrive -PSProvider FileSystem).Root
$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives

#Set initial Settings
setSetting 'emulationPath' "$winPath\Emulation\"
setSetting 'romsPath' "$winPath\Emulation\roms\"
setSetting 'biosPath' "$winPath\Emulation\bios\"
setSetting 'toolsPath' "$winPath\Emulation\tools\"
setSetting 'savesPath' "$winPath\Emulation\saves\"
setSetting 'storagePath' "$winPath\Emulation\storagePath\"
setSetting 'ESDEscrapData' "$winPath\Emulation\tools\downloaded_media\"
Clear-Host
#Load Settings
. $env:USERPROFILE\EmuDeck\settings.ps1

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
