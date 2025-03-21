
. "$env:APPDATA\EmuDeck\backend\vars.ps1"

$test=Test-Path -Path "$env:APPDATA\EmuDeck\settings.ps1"
if(-not($test)){
	. "$env:USERPROFILE\EmuDeck\settings.ps1" -ErrorAction SilentlyContinue
}else{
	. "$env:APPDATA\EmuDeck\settings.ps1" -ErrorAction SilentlyContinue
}

if (-not "$emulationPath") {
	$emulationPath = "C:\Emulation"
}
. "$env:APPDATA\EmuDeck\backend\api.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\download.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\downloadCore.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\showNotification.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\moveFromTo.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\copyFromTo.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\waitForUser.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\sedFile.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\createLink.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\createLauncher.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\helperFunctions.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\checkBIOS.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\appImageInit.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\autofix.ps1"

. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckModel2.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckBigPemu.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckCemu.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckAzahar.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckDolphin.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckDuckStation.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckRetroArch.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckRPCS3.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckShadPS4.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckMAME.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckXemu.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckXenia.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckYuzu.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckCitron.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckRyujinx.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckPPSSPP.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckmelonDS.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckmGBA.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckPCSX2QT.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckPrimehack.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckFlycast.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckSuperModel.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckScummVM.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\EmuScripts\emuDeckVita3K.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckESDE.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckPegasus.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckSRM.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckGameMode.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckInstallHomebrewGames.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckSaveSync.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\cloudSyncHealth.ps1"
#. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckNetplay.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckMigration.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\generateGameLists.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckPlugins.ps1"
. "$env:APPDATA\EmuDeck\backend\functions\ToolScripts\emuDeckStore.ps1"

#Android
. "$env:APPDATA\EmuDeck\backend\android\functions\all.ps1"
