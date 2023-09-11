function createLauncher($ps1) {
  $SourceFilePath = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\$ps1.ps1"
  $ShortcutPathPs1 = "$toolsPath\launchers\$ps1.ps1"

  # Copiar el archivo .ps1 al directorio de lanzadores
  Copy-Item -Path $SourceFilePath -Destination $ShortcutPathPs1

  # Modificar el archivo .ps1 si es necesario
  # Aquí puedes agregar cualquier código de modificación que sea necesario para el archivo .ps1

  # Crear el acceso directo en el menú de inicio
  $cultureInfo = [System.Globalization.CultureInfo]::CurrentCulture
  $textInfo = $cultureInfo.TextInfo
  $name = $textInfo.ToTitleCase($ps1)

  if ($name -eq "Esde/EmulationStationDE") {
    $name = "EmulationStationDE"
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

  # Configurar el icono (ajusta la ruta al icono según tus necesidades)
  if ($name -eq "EmulationStationDE") {
    $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$name.ico"
  } else {
    $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\tools\launchers\icons\$ps1.ico"
  }

  $Shortcut.Save()
}