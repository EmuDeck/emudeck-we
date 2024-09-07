function cloudSyncHealth(){

  Write-Host "<div class='is-hidden'>"
  $watcherStatus=1
  $upload=1
  $download=1

  $result = yesNoDialog -TitleText "CloudSync Health" -MessageText "Do you use EmulationStation to launch your games?" -OKButtonText "Yes" -CancelButtonText "No"

  if ($result -eq "OKButton") {
	#Launching ESDE
	Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$toolsPath/launchers/esde/EmulationStationDE.ps1`" "

  } else {
	$kill = "RETROARCH"
	Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$toolsPath/launchers/retroarch.ps1`" "

  }

  if ($kill -eq "RETROARCH") {
	while (-not (Get-Process -Name "retroarch" -ErrorAction SilentlyContinue)) {
		echo "waiting for RA to open"
		Start-Sleep -Seconds 2
	}
  }else{
	while (-not (Get-Process -Name "ES-DE" -ErrorAction SilentlyContinue)) {
		echo "waiting for ESDE to open"
		Start-Sleep -Seconds 2
	}
  }
  Start-Sleep -Seconds 5
  echo "Creating test file"
  echo "testing upload" > "$savesPath/retroarch/test_emudeck.txt"

  while (-not (Get-Process -Name "rclone" -ErrorAction SilentlyContinue)) {
	  echo "waiting for rclone to open"
	  Start-Sleep -Seconds 1
  }

  while (Get-Process -Name "rclone" -ErrorAction SilentlyContinue) {
	  echo "waiting for rclone to finish"
	  Start-Sleep -Seconds 1
  }

  $result = & $cloud_sync_bin lsf "$cloud_sync_provider`:Emudeck/saves/retroarch/" | Select-String "test_emudeck.txt"

  # Evaluar el resultado
  if ($result) {
	  Write-Host "file exists in the cloud. SUCCESS"
	  $upload = 0
  } else {
	  Write-Host "file does not exist in the cloud. FAIL"
  }


  #
  ##Testing Dowmload
  #

 &  "$cloud_sync_bin"  --progress copyto -L --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck/saves/retroarch/test_emudeck.txt" "$savesPath/retroarch/test_emudeck.txt"

  if (Test-Path "$savesPath\retroarch\test_emudeck.txt") {
	  Write-Host "file exists in local. SUCCESS"
	  $download = 0
  } else {
	  Write-Host "file does not exist in local. FAIL"
  }

  # Eliminar los directorios y archivos locales
  Remove-Item -Recurse -Force "$savesPath\.watching"
  Remove-Item -Recurse -Force "$savesPath\retroarch\test_emudeck.txt"

  # Eliminar el archivo remoto
  & $cloud_sync_bin delete "$cloud_sync_provider`:Emudeck/saves/retroarch/test_emudeck.txt"

  # Verificar si se debe matar Retroarch o cerrar otra ventana
  if ($kill -eq "RETROARCH") {
	  Stop-Process -Name "RetroArch" -Force
  } else {
	  Stop-Process -Name "ES-DE" -Force
  }

  Write-Host "</div>"

  Write-Host "<table class='table'>"
  Write-Host "<tr>"

  # Check installation
  if (-Not (Test-Path $cloud_sync_bin)) {
	  Write-Host "<td>Executable Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td></tr></table>"
	  exit
  } else {
	  Write-Host "<td>Executable Status: </td><td class='alert--success'><strong>Success</strong></td>"
  }
  Write-Host "</tr><tr>"

  if (-Not (Test-Path $cloud_sync_config_file)) {
	  Write-Host "<td>Config file Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td></tr></table>"
	  exit
  } else {
	  Write-Host "<td>Config file Status: </td><td class='alert--success'><strong>Success</strong></td>"
  }
  Write-Host "</tr><tr>"

  if ([string]::IsNullOrEmpty($cloud_sync_provider)) {
	  Write-Host "<td>Provider Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td></tr></table>"
	  exit
  } else {
	  Write-Host "<td>Provider Status: </td><td class='alert--success'><strong>Success</strong></td>"
  }
  Write-Host "</tr><tr>"

  # Tests upload
  Write-Host "<tr>"
  if ($upload -eq 0) {
	  Write-Host "<td>Upload Status: </td><td class='alert--success'><strong>Success</strong></td>"
  } else {
	  Write-Host "<td>Upload Status: </td><td class='alert--danger'><strong>Failure</strong></td>"
	  Write-Host "</tr></table>"
  }
  Write-Host "</tr>"

  # Tests download
  Write-Host "<tr>"
  if ($download -eq 0) {
	  Write-Host "<td>Download Status: </td><td class='alert--success'><strong>Success</strong></td>"
  } else {
	  Write-Host "<td>Download Status: </td><td class='alert--danger'><strong>Failure</strong></td>"
	  Write-Host "</tr></table>"
  }
  Write-Host "</tr>"

  Write-Host "</table>"
  Write-Host "<span class='is-hidden'>true</span>"


}