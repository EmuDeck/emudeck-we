function cloud_sync_health_checkBin {
  $file = "cloudsync.emudeck"
  $filePath = "$savesPath\$file"

  # Cleanup
  & "$cloud_sync_bin" delete "$cloud_sync_provider`:$cs_user`Emudeck/saves/$file" > $null 2>&1
  Remove-Item -Force "$filePath" -ErrorAction SilentlyContinue
  Remove-Item -Force "$savesPath\dl_$file" -Recurse -ErrorAction SilentlyContinue

  if (Test-Path "$cloud_sync_bin") {
    Write-Output "true"
  } else {
    Write-Output "false"
  }
}

function cloud_sync_health_checkCfg {
  $char_count_og = (Get-Content "$emudeckFolder/backend/configs/rclone/rclone.conf" -Raw).Length
  $char_count = (Get-Content "$cloud_sync_config" -Raw).Length

  if ($char_count_og -eq $char_count) {
    Write-Output "false"
  } else {
    Write-Output "true"
  }
}

function cloud_sync_health_checkServiceCreated {
    Write-Output "true"
}

function cloud_sync_health_checkServiceStarts {
  Write-Output "true"
}

function cloud_sync_health_upload {
  $file = "cloudsync.emudeck"
  $filePath = "$savesPath\$file"

  "test" | Out-File -Encoding utf8 -NoNewline $filePath

  & "$cloud_sync_bin" -q copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$filePath" "$cloud_sync_provider`:$cs_user`Emudeck/saves/$file" > $null 2>&1

  if ($LASTEXITCODE -eq 0) {
    Write-Output "true"
  } else {
    Write-Output "false"
  }
  Remove-Item -Force "$filePath" -ErrorAction SilentlyContinue
}

function cloud_sync_health_isFileUploaded {
  $file = "cloudsync.emudeck"
  $output = & "$cloud_sync_bin" lsf "$cloud_sync_provider`:$cs_user`Emudeck/saves/" --include "$file" 2>&1

  if ($output -match "^$file$") {
    Write-Output "true"
  } else {
    Write-Output "false"
  }
}

function cloud_sync_health_download {
  $file = "cloudsync.emudeck"
  $filePath = "$savesPath\$file"

  & "$cloud_sync_bin" -q copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:$cs_user`Emudeck/saves/$file" "$savesPath\dl_$file" > $null 2>&1

  if ($LASTEXITCODE -eq 0) {
    Write-Output "true"
  } else {
    Write-Output "false"
  }

  Remove-Item -Force "$filePath" -ErrorAction SilentlyContinue
}

function cloud_sync_health_isFileDownloaded {
  $file = "dl_cloudsync.emudeck"
  $filePath = "$savesPath\$file"

  if (Test-Path $filePath) {
    Write-Output "true"
  } else {
    Write-Output "false"
  }

  # Cleanup
  & "$cloud_sync_bin" delete "$cloud_sync_provider`:$cs_user`Emudeck/saves/$file" > $null 2>&1
  Remove-Item -Force $filePath -ErrorAction SilentlyContinue
  Remove-Item -Force "$savesPath\$file" -ErrorAction SilentlyContinue
}

