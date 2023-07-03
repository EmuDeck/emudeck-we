function createLauncher($exe){
  $SourceFilePath = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\$exe.bat"
  $ShortcutPath = "$toolsPath\launchers\$exe.bat"
  Copy-Item -Path $SourceFilePath -Destination $ShortcutPath 
  
  sedFile $ShortcutPath "ESDEPATH" "$userFolder\EmuDeck\EmulationStation-DE"
 
  #Windows Start Menu
  $cultureInfo = [System.Globalization.CultureInfo]::CurrentCulture
  $textInfo = $cultureInfo.TextInfo
  $name = $textInfo.ToTitleCase($exe)  
  
  if ($name -eq "Esde/EmulationStationDE"){
    $name = "EmulationStationDE"
   }  
  
  mkdir "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\" -ErrorAction SilentlyContinue
  $ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\$name.lnk"
  $TargetPath = "$toolsPath\launchers\$exe.bat" 
  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
  if ($name -eq "EmulationStationDE"){
     $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$name.ico"
  }else{
    $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$exe.ico"
  }

  $Shortcut.TargetPath = $TargetPath
  $Shortcut.WindowStyle = 7 
  $Shortcut.Save()
  sedFile $ShortcutPath "ESDEPATH" "$userFolder\EmuDeck\EmulationStation-DE"
 
}