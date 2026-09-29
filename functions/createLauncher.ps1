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

  # Notificamos a la shell de Windows para que reindexe el menú de inicio,
  # si no, los accesos recién creados no aparecen hasta reiniciar el explorador.
  try {
    if (-not ("EmuDeck.Shell" -as [type])) {
      Add-Type -Namespace EmuDeck -Name Shell -MemberDefinition @"
[System.Runtime.InteropServices.DllImport("shell32.dll")]
public static extern void SHChangeNotify(int wEventId, uint uFlags, System.IntPtr dwItem1, System.IntPtr dwItem2);
"@ -ErrorAction SilentlyContinue
    }
    # SHCNE_ASSOCCHANGED (0x08000000), SHCNF_IDLIST (0x0000)
    [EmuDeck.Shell]::SHChangeNotify(0x08000000, 0x0000, [System.IntPtr]::Zero, [System.IntPtr]::Zero)
  } catch {
    Write-Host "SHChangeNotify no disponible, el menú de inicio se refrescará al reiniciar el explorador."
  }
}
