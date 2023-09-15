

function setSettinginFile($keySetting){		
	$keySetting | Out-File -FilePath "$env:USERPROFILE/EmuDeck/settings.ps1" -Append
	Write-Output "Added $keySetting to settings.ps1"
	#Start-Sleep -Seconds 1
}


function JSONtoPS1(){
	
	$mutex = new-object System.Threading.Mutex $false,'EmuDeckSettingsJSONParse'
	$mutex.WaitOne() > $null
	
	'' | Out-File -FilePath "$env:USERPROFILE/EmuDeck/settings.ps1"
	$myJson = Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/settings.json -Raw | ConvertFrom-Json 
	
	#Default settings for all systems
	$SetupRA = $myJson.overwriteConfigEmus.ra.status
	$SetupDolphin= $myJson.overwriteConfigEmus.dolphin.status
	$SetupPCSX2= $myJson.overwriteConfigEmus.pcsx2.status
	$SetupRPCS3= $myJson.overwriteConfigEmus.rpcs3.status
	$SetupYuzu= $myJson.overwriteConfigEmus.yuzu.status
	$SetupCitra= $myJson.overwriteConfigEmus.citra.status
	$SetupDuck= $myJson.overwriteConfigEmus.duckstation.status
	$SetupCemu= $myJson.overwriteConfigEmus.cemu.status
	$SetupXenia= $myJson.overwriteConfigEmus.xenia.status
	$SetupRyujinx= $myJson.overwriteConfigEmus.ryujinx.status
	$SetupMAME= $myJson.overwriteConfigEmus.mame.status
	$SetupPrimeHacks= $myJson.overwriteConfigEmus.primehacks.status
	$SetupPPSSPP= $myJson.overwriteConfigEmus.ppsspp.status
	$SetupXemu= $myJson.overwriteConfigEmus.xemu.status
	$SetupESDE= $myJson.overwriteConfigEmus.esde.status
	$SetupSRM= $myJson.overwriteConfigEmus.srm.status
	$SetupmelonDS= $myJson.overwriteConfigEmus.melonDS.status
	
	setSettinginFile("`$doSetupRA=`"$SetupRA`"")
	setSettinginFile("`$doSetupDolphin=`"$SetupDolphin`"")
	setSettinginFile("`$doSetupPCSX2=`"$SetupPCSX2`"")
	setSettinginFile("`$doSetupRPCS3=`"$SetupRPCS3`"")
	setSettinginFile("`$doSetupYuzu=`"$SetupYuzu`"")
	setSettinginFile("`$doSetupCitra=`"$SetupCitra`"")
	setSettinginFile("`$doSetupDuck=`"$SetupDuck`"")
	setSettinginFile("`$doSetupCemu=`"$SetupCemu`"")
	setSettinginFile("`$doSetupXenia=`"$SetupXenia`"")
	setSettinginFile("`$doSetupRyujinx=`"$SetupRyujinx`"")
	setSettinginFile("`$doSetupMAME=`"$SetupMAME`"")
	setSettinginFile("`$doSetupPrimeHacks=`"$SetupPrimeHacks`"")
	setSettinginFile("`$doSetupPPSSPP=`"$SetupPPSSPP`"")
	setSettinginFile("`$doSetupXemu=`"$SetupXemu`"")
	setSettinginFile("`$doSetupESDE=`"$SetupESDE`"")
	setSettinginFile("`$doSetupSRM=`"$SetupSRM`"")
	setSettinginFile("`$doSetupmelonDS=`"$SetupmelonDS`"")
	
	
	#Install all systems by default
	$InstallRA = $myJson.installEmus.ra.status
	$InstallDolphin= $myJson.installEmus.dolphin.status
	$InstallPCSX2= $myJson.installEmus.pcsx2.status
	$InstallRPCS3= $myJson.installEmus.rpcs3.status
	$InstallYuzu= $myJson.installEmus.yuzu.status
	$InstallCitra= $myJson.installEmus.citra.status
	$InstallDuck= $myJson.installEmus.duckstation.status
	$InstallCemu= $myJson.installEmus.cemu.status
	$InstallXenia= $myJson.installEmus.xenia.status
	$InstallRyujinx= $myJson.installEmus.ryujinx.status
	$InstallMAME= $myJson.installEmus.mame.status
	$InstallPrimeHacks= $myJson.installEmus.primehacks.status
	$InstallPPSSPP= $myJson.installEmus.ppsspp.status
	$InstallXemu= $myJson.installEmus.xemu.status
	$InstallESDE= $myJson.installEmus.esde.status
	$InstallSRM= $myJson.installEmus.srm.status
	$InstallmelonDS= $myJson.installEmus.melonDS.status
	
	setSettinginFile("`$doInstallRA=`"$InstallRA`"")
	setSettinginFile("`$doInstallDolphin=`"$InstallDolphin`"")
	setSettinginFile("`$doInstallPCSX2=`"$InstallPCSX2`"")
	setSettinginFile("`$doInstallRPCS3=`"$InstallRPCS3`"")
	setSettinginFile("`$doInstallYuzu=`"$InstallYuzu`"")
	setSettinginFile("`$doInstallCitra=`"$InstallCitra`"")
	setSettinginFile("`$doInstallDuck=`"$InstallDuck`"")
	setSettinginFile("`$doInstallCemu=`"$InstallCemu`"")
	setSettinginFile("`$doInstallXenia=`"$InstallXenia`"")
	setSettinginFile("`$doInstallRyujinx=`"$InstallRyujinx`"")
	setSettinginFile("`$doInstallMAME=`"$InstallMAME`"")
	setSettinginFile("`$doInstallPrimeHacks=`"$InstallPrimeHacks`"")
	setSettinginFile("`$doInstallPPSSPP=`"$InstallPPSSPP`"")
	setSettinginFile("`$doInstallXemu=`"$InstallXemu`"")
	setSettinginFile("`$doInstallESDE=`"$InstallESDE`"")
	setSettinginFile("`$doInstallSRM=`"$InstallSRM`"")
	setSettinginFile("`$doInstallmelonDS=`"$InstallmelonDS`"")
	
	
	$RABezels=$myJson.bezels
	$RAautoSave=$myJson.autosave
	
	#Default RetroArch configuration 
	setSettinginFile("`$RABezels=`"$RABezels`"")
	setSettinginFile("`$RAautoSave=`"$RAautoSave`"")
	
	#Default installation folders
	
	$globPath=$myJson.storagePath
	$globPath=$globPath.replace('\','')
	$globPath= $globPath -replace "`n","" -replace "`r",""
	
	setSettinginFile("`$emulationPath=`"$globPath\Emulation`"")
	setSettinginFile("`$romsPath=`"$globPath\Emulation\roms`"")
	setSettinginFile("`$toolsPath=`"$globPath\Emulation\tools`"")
	setSettinginFile("`$biosPath=`"$globPath\Emulation\bios`"")
	setSettinginFile("`$savesPath=`"$globPath\Emulation\saves`"")
	setSettinginFile("`$storagePath=`"$globPath\Emulation\storage`"")
	setSettinginFile("`$ESDEscrapData=`"$globPath\Emulation\tools\downloaded_media`"")
	
	#Default ESDE Theme
	$esdeTheme=$myJson.theme
	setSettinginFile("`$esdeTheme=`"$esdeTheme`"")
	
	
	#Advanced settings
	setSettinginFile("`$doRASignIn=`"true`"")
	setSettinginFile("`$doRAEnable=`"true`"")
	
	$arClassic3D = $myJson.ar.classic3d
	$arDolphin = $myJson.ar.dolphin
	$arSega = $myJson.ar.sega
	$arSnes = $myJson.ar.snes
	
	setSettinginFile("`$arClassic3D=`"$arClassic3D`"")
	setSettinginFile("`$arDolphin=`"$arDolphin`"")
	setSettinginFile("`$arSega=`"$arSega`"")
	setSettinginFile("`$arSnes=`"$arSnes`"")
	
	$RAHandClassic2D = $myJson.shaders.classic
	$RAHandClassic3D = $myJson.shaders.classic3d
	$RAHandHeldShader = $myJson.shaders.handhelds
	
	setSettinginFile("`$RAHandClassic2D=`"$RAHandClassic2D`"")
	setSettinginFile("`$RAHandClassic3D=`"$RAHandClassic3D`"")
	setSettinginFile("`$RAHandHeldShader=`"$RAHandHeldShader`"")
	
	$cloud_sync_provider = $myJson.cloudSync
	setSettinginFile("`$cloud_sync_provider=`"$cloud_sync_provider`"")
	setSettinginFile("`$rclone_provider=`"$cloud_sync_provider`"")
	
	$cloudSyncStatus = $myJson.cloudSyncStatus
	setSettinginFile("`$cloud_sync_status=`"$cloudSyncStatus`"")	
	
	$dolphinResolution = $myJson.resolutions.dolphin
	$duckstationResolution = $myJson.resolutions.duckstation
	$pcsx2Resolution = $myJson.resolutions.pcsx2
	$yuzuResolution = $myJson.resolutions.yuzu
	$ppssppResolution = $myJson.resolutions.ppsspp
	$rpcs3Resolution = $myJson.resolutions.rpcs3
	$citraResolution = $myJson.resolutions.citra
	$xemuResolution = $myJson.resolutions.xemu
	$xeniaResolution = $myJson.resolutions.xenia
	$melondsResolution = $myJson.resolutions.melonds
	
	
	setSettinginFile("`$dolphinResolution=`"$dolphinResolution`"")
	setSettinginFile("`$duckstationResolution=`"$duckstationResolution`"")
	setSettinginFile("`$pcsx2Resolution=`"$pcsx2Resolution`"")
	setSettinginFile("`$yuzuResolution=`"$yuzuResolution`"")
	setSettinginFile("`$ppssppResolution=`"$ppssppResolution`"")
	setSettinginFile("`$rpcs3Resolution=`"$rpcs3Resolution `"")
	setSettinginFile("`$citraResolution=`"$citraResolution `"")
	setSettinginFile("`$xemuResolution=`"$xemuResolution `"")
	setSettinginFile("`$xeniaResolution=`"$xeniaResolution `"")
	setSettinginFile("`$melondsResolution=`"$melondsResolution `"")
		
	#Emus Parsers
	$emuGBA = $myJson.emulatorAlternative.gba
	$emuMAME = $myJson.emulatorAlternative.mame
	$emuMULTI = $myJson.emulatorAlternative.multiemulator
	$emuN64 = $myJson.emulatorAlternative.n64
	$emuNDS = $myJson.emulatorAlternative.nds
	$emuPSP = $myJson.emulatorAlternative.psp
	$emuPSX = $myJson.emulatorAlternative.psx
	
	setSettinginFile("`$emuGBA=`"$emuGBA`"")
	setSettinginFile("`$emuMAME=`"$emuMAME`"")
	setSettinginFile("`$emuMULTI=`"$emuMULTI`"")
	setSettinginFile("`$emuN64=`"$emuN64`"")
	setSettinginFile("`$emuNDS=`"$emuNDS`"")
	setSettinginFile("`$emuPSP=`"$emuPSP`"")
	setSettinginFile("`$emuPSX=`"$emuPSX`"")
	
	
	
	$device = $myJson.device
	setSettinginFile("`$device=`"$device`"")
	
	Start-Sleep -Seconds 0.5
	((Get-Content -path $env:USERPROFILE/EmuDeck/settings.ps1 -Raw) -replace 'False','false') | Set-Content -Path $env:USERPROFILE/EmuDeck/settings.ps1
	
	Start-Sleep -Seconds 0.5
	((Get-Content -path $env:USERPROFILE/EmuDeck/settings.ps1 -Raw) -replace 'True','true') | Set-Content -Path $env:USERPROFILE/EmuDeck/settings.ps1
	
	$mutex.ReleaseMutex()

}