
function createLauncher($exe){
  $SourceFilePath = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\$exe.bat"
  $ShortcutPath = "$toolsPath\launchers\$exe.bat"
  Copy-Item -Path $SourceFilePath -Destination $ShortcutPath 
  
  sedFile $ShortcutPath "C:\Emulation" $emulationPath
}
