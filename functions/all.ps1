#We add 7z folders to the Path
$env:path = $env:path + ";C:\Program Files\7-zip"
$env:path = $env:path + ";C:\Program Files (x86)\7-zip"

. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\vars.ps1
. $env:USERPROFILE\EmuDeck\settings.ps1
mkdir $emulationPath -ErrorAction SilentlyContinue
mkdir $biosPath -ErrorAction SilentlyContinue
mkdir $toolsPath -ErrorAction SilentlyContinue
mkdir $toolsPath\launchers -ErrorAction SilentlyContinue
mkdir $savesPath -ErrorAction SilentlyContinue
Set-Location $emulationPath
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\showListDialog.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\download.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\downloadCore.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\showNotification.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\moveFromTo.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\copyFromTo.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\waitForUser.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\sedFile.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\createLink.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\createLauncher.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\helperFunctions.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\showButtonQuestionImg.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\showButtonQuestion.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\checkBIOS.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\appImageInit.ps1

. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckCemu.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckCitra.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckDolphin.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckDuckStation.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckPCSX2.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckRetroArch.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckRPCS3.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckTemplate.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckXemu.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckXenia.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckYuzu.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckRyujinx.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckPPSSPP.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckmelonDS.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckmGBA.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckPCSX2QT.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckPrimehack.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\EmuScripts\emuDeckRGM.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\ToolScripts\emuDeckESDE.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\ToolScripts\emuDeckSRM.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\ToolScripts\emuDeckGameMode.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\ToolScripts\emuDeckInstallHomebrewGames.ps1
. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\ToolScripts\emuDeckSaveSync.ps1