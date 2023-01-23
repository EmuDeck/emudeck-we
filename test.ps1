#We add Winrar folders to the Path
$env:path = $env:path + ";C:\Program Files\WinRaR"
$env:path = $env:path + ";C:\Program Files (x86)\WinRaR"

$Host.UI.RawUI.WindowTitle = "EmuDeck Windows Edition Alpha Installer";

#
# Functions
#

. $env:USERPROFILE\EmuDeck\backend\functions\all.ps1

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

echo "testing"

### TEST CODE FINNISH

waitForUser