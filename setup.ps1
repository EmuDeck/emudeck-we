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

#$Host.UI.RawUI.WindowTitle = "EmuDeck Windows Edition Alpha Installer";

. $env:USERPROFILE\emudeck\settings.ps1

#
# Functions
#

. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1

#
# Variables
#
##Clear-Host
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\vars.ps1

#cp "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\settings.ps1" "$env:USERPROFILE\emudeck\settings.ps1"

#
# UI & Settings creation
#
#. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\ui.ps1

#
# Installation
#



mkdir $emulationPath -ErrorAction SilentlyContinue
Set-Location $emulationPath
mkdir $biosPath -ErrorAction SilentlyContinue
mkdir $toolsPath -ErrorAction SilentlyContinue
mkdir $savesPath -ErrorAction SilentlyContinue
mkdir "$toolsPath\launchers" -ErrorAction SilentlyContinue
#Clear-Host

Write-Output "Installing, please stand by..."
Write-Output ""

copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\roms" "roms"

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

setMSG 'Configuring Emulators'


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



createLink "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\update.bat" "$desktop_path\EmuDeck - Update Beta.lnk"


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


#RetroAchievments
if ( "$doSetupRA" -eq "true" ){
	RetroArch_retroAchievementsSetLogin
	if  ("$doRASignIn" -eq "true" ){
		#RetroArch_retroAchievementsPromptLogin
		#RetroArch_retroAchievementsSetLogin
		RetroArch_retroAchievementsOn
	}
	
	if ( "$doRAEnable" -eq "true" ){
		RetroArch_retroAchievementsOn
	}
	
	if ( "$achievementsHardcore" -eq "true" ){
		RetroArch_retroAchievementsHardCoreOn
	}else{
		RetroArch_retroAchievementsHardCoreOff
	}
}

if  ("$doRASignIn" -eq "true" ){
	DuckStation_retroAchievementsSetLogin
	PCSX2_retroAchievementsSetLogin
}

#AR, Bezels and Shaders
#RA Bezels	
if ( "$doSetupRA" -eq "true" ){
	RetroArch_setBezels #needs to change
	
	#RA AutoSave	
	if ( "$RAautoSave" -eq "true" ){
		RetroArch_autoSaveOn
	}else{
		RetroArch_autoSaveOff
	}	
}

#
#New Shaders
#Moved before widescreen, so widescreen disabled if needed.
#	
if ( "$doSetupRA" -eq "true" ){
	RetroArch_setShadersCRT
	RetroArch_setShaders3DCRT
	RetroArch_setShadersMAT
}

	#
	#New Aspect Ratios
	#
	
	#Sega Games
		#Master System
		#Genesis
		#Sega CD
		#Sega 32X
	if ( "$doSetupRA" -eq "true" ){
		switch ($arSega){
		  32 {	 
			RetroArch_mastersystem_ar32;
			RetroArch_genesis_ar32;
			RetroArch_segacd_ar32
			RetroArch_sega32x_ar32	
		  }			
		  43 {
			RetroArch_mastersystem_ar43
			RetroArch_genesis_ar43
			RetroArch_segacd_ar43
			RetroArch_sega32x_ar43
			if ( "$RABezels" -eq "true"){
				if ("$doSetupRA" -eq "true" ){
				  RetroArch_mastersystem_bezelOn
				  RetroArch_genesis_bezelOn
				  RetroArch_segacd_bezelOn
				  RetroArch_sega32x_bezelOn
				}
			}
		  }
		}
		
		#Snes and NES
		switch ($arSnes){
		  87{
			RetroArch_snes_ar87
			RetroArch_nes_ar87
		  }
		  43{
			RetroArch_snes_ar43
			RetroArch_nes_ar43
			if ( "$RABezels" -eq "true" ){
				if( "$doSetupRA" -eq "true" ){
					RetroArch_snes_bezelOn
				}	
			}
		  }		  
		}
	}
	# Classic 3D Games
		#Dreamcast
		#PSX
		#Nintendo 64
		#Saturn
		#Xbox
	if ( "$arClassic3D" -eq 169 ){		
		if ( "$doSetupRA" -eq "true" ){	
			RetroArch_Beetle_PSX_HW_wideScreenOn
			RetroArch_Flycast_wideScreenOn			
			RetroArch_dreamcast_bezelOff
			RetroArch_psx_bezelOff
			RetroArch_n64_wideScreenOn
			RetroArch_SwanStation_wideScreenOn
		}
		if ( "$doSetupDuck" -eq "true" ){
			DuckStation_wideScreenOn
		}
		if ( "$doSetupXemu" -eq "true" ){
			Xemu_wideScreenOn
		}

	}else{
		if ( "$doSetupRA" -eq "true" ){
			#"SET 4:3"
			RetroArch_Flycast_wideScreenOff
			RetroArch_n64_wideScreenOff
			RetroArch_Beetle_PSX_HW_wideScreenOff
			RetroArch_SwanStation_wideScreenOff
		}
		if ( "$doSetupDuck" -eq "true" ){
			DuckStation_wideScreenOff
		}
		if ( "$doSetupXemu" -eq "true" ){
			Xemu_wideScreenOff
		}
		#"Bezels on"
		if ( "$RABezels" -eq "true" ){
			if( "$doSetupRA" -eq "true" ){
			RetroArch_dreamcast_bezelOn			
			RetroArch_n64_bezelOn
			RetroArch_psx_bezelOn
			}
		}			
	}
	
	# GameCube
	if ( "$doSetupDolphin" -eq "true" ){
		if ( "$arDolphin" -eq 169 ){	
			Dolphin_wideScreenOn
		}else{
			Dolphin_wideScreenOff
		}
	}

#Write-Output ""
#Write-Host "================ Installation Complete! ================" -ForegroundColor green -BackgroundColor black
#Write-Output ""
#Write-Output "Copy your roms to $emulationPath\roms"
#Write-Output "Copy all your bios inside $emulationPath\bios"
#Write-Output "Copy your Yuzu Firmware inside $emulationPath\bios\yuzu\firmware"
#Write-Output "Copy your Yuzu Keys inside $emulationPath\bios\yuzu\keys"
#Write-Output ""
#Write-Output ""
#Write-Output "When you are done, press ENTER to open Steam Rom Manager to add your roms, emulators and EmulationStation to Steam"
#Write-Output ""
#waitForUser