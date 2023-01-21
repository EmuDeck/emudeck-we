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
Write-Output "and in there we will download all the Emulators, EmulationStation, Steam Rom Manager and we will create the folder structure for roms, bios and saved games."
Write-Output ""
Write-Output "Before you continue make sure you have WinRar installed"
Write-Output "You can download Winrar from https://www.win-rar.com/download.html"
Write-Output ""
Write-Host "================ Changelog ================" -ForegroundColor green -BackgroundColor black
Write-Output "- FIX: Improved Desktop detection when not it's not located inside the user folder"
Write-Output "- FIX: Launching PS2 games from EmulationStation"
Write-Output "- NEW: Screen Resolution selector: 720P, 1080P, 1440P and 4K"
Write-Output "- NEW: RetroArch Customization: Bezels, Aspect Ratio, Shaders"
Write-Output ""
Write-Host "================ Missing on this release ================" -ForegroundColor red -BackgroundColor black
Write-Output "RPCS3, Xenia, Vita3K, Citra, Ryujinx"
Write-Output "Hotkeys for: Duckstation, Yuzu, Cemu, PPSSPP, PCSX2"
Write-Output "Better support for 16:9 Screens"
Write-Output ""
waitForUser

Clear-Host



$customization=showButtonQuestionImg "1x1.png" 'Easy or Custom Mode' 'Select Easy for a Quick install, or Custom for a more customizable installation.' 'EASY' 'CUSTOM'

if($customization -eq 'CUSTOM'){

	$SRDolphin=showButtonQuestionImg "emulators/dolphin.png" 'Configure GameCube and Wii Resolution' 'This will configure the resolution for the Dolphin Emulator' '720P' '1080P' '1440P' '4K'
	setSetting 'dolphinResolution' "$SRDolphin"
	
	$SRDuckStation=showButtonQuestionImg "emulators/duckstation.png" 'Configure PlayStation Resolution' 'This will configure the resolution for the DuckStation Emulator' '720P' '1080P' '1440P' '4K'
	setSetting 'duckstationResolution' "$SRDuckStation"
	
	$SRPCSX2=showButtonQuestionImg "emulators/pcsx2.png" 'Configure PlayStation 2 Resolution' 'This will configure the resolution for the RPCSX2 Emulator' '720P' '1080P' '1440P' '4K'
	setSetting 'pcsx2Resolution' "$SRPCSX2"
	
	$SRYuzu=showButtonQuestionImg "emulators/yuzu.png" 'Configure Switch Resolution' 'This will configure the resolution for the Yuzu Emulator' '720P' '1080P' '1440P' '4K'
	setSetting 'yuzuResolution' "$SRYuzu"
	
	#Customization Dialogs
	$RABezels=showButtonQuestionImg "bezels.png" 'Configure game bezels' 'You can use our preconfigured bezels to hide the vertical black vars on Retro Games' 'ON' 'OFF'
	if ($RABezels == 'ON'){
		setSetting 'RABezels' "true"
	}else{
		setSetting 'RABezels' "false"
	}
	
	$arSega=showButtonQuestionImg "ar43.png" 'Configure Aspect Ratio for Classic Sega Games' 'Choose your aspect ratio for your Classic Sega Games' '43' '32'
	setSetting 'arSega' "$arSega"
	
	$arSnes=showButtonQuestionImg "ar43snes.png" 'Configure Aspect Ratio  Super NES' 'Choose your aspect ratio for Super Nintendo games' '43' '87'
	setSetting 'arSnes' "$arSnes"
	
	$arClassic3D=showButtonQuestionImg "ar433d.png" 'Configure Aspect Ratio for Classic 3D Games' 'Choose your aspect ratio for Dreamcast and Nintendo 64' '43' '169'
	setSetting 'arClassic3D' "$arClassic3D"
	
	$arDolphin=showButtonQuestionImg "ar43gc.png" 'Configure Aspect Ratio for GameCube' 'Choose your aspect ratio for GameCube games.' '43' '169'
	setSetting 'arDolphin' "$arDolphin"
	
	$RAHandHeldShader=showButtonQuestionImg "lcdon.png" 'Configure LCD Shader Handhelds' 'The LCD Shader simulates the old LCD Matrix screens of handheld systems' 'ON' 'OFF'		
	if ($RABezels == 'ON'){
		setSetting 'RAHandHeldShader' "true"
	}else{
		setSetting 'RAHandHeldShader' "false"
	}
	
	$RAHandClassic2D=showButtonQuestionImg "classic-shader-on.png" 'Configure CRT Shader Classic 2d Games' 'The CRT Shader gives your classic systems a faux retro CRT vibe' 'ON' 'OFF'
	if ($RABezels == 'ON'){
		setSetting 'RAHandClassic2D' "true"
	}else{
		setSetting 'RAHandClassic2D' "false"
	}
	
	$RAHandClassic3D=showButtonQuestionImg "classic-3d-shader-on.png" 'Configure CRT Shader Classic 3d Games' 'The CRT Shader gives your classic systems a faux retro CRT vibe' 'ON' 'OFF'
	if ($RABezels == 'ON'){
		setSetting 'RAHandClassic3D' "true"
	}else{
		setSetting 'RAHandClassic3D' "false"
	}
	
	$RAautoSave=showButtonQuestionImg "1x1.png" 'Configure AutoSave and Autoload' Do you want to automatically save and load your latest state on RetroArch systems' 'ON' 'OFF'
	if ($RABezels == 'ON'){
		setSetting 'RAautoSave' "true"
	}else{
		setSetting 'RAautoSave' "false"
	}
	
}

#ReLoad Settings after customization
. $env:USERPROFILE\EmuDeck\settings.ps1
