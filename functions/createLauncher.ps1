
function createLauncher($name, $exe){
  $SourceFilePath = -join($EmulationPath,'tools\EmulationStation-DE\Emulators\',$name,'\',$exe,'.exe')
  $ShortcutPath = -join($EmulationPath,'tools\launchers\',$exe,'.lnk')
  mkdir 'saves\duckstation' -ErrorAction SilentlyContinue
  mkdir $SourceFilePath -ErrorAction SilentlyContinue
  createLink $SourceFilePath $ShortcutPath
}