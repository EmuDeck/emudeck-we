. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/EmuScripts/emuDeckRPCS3.ps1"
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/ToolScripts/emuDeckSRM.ps1"
SRM_resetLaunchers
RPCS3_renameFolders

$emulatorFile = "$toolsPath/srm.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

& $emulatorFile