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
. .\functions\createLauncher.ps1
. $env:USERPROFILE\EmuDeck\backend\functions\helperFunctions.ps1
. .\functions\showButtonQuestionImg.ps1

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
. .\functions\EmuScripts\emuDeckRyujinx.ps1
. .\functions\EmuScripts\emuDeckPPSSPP.ps1
. .\functions\ToolScripts\emuDeckESDE.ps1
. .\functions\ToolScripts\emuDeckSRM.ps1



#
# Variables
#
Clear-Host
. $env:USERPROFILE\EmuDeck\backend\vars.ps1

cp "$env:USERPROFILE\EmuDeck\backend\settings.ps1" "$env:USERPROFILE\EmuDeck\settings.ps1"


$winPath='E:'
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
Set-Location $emulationPath


### TEST CODE START

$RABezels=showButtonQuestionImg "bezels.png" 'Configure Resolution' 'You can use our preconfigured bezels to hide the vertical black vars on Retro Games' '720P' '1080P' '1440P' '4K' '720P' '1080P' '1440P' '4K'
echo $RABezels
### TEST CODE FINNISH

waitForUser