$emulatorFile = "$env:APPDATA/emudeck/EmulationStation-DE/ES-DE.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/EmuScripts/emuDeckRPCS3.ps1"
RPCS3_renameFolders

#Xenia fixes
sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\xenia_canary\xenia_canary.exe</entry>' '<entry>%ESPATH%\Emulators\xenia\xenia_canary.exe</entry>'

if($args){
	$formattedArgs = $args | ForEach-Object { '"' + $_ + '"' }
}
emulatorInit $scriptFileName $emulatorFile ($formattedArgs -join ' ')
