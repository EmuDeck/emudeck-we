function createLauncher($ps1) {

  mkdir "$toolsPath\launchers\srm" -ErrorAction SilentlyContinue
  mkdir "$toolsPath\launchers\esde" -ErrorAction SilentlyContinue
  mkdir "$toolsPath\launchers\pegasus" -ErrorAction SilentlyContinue


  $SourceFilePath = "$env:APPDATA\EmuDeck\backend\tools\launchers\$ps1.ps1"
  $ShortcutPathPs1 = "$toolsPath\launchers\$ps1.ps1"
  Copy-Item -Path $SourceFilePath -Destination $ShortcutPathPs1 -Force -ErrorAction SilentlyContinue

  # Generamos un .bat que envuelve al .ps1. El acceso directo apunta a este .bat
  # en lugar de a powershell.exe directamente, así Windows no lo oculta del menú de inicio.
  $ShortcutPathBat = "$toolsPath\launchers\$ps1.bat"
  $batContent = "@echo off`r`nstart """" /min powershell.exe -ExecutionPolicy Bypass -File ""$ShortcutPathPs1"""
  Set-Content -Path $ShortcutPathBat -Value $batContent -Encoding ASCII -Force -ErrorAction SilentlyContinue

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
  $TargetPath = $ShortcutPathBat
  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
  $Shortcut.TargetPath = $TargetPath
  $Shortcut.WorkingDirectory = "$toolsPath\launchers"
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
