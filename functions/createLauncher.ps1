function createLauncher($ps1) {

  mkdir "$toolsPath\launchers\srm" -ErrorAction SilentlyContinue
  mkdir "$toolsPath\launchers\esde" -ErrorAction SilentlyContinue
  mkdir "$toolsPath\launchers\pegasus" -ErrorAction SilentlyContinue


  $SourceFilePath = "$env:APPDATA\EmuDeck\backend\tools\launchers\$ps1.ps1"
  $ShortcutPathPs1 = "$toolsPath\launchers\$ps1.ps1"
  Copy-Item -Path $SourceFilePath -Destination $ShortcutPathPs1 -Force -ErrorAction SilentlyContinue

  $name = $ps1

  if ($name -like "*EmulationStationDE*") {
    $name = "EmulationStationDE"
  }
  if ($name -like "*steamrommanager*") {
    $name = "SteamRomManager"
  }

  if ($name -like "*pegasus-frontend*") {
	  $name = "Pegasus"
	}

  mkdir "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\" -ErrorAction SilentlyContinue
  $ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\$name.lnk"
  $TargetPath = "powershell.exe"
  $Arguments = "-ExecutionPolicy Bypass -File $ShortcutPathPs1"
  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
  $Shortcut.TargetPath = $TargetPath
  $Shortcut.Arguments = $Arguments
  $Shortcut.WindowStyle = 7

  if ($name -eq "EmulationStationDE") {
    $Shortcut.IconLocation = "$env:APPDATA\EmuDeck\backend\tools\launchers\icons\$name.ico"
  } elseif ($name -eq "SteamRomManager") {
    $Shortcut.IconLocation = "$env:APPDATA\EmuDeck\backend\tools\launchers\icons\$name.ico"
 } elseif ($name -eq "Pegasus") {
 	$Shortcut.IconLocation = "$env:APPDATA\EmuDeck\backend\tools\launchers\icons\$name.ico"
  }else{
    $Shortcut.IconLocation = "$env:APPDATA\EmuDeck\backend\tools\launchers\icons\$ps1.ico"
  }

  $Shortcut.Save()
}
