#We add Winrar folders to the Path
$env:path = $env:path + ";C:\Program Files\WinRaR"
$env:path = $env:path + ";C:\Program Files (x86)\WinRaR"

$Host.UI.RawUI.WindowTitle = "EmuDeck Windows Edition Alpha Installer";

#
# Functions
#

. .\functions\showListDialog.ps1
. .\functions\waitForWinRar.ps1
. .\functions\download.ps1
. .\functions\downloadCore.ps1
. .\functions\showNotification.ps1
. .\functions\moveFromTo.ps1
. .\functions\copyFromTo.ps1
. .\functions\waitForUser.ps1
. .\functions\sedFile.ps1
. .\functions\createLink.ps1


. .\functions\EmuScripts\emuDeckCemu.ps1
. .\functions\EmuScripts\emuDeckCitra.ps1
. .\functions\EmuScripts\emuDeckDolphin.ps1
. .\functions\EmuScripts\emuDeckDuckStation.ps1
. .\functions\EmuScripts\emuDeckPCSX2.ps1
. .\functions\EmuScripts\emuDeckRetroArch.ps1
. .\functions\EmuScripts\emuDeckRPCS3.ps1
. .\functions\EmuScripts\emuDeckTemplate.ps1
. .\functions\EmuScripts\emuDeckXemu.ps1
. .\functions\EmuScripts\emuDeckXenia.ps1
. .\functions\EmuScripts\emuDeckYuzu.ps1
. .\functions\ToolScripts\emuDeckESDE.ps1
. .\functions\ToolScripts\emuDeckSRM.ps1

#
# Variables
#
Clear-Host
#We need to pick the HD first thing so we can set the rest of the path variables
$drives = (Get-PSDrive -PSProvider FileSystem).Root
$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
. .\vars.ps1

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
Write-Output "This script will create an Emulation folder in $EmulationPath"
Write-Output "and in there we will download all the Emulators, EmulationStation, Steam Rom Manager and Rom Folder Structure."
Write-Output ""
Write-Output "Before you continue make sure you have WinRar installed"
Write-Output "You can download Winrar from https://www.win-rar.com/download.html"
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

mkdir $EmulationPath -ErrorAction SilentlyContinue
Set-Location $EmulationPath
mkdir $biosPath -ErrorAction SilentlyContinue
mkdir $toolsPath -ErrorAction SilentlyContinue
mkdir $savesPath -ErrorAction SilentlyContinue
Clear-Host

Write-Output "Installing, please stand by..."
Write-Output ""

#EmuDeck Download
showNotification -ToastTitle "Downloading EmuDeck files"
download "https://github.com/EmuDeck/emudeck-we/archive/refs/heads/main.zip" "temp.zip"
moveFromTo "temp\EmuDeck-we-main" "EmuDeck"
copyFromTo "EmuDeck\roms" "roms"
#copyFromTo "EmuDeck\tools\launchers" "tools\launchers"

#Dowloading..ESDE
ESDE_install

#SRM
$test=Test-Path -Path "$EmulationPath\tools\srm.exe"
if(-not($test)){
	SRM_install
}

#
# Emulators Download
#

#RetroArch

$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\RetroArch"
if(-not($test)){
	RetroArch_install
}

#Dolphin
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\Dolphin-x64"
if(-not($test)){
	Dolphin_install
}

#PCSX2 
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\PCSX2"
if(-not($test)){
	PCSX2_install
}

#RPCS3
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\RPCS3"
if(-not($test)){
	RPCS3_install
}

#Xemu
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\xemu"
if(-not($test)){
	Xemu_install
}

#Yuzu
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\yuzu"
if(-not($test)){
	Yuzu_install
}

#Citra
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\citra"
if(-not($test)){
	Citra_install
}

#DuckStation
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\duckstation"
if(-not($test)){
	DuckStation_install
}

#Cemu
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\cemu"
if(-not($test)){
	Cemu_install
}

#Xenia
$test=Test-Path -Path "$EmulationPath\tools\EmulationStation-DE\Emulators\xenia"
if(-not($test)){
	Xenia_install
}



# Deleting temp folders
showNotification -ToastTitle 'Cleaning up...'
Remove-Item cemu -ErrorAction SilentlyContinue
Remove-Item ra -ErrorAction SilentlyContinue
Remove-Item dolphin -ErrorAction SilentlyContinue
Remove-Item esde -ErrorAction SilentlyContinue
Remove-Item pcsx2 -ErrorAction SilentlyContinue
Remove-Item yuzu -ErrorAction SilentlyContinue
Remove-Item temp -ErrorAction SilentlyContinue
Remove-Item citra -ErrorAction SilentlyContinue
Write-Host "Done!" -ForegroundColor green -BackgroundColor black


#
# Emus Configuration
# 

showNotification -ToastTitle 'Configuring Emulators'


#RetroArch Config
RetroArch_init

#DuckStation Config






#Dolphin


#Yuzu

Yuzu_init



#Ryu


#Citra


#Cemu


#PCSX2


#RPCS3


#Xemu


#Xenia



#ESDE
showNotification -ToastTitle 'EmulationStation DE - Paths and Themes'
mkdir "tools\EmulationStation-DE\.emulationstation" -ErrorAction SilentlyContinue
Copy-Item EmuDeck\configs\emulationstation\es_settings.xml tools\EmulationStation-DE\.emulationstation\es_settings.xml
sedFile 'tools\EmulationStation-DE\.emulationstation\es_settings.xml' '/run/media/mmcblk0p1/Emulation/roms/' $romsPath

download "https://github.com/dragoonDorise/es-theme-epicnoir/archive/refs/heads/master.zip" "temp.zip"
moveFromTo "temp\es-theme-epicnoir-master" "tools\EmulationStation-DE\themes\es-epicnoir"

#SRM
#sedFile 'tools\userData\userConfigurations.json' 'E:\' $winPath






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




#
#Controller configs
#Dolphin
#$controllerDolphinIni=-join($dolphinDir,'\GCPadNew.ini')
#$controllerDolphinWiiIni=-join($dolphinDir,'\WiimoteNew.ini')
#
#Dolphin GC
#sedFile $controllerDolphinIni 'evdev/0/Microsoft X-Box 360 pad 0' 'XInput/0/Gamepad'
#sedFile $controllerDolphinIni 'Buttons/A = SOUTH' 'Buttons/A = Button B'
#sedFile $controllerDolphinIni 'Buttons/B = EAST' 'Buttons/B = Button A'
#sedFile $controllerDolphinIni 'Buttons/X = NORTH' 'Buttons/X = Button Y'
#sedFile $controllerDolphinIni 'Buttons/Y = WEST' 'Buttons/Y = Button X'
#sedFile $controllerDolphinIni 'Buttons/Z = TR' 'Buttons/Z = Trigger L'
#sedFile $controllerDolphinIni 'Buttons/Start = START' 'Buttons/Start = Start'
#sedFile $controllerDolphinIni 'Main Stick/Up = `Axis 1-`' 'Main Stick/Up = `Left Y+`'
#sedFile $controllerDolphinIni 'Main Stick/Down = `Axis 1+`' 'Main Stick/Down = `Left Y-`'
#sedFile $controllerDolphinIni 'Main Stick/Left = `Axis 0-`' 'Main Stick/Left = `Left X-`'
#sedFile $controllerDolphinIni 'Main Stick/Right = `Axis 0+`' 'Main Stick/Right = `Left X+`'
#sedFile $controllerDolphinIni 'C-Stick/Up = `Axis 4-`' 'C-Stick/Up = `Right Y+`'
#sedFile $controllerDolphinIni 'C-Stick/Down = `Axis 4+`' 'C-Stick/Down = `Right Y-`'
#sedFile $controllerDolphinIni 'C-Stick/Left = `Axis 3-`' 'C-Stick/Left = `Right X-`'
#sedFile $controllerDolphinIni 'C-Stick/Right = `Axis 3+`' 'C-Stick/Right = `Right X+`'
#sedFile $controllerDolphinIni 'Triggers/L = `Full Axis 2+`' 'Triggers/L = `Shoulder L`'
#sedFile $controllerDolphinIni 'Triggers/R = `Full Axis 5+`' 'Triggers/R = `Shoulder R`'
#sedFile $controllerDolphinIni 'Triggers/L-Analog = `Full Axis 2+`' 'Triggers/L-Analog = `Trigger L`'
#sedFile $controllerDolphinIni 'Triggers/R-Analog = `Full Axis 5+`' 'Triggers/R-Analog = `Trigger R`'
#sedFile $controllerDolphinIni 'D-Pad/Up = `Axis 7-`' 'D-Pad/Up = `Pad N`'
#sedFile $controllerDolphinIni 'D-Pad/Down = `Axis 7+`' 'D-Pad/Down = `Pad S`'
#sedFile $controllerDolphinIni 'D-Pad/Left = `Axis 6-`' 'D-Pad/Left = `Pad W`'
#sedFile $controllerDolphinIni 'D-Pad/Right = `Axis 6+`' 'D-Pad/Right = `Pad E`'
#
#Dolphin Wii
#sedFile $controllerDolphinWiiIni 'evdev/0/Microsoft X-Box 360 pad 0' 'XInput/0/Gamepad'
#sedFile $controllerDolphinWiiIni 'Buttons/A = SOUTH' 'Buttons/A = Button B'
#sedFile $controllerDolphinWiiIni 'Buttons/B = EAST' 'Buttons/B = Button A'
#sedFile $controllerDolphinWiiIni 'Buttons/1 = NORTH' 'Buttons/X = Button Y'
#sedFile $controllerDolphinWiiIni 'Buttons/2 = WEST' 'Buttons/Y = Button X'
#sedFile $controllerDolphinWiiIni 'Buttons/- = SELECT' 'Buttons/- = Select'
#sedFile $controllerDolphinWiiIni 'Buttons/+ = START' 'Buttons/+ = Start'
#sedFile $controllerDolphinWiiIni 'D-Pad/Up = `Axis 7-`' 'D-Pad/Up = `Pad N`'
#sedFile $controllerDolphinWiiIni 'D-Pad/Down = `Axis 7+`' 'D-Pad/Down = `Pad S`'
#sedFile $controllerDolphinWiiIni 'D-Pad/Left = `Axis 6-`' 'D-Pad/Left = `Pad W`'
#sedFile $controllerDolphinWiiIni 'D-Pad/Right = `Axis 6+`' 'D-Pad/Right = `Pad E`'
#sedFile $controllerDolphinWiiIni 'Shake/Z = TL' 'Shake/Z = Shoulder L'
#sedFile $controllerDolphinWiiIni 'IR/Up = `Axis 4-`' 'IR/Up = `Right Y+`'
#sedFile $controllerDolphinWiiIni 'IR/Down = `Axis 4+`' 'IR/Down = `Right Y-`'
#sedFile $controllerDolphinWiiIni 'IR/Left = `Axis 3-`' 'IR/Left = `Right X-`'
#sedFile $controllerDolphinWiiIni 'IR/Right = `Axis 3+`' 'IR/Right = `Right X+`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Buttons/C = `Full Axis 5+`' 'Nunchuk/Buttons/C = `Trigger L`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Buttons/Z = `Full Axis 2+`' 'Nunchuk/Buttons/Z = `Trigger R`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Up = `Axis 1-`' 'Nunchuk/Stick/Up = `Left Y+`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Down = `Axis 1+`' 'Nunchuk/Stick/Down = `Left Y-`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Left = `Axis 0-`' 'Nunchuk/Stick/Left = `Left X-`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Right = `Axis 0+`' 'Nunchuk/Stick/Right = `Left X+`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Shake/Z = TR' 'Nunchuk/Shake/Z = TR'



Write-Host "All done!" -ForegroundColor green -BackgroundColor black


waitForUser