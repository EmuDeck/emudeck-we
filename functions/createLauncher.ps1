function createLauncher($ps1) {
  $SourceFilePath = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\$ps1.ps1"
  $ShortcutPathPs1 = "$toolsPath\launchers\$ps1.ps1"
  Copy-Item -Path $SourceFilePath -Destination $ShortcutPathPs1 -Force -ErrorAction SilentlyContinue

  $cultureInfo = [System.Globalization.CultureInfo]::CurrentCulture
  $textInfo = $cultureInfo.TextInfo
  $name = $textInfo.ToTitleCase($ps1)

  if ($name -like "*EmulationStationDE*") {
    $name = "EmulationStationDE"
    mkdir "$toolsPath\launchers\esde"
  }
  if ($name -like "*steamrommanager*") {
    $name = "SteamRomManager"
    mkdir "$toolsPath\launchers\srm"
  }

  mkdir "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\" -ErrorAction SilentlyContinue
  $ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\$name.lnk"
  $TargetPath = "powershell.exe"  # Ruta al ejecutable de PowerShell
  $Arguments = "-ExecutionPolicy Bypass -File $ShortcutPathPs1"  # Argumentos para ejecutar el archivo .ps1
  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
  $Shortcut.TargetPath = $TargetPath
  $Shortcut.Arguments = $Arguments
  $Shortcut.WindowStyle = 7

  if ($name -eq "EmulationStationDE") {
    $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$name.ico"
  } elseif ($name -eq "steamrommanager") {
    $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$name.ico"
  }else{
    $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$ps1.ico"
  }

  $Shortcut.Save()
}
