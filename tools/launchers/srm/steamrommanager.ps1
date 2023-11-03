. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
$emulatorFile = "$toolsPath/srm.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/EmuScripts/emuDeckRPCS3.ps1"
RPCS3_renameFolders
& $emulatorFile