
function createLauncher($name, $exe){
  $SourceFilePath = -join($emulationPath,'\tools\EmulationStation-DE\Emulators\',$name,'\',$exe,'.exe')
  $ShortcutPath = -join($emulationPath,'\tools\launchers\',$exe,'.lnk')
  createLink $SourceFilePath $ShortcutPath
}