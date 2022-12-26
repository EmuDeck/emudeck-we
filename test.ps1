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
#Clear-Host
#We need to pick the HD first thing so we can set the rest of the path variables
$winPath = "C:\"
. .\vars.ps1

Set-Location $emulationPath



### TEST CODE START



### TEST CODE FINNISH

waitForUser