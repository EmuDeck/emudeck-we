

function setSettinginFile($keySetting){
	. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"
	$keySetting | Out-File -FilePath "$env:APPDATA/emudeck/settings.ps1" -Append
	Write-Output "Added $keySetting to settings.ps1"
	#Start-Sleep -Seconds 1
}

function storePatreonToken($token){
	. "$env:APPDATA\emudeck\settings.ps1" -ErrorAction SilentlyContinue
	mkdir "$savesPath" -ErrorAction SilentlyContinue
	$token | Set-Content -Path "$savesPath/.token" -Encoding UTF8
	if (-not [string]::IsNullOrWhiteSpace($cloud_sync_bin)) {
		if (Test-Path "$cloud_sync_bin") {
			& $cloud_sync_bin --progress copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$savesPath/.token" "$cloud_sync_provider`:$cs_user`Emudeck\saves\.token"
		}
	}
}

function JSONtoPS1(){

	$mutex = new-object System.Threading.Mutex $false,'EmuDeckSettingsJSONParse'
	$mutex.WaitOne() > $null

	'' | Out-File -FilePath "$env:APPDATA/emudeck/settings.ps1"
	$myJson = Get-Content "$env:USERPROFILE/AppData/Roaming/EmuDeck/settings.json" -Raw | ConvertFrom-Json

	#Default settings for all systems
	$SetupRA = $myJson.overwriteConfigEmus.ra.status
	$SetupDolphin= $myJson.overwriteConfigEmus.dolphin.status
	$SetupPCSX2= $myJson.overwriteConfigEmus.pcsx2.status
	$SetupRPCS3= $myJson.overwriteConfigEmus.rpcs3.status
	$SetupShadPS4= $myJson.overwriteConfigEmus.shadps4.status
	$SetupYuzu= $myJson.overwriteConfigEmus.yuzu.status
	$SetupCitra= $myJson.overwriteConfigEmus.citra.status
	$SetupLime3DS= $myJson.overwriteConfigEmus.lime3ds.status
	$SetupDuck= $myJson.overwriteConfigEmus.duckstation.status
	$SetupCemu= $myJson.overwriteConfigEmus.cemu.status
	$SetupXenia= $myJson.overwriteConfigEmus.xenia.status
	$SetupRyujinx= $myJson.overwriteConfigEmus.ryujinx.status
	$SetupMAME= $myJson.overwriteConfigEmus.mame.status
	$SetupPrimeHack= $myJson.overwriteConfigEmus.primehack.status
	$SetupPPSSPP= $myJson.overwriteConfigEmus.ppsspp.status
	$SetupXemu= $myJson.overwriteConfigEmus.xemu.status
	$SetupESDE= $myJson.overwriteConfigEmus.esde.status
	$SetupSRM= $myJson.overwriteConfigEmus.srm.status
	$SetupmelonDS= $myJson.overwriteConfigEmus.melonds.status
	$SetupScummVM= $myJson.overwriteConfigEmus.scummvm.status
	$SetupFlycast= $myJson.overwriteConfigEmus.flycast.status
	$SetupVita3K= $myJson.overwriteConfigEmus.vita3k.status
	$SetupMGBA= $myJson.overwriteConfigEmus.mgba.status
	$SetupBigPEmu= $myJson.overwriteConfigEmus.bigpemu.status
	$SetupPegasus= $myJson.overwriteConfigEmus.pegasus.status
	$mode= $myJson.mode
	$SetupSupermodel= $myJson.overwriteConfigEmus.supermodel.status
	$SetupModel2= $myJson.overwriteConfigEmus.model2.status

	setSettinginFile("`$mode=`"$mode`"")
	setSettinginFile("`$doSetupRA=`"$SetupRA`"")
	setSettinginFile("`$doSetupDolphin=`"$SetupDolphin`"")
	setSettinginFile("`$doSetupPCSX2=`"$SetupPCSX2`"")
	setSettinginFile("`$doSetupRPCS3=`"$SetupRPCS3`"")
	setSettinginFile("`$doSetupShadPS4=`"$SetupShadPS4`"")
	setSettinginFile("`$doSetupYuzu=`"$SetupYuzu`"")
	setSettinginFile("`$doSetupCitra=`"$SetupCitra`"")
	setSettinginFile("`$doSetupLime3DS=`"$SetupLime3DS`"")
	setSettinginFile("`$doSetupDuck=`"$SetupDuck`"")
	setSettinginFile("`$doSetupCemu=`"$SetupCemu`"")
	setSettinginFile("`$doSetupXenia=`"$SetupXenia`"")
	setSettinginFile("`$doSetupRyujinx=`"$SetupRyujinx`"")
	setSettinginFile("`$doSetupMAME=`"$SetupMAME`"")
	setSettinginFile("`$doSetupPrimeHack=`"$SetupPrimeHack`"")
	setSettinginFile("`$doSetupPPSSPP=`"$SetupPPSSPP`"")
	setSettinginFile("`$doSetupXemu=`"$SetupXemu`"")
	setSettinginFile("`$doSetupSRM=`"$SetupSRM`"")
	setSettinginFile("`$doSetupESDE=`"$SetupESDE`"")
	setSettinginFile("`$doSetupmelonDS=`"$SetupmelonDS`"")
	setSettinginFile("`$doSetupScummVM=`"$SetupScummVM`"")
	setSettinginFile("`$doSetupFlycast=`"$SetupFlycast`"")
	setSettinginFile("`$doSetupVita3K=`"$SetupVita3K`"")
	setSettinginFile("`$doSetupMGBA=`"$SetupMGBA`"")
	setSettinginFile("`$doSetupPegasus=`"$SetupPegasus`"")
	setSettinginFile("`$doSetupBigPEmu=`"$SetupBigPEmu`"")
	setSettinginFile("`$doSetupSupermodel=`"$SetupSupermodel`"")
	setSettinginFile("`$doSetupModel2=`"$SetupModel2`"")


	#Install all systems by default
	$InstallRA = $myJson.installEmus.ra.status
	$InstallDolphin= $myJson.installEmus.dolphin.status
	$InstallPCSX2= $myJson.installEmus.pcsx2.status
	$InstallRPCS3= $myJson.installEmus.rpcs3.status
	$InstallShadPS4= $myJson.installEmus.shadps4.status
	$InstallYuzu= $myJson.installEmus.yuzu.status
	$InstallCitra= $myJson.installEmus.citra.status
	$InstallLime3DS= $myJson.installEmus.lime3ds.status
	$InstallDuck= $myJson.installEmus.duckstation.status
	$InstallCemu= $myJson.installEmus.cemu.status
	$InstallXenia= $myJson.installEmus.xenia.status
	$InstallRyujinx= $myJson.installEmus.ryujinx.status
	$InstallMAME= $myJson.installEmus.mame.status
	$InstallPrimeHack= $myJson.installEmus.primehack.status
	$InstallPPSSPP= $myJson.installEmus.ppsspp.status
	$InstallXemu= $myJson.installEmus.xemu.status
	$InstallmelonDS= $myJson.installEmus.melonDS.status
	$InstallScummVM= $myJson.installEmus.scummvm.status
	$InstallFlycast= $myJson.installEmus.flycast.status
	$InstallVita3K= $myJson.installEmus.vita3k.status
	$InstallMGBA= $myJson.installEmus.mgba.status
	$InstallBigPEmu = $myJson.installEmus.bigpemu.status
	$InstallSupermodel = $myJson.installEmus.supermodel.status
	$InstallModel2 = $myJson.installEmus.model2.status


	#Frontends
	$InstallESDE= $myJson.installFrontends.esde.status
	$InstallPegasus= $myJson.installFrontends.pegasus.status
	$InstallSRM= $myJson.installFrontends.steam.status

	setSettinginFile("`$doInstallRA=`"$InstallRA`"")
	setSettinginFile("`$doInstallDolphin=`"$InstallDolphin`"")
	setSettinginFile("`$doInstallPCSX2=`"$InstallPCSX2`"")
	setSettinginFile("`$doInstallRPCS3=`"$InstallRPCS3`"")
	setSettinginFile("`$doInstallShadPS4=`"$InstallShadPS4`"")
	setSettinginFile("`$doInstallYuzu=`"$InstallYuzu`"")
	setSettinginFile("`$doInstallCitra=`"$InstallCitra`"")
	setSettinginFile("`$doInstallLime3DS=`"$InstallLime3DS`"")
	setSettinginFile("`$doInstallDuck=`"$InstallDuck`"")
	setSettinginFile("`$doInstallCemu=`"$InstallCemu`"")
	setSettinginFile("`$doInstallXenia=`"$InstallXenia`"")
	setSettinginFile("`$doInstallRyujinx=`"$InstallRyujinx`"")
	setSettinginFile("`$doInstallMAME=`"$InstallMAME`"")
	setSettinginFile("`$doInstallPrimeHack=`"$InstallPrimeHack`"")
	setSettinginFile("`$doInstallPPSSPP=`"$InstallPPSSPP`"")
	setSettinginFile("`$doInstallXemu=`"$InstallXemu`"")
	setSettinginFile("`$doInstallSRM=`"$InstallSRM`"")
	setSettinginFile("`$doInstallmelonDS=`"$InstallmelonDS`"")
	setSettinginFile("`$doInstallScummVM=`"$InstallScummVM`"")
	setSettinginFile("`$doInstallFlycast=`"$InstallFlycast`"")
	setSettinginFile("`$doInstallVita3K=`"$InstallVita3K`"")
	setSettinginFile("`$doInstallMGBA=`"$InstallMGBA`"")
	setSettinginFile("`$doInstallBigPEmu=`"$InstallBigPEmu`"")
	setSettinginFile("`$doInstallSupermodel=`"$InstallSupermodel`"")
	setSettinginFile("`$doInstallModel2=`"$InstallModel2`"")



	#Frontends
	setSettinginFile("`$doInstallPegasus=`"$InstallPegasus`"")
	setSettinginFile("`$doInstallESDE=`"$InstallESDE`"")
	setSettinginFile("`$steamAsFrontend=`"$steamAsFrontend`"")


	$RABezels=$myJson.bezels
	$RAautoSave=$myJson.autosave

	#Default RetroArch configuration
	setSettinginFile("`$RABezels=`"$RABezels`"")
	setSettinginFile("`$RAautoSave=`"$RAautoSave`"")

	#Default installation folders

	$globPath=$myJson.storagePath
	$globPath=$globPath.replace('\','')
	$globPath= $globPath -replace "`n","" -replace "`r",""

	$driveInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$globPath'"

	if ($driveInfo) {
		if ($driveInfo.DriveType -eq 4) {
			$VolumenName=$driveInfo.ProviderName
			setSettinginFile('$networkInstallation="true"')
			setSettinginFile("`$VolName=`"$VolumenName`"")
			setSettinginFile('$testdrive=New-PSDrive -Name "'+$globPath[0]+'" -PSProvider FileSystem -Root "$VolName"')
			setSettinginFile('$emulationPath=$testdrive.ToString() + ":\Emulation"')
			setSettinginFile('$romsPath=$testdrive.ToString() + ":\Emulation\roms"')
			setSettinginFile('$toolsPath=$testdrive.ToString() + ":\Emulation\tools"')
			setSettinginFile('$biosPath=$testdrive.ToString() + ":\Emulation\bios"')
			setSettinginFile('$savesPath=$testdrive.ToString() + ":\Emulation\saves"')
			setSettinginFile('$storagePath=$testdrive.ToString() + ":\Emulation\storage"')
			setSettinginFile('$ESDEscrapData=$testdrive.ToString() + ":\Emulation\tools\downloaded_media"')


		} else {
			setSettinginFile('$networkInstallation="false"')
			setSettinginFile("`$emulationPath=`"$globPath\Emulation`"")
			setSettinginFile("`$romsPath=`"$globPath\Emulation\roms`"")
			setSettinginFile("`$toolsPath=`"$globPath\Emulation\tools`"")
			setSettinginFile("`$biosPath=`"$globPath\Emulation\bios`"")
			setSettinginFile("`$savesPath=`"$globPath\Emulation\saves`"")
			setSettinginFile("`$storagePath=`"$globPath\Emulation\storage`"")
			setSettinginFile("`$ESDEscrapData=`"$globPath\Emulation\tools\downloaded_media`"")


		}
	} else {
		setSettinginFile("`$emulationPath=`"$globPath\Emulation`"")
		setSettinginFile("`$romsPath=`"$globPath\Emulation\roms`"")
		setSettinginFile("`$toolsPath=`"$globPath\Emulation\tools`"")
		setSettinginFile("`$biosPath=`"$globPath\Emulation\bios`"")
		setSettinginFile("`$savesPath=`"$globPath\Emulation\saves`"")
		setSettinginFile("`$storagePath=`"$globPath\Emulation\storage`"")
		setSettinginFile("`$ESDEscrapData=`"$globPath\Emulation\tools\downloaded_media`"")

	}




	#Default ESDE Theme
	$esdeThemeUrl=$myJson.themeESDE[0]
	$esdeThemeName=$myJson.themeESDE[1]
	setSettinginFile("`$esdeThemeUrl=`"$esdeThemeUrl`"")
	setSettinginFile("`$esdeThemeName=`"$esdeThemeName`"")

	#Default Pegasus Theme
	$pegasusThemeUrl=$myJson.themePegasus[0]
	$pegasusThemeName=$myJson.themePegasus[1]
	setSettinginFile("`$pegasusThemeUrl=`"$pegasusThemeUrl`"")
	setSettinginFile("`$pegasusThemeName=`"$pegasusThemeName`"")

	#RetroAchiviements
	$achievementsUser=$myJson.achievements.user
	$achievementsUserToken=$myJson.achievements.token
	$achievementsHardcore=$myJson.achievements.hardcore
	setSettinginFile("`$achievementsUser=`"$achievementsUser`"")
	setSettinginFile("`$achievementsUserToken=`"$achievementsUserToken`"")
	setSettinginFile("`$achievementsHardcore=`"$achievementsHardcore`"")

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
	setSettinginFile("`$rpcs3Resolution=`"$rpcs3Resolution`"")
	setSettinginFile("`$citraResolution=`"$citraResolution`"")
	setSettinginFile("`$xemuResolution=`"$xemuResolution`"")
	setSettinginFile("`$xeniaResolution=`"$xeniaResolution`"")
	setSettinginFile("`$melondsResolution=`"$melondsResolution`"")

	#Emus Parsers
	$emuGBA = $myJson.emulatorAlternative.gba
	$emuMAME = $myJson.emulatorAlternative.mame
	$emuMULTI = $myJson.emulatorAlternative.multiemulator
	$emuN64 = $myJson.emulatorAlternative.n64
	$emuNDS = $myJson.emulatorAlternative.nds
	$emuPSP = $myJson.emulatorAlternative.psp
	$emuPSX = $myJson.emulatorAlternative.psx
	$emuDreamcast = $myJson.emulatorAlternative.dreamcast
	$emuSCUMMVM= $myJson.emulatorAlternative.scummvm

	setSettinginFile("`$emuGBA=`"$emuGBA`"")
	setSettinginFile("`$emuMAME=`"$emuMAME`"")
	setSettinginFile("`$emuMULTI=`"$emuMULTI`"")
	setSettinginFile("`$emuN64=`"$emuN64`"")
	setSettinginFile("`$emuNDS=`"$emuNDS`"")
	setSettinginFile("`$emuPSP=`"$emuPSP`"")
	setSettinginFile("`$emuPSX=`"$emuPSX`"")
	setSettinginFile("`$emuDreamcast=`"$emuDreamcast`"")
	setSettinginFile("`$emuSCUMMVM=`"$emuSCUMMVM`"")

	#Android
	$androidStorage = $myJson.android.Storage
	$androidStoragePath = $myJson.android.StoragePath
	$androidInstallRA= $myJson.android.installEmus.ra.status
	$androidInstallDolphin= $myJson.android.installEmus.dolphin.status
	$androidInstallPPSSPP= $myJson.android.installEmus.ppsspp.status
	$androidInstallCitraMMJ= $myJson.android.installEmus.citrammj.status
	$androidInstallLime3DS= $myJson.android.installEmus.lime3ds.status
	$androidInstallNetherSX2= $myJson.android.installEmus.nethersx2.status
	$androidInstallScummVM= $myJson.android.installEmus.scummvm.status

	setSettinginFile("`$androidStorage=`"$androidStorage`"")
	setSettinginFile("`$androidStoragePath=`"$androidStoragePath`"")
	setSettinginFile("`$androidInstallRA=`"$androidInstallRA`"")
	setSettinginFile("`$androidInstallDolphin=`"$androidInstallDolphin`"")
	setSettinginFile("`$androidInstallPPSSPP=`"$androidInstallPPSSPP`"")
	setSettinginFile("`$androidInstallCitraMMJ=`"$androidInstallCitraMMJ`"")
	setSettinginFile("`$androidInstallLime3DS=`"$androidInstallLime3DS`"")
	setSettinginFile("`$androidInstallNetherSX2=`"$androidInstallNetherSX2`"")
	setSettinginFile("`$androidInstallScummVM=`"$androidInstallScummVM`"")

	$androidSetupRA= $myJson.android.overwriteConfigEmus.ra.status
	$androidSetupDolphin= $myJson.android.overwriteConfigEmus.dolphin.status
	$androidSetupPPSSPP= $myJson.android.overwriteConfigEmus.ppsspp.status
	$androidSetupCitraMMJ= $myJson.android.overwriteConfigEmus.citrammj.status
	$androidSetupLime3DS= $myJson.android.overwriteConfigEmus.lime3ds.status
	$androidSetupNetherSX2= $myJson.android.overwriteConfigEmus.nethersx2.status
	$androidSetupScummVM= $myJson.android.overwriteConfigEmus.scummvm.status

	setSettinginFile("`$androidSetupRA=`"$androidSetupRA`"")
	setSettinginFile("`$androidSetupDolphin=`"$androidSetupDolphin`"")
	setSettinginFile("`$androidSetupPPSSPP=`"$androidSetupPPSSPP`"")
	setSettinginFile("`$androidSetupCitraMMJ=`"$androidSetupCitraMMJ`"")
	setSettinginFile("`$androidSetupLime3DS=`"$androidSetupLime3DS`"")
	setSettinginFile("`$androidSetupNetherSX2=`"$androidSetupNetherSX2`"")
	setSettinginFile("`$androidSetupScummVM=`"$androidSetupScummVM`"")


	$androidInstallESDE= $myJson.android.installFrontends.esde.status
	$androidInstallPegasus= $myJson.android.installFrontends.pegasus.status

	setSettinginFile("`$androidInstallESDE=`"$androidInstallESDE`"")
	setSettinginFile("`$androidInstallPegasus=`"$androidInstallPegasus`"")

	$androidRABezels=$myJson.android.bezels
	setSettinginFile("`$androidRABezels=`"$androidRABezels`"")



	$device = $myJson.device
	setSettinginFile("`$device=`"$device`"")

	storePatreonToken $myJson.patreonToken

	Start-Sleep -Seconds 0.5
	((Get-Content -path "$env:APPDATA/emudeck/settings.ps1" -Raw) -replace 'False','false') | Set-Content -Path "$env:APPDATA/emudeck/settings.ps1" -Encoding UTF8

	Start-Sleep -Seconds 0.5
	((Get-Content -path "$env:APPDATA/emudeck/settings.ps1" -Raw) -replace 'True','true') | Set-Content -Path "$env:APPDATA/emudeck/settings.ps1" -Encoding UTF8

	$mutex.ReleaseMutex()


}
