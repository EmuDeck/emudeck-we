#Put here your autofix functions, they should be load when EmuDeck Starts

function autofix_betaCorruption(){

  $archivo = "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1"

  # Lee el contenido del archivo
  $contenido = Get-Content -Path $archivo

  if ($contenido -match "NYI") {
	  confirmDialog -TitleText "Corrupted installation" -MessageText "EmuDeck will reinstall after clicking OK, nothing will be deleted. This could take a few seconds to download"
	  $url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
	  download $url_emudeck "emudeck_install.exe"
	  &"$temp/emudeck_install.exe"
  -ForegroundColor Cyan
	  break
	  exit
	}
}

function autofix_lnk($savesPath){
  $sourceFolder = "$savesPath"

  #Saves folders
  if ( Get-ChildItem -Path "$sourceFolder" -Filter *.lnk -File -Recurse  ){
	confirmDialog -TitleText "Old .lnk files found in $savesPath" -MessageText "We will delete them since they are no longer neccesary and can cause problems. Make sure to delete them in your cloud provider in every subfolder"
	Get-ChildItem -Path "$sourceFolder" -Filter *.lnk -File -Recurse | ForEach-Object {
	  echo $_.FullName
	  if( Test-Path $_.FullName ){
		Remove-Item -path $_.FullName
	  }
	}
	SRM_resetLaunchers
  }
}

function autofix_cloudSyncLockfile(){
  if ( Test-Path -Path "$userFolder\emudeck\cloud.lock" ){
	confirmDialog -TitleText "CLoudSync locked" -MessageText "It seems your last CloudSync upload didn't finish or locked it, we have unlocked it"
	rm -fo "$userFolder\emudeck\cloud.lock" -ErrorAction SilentlyContinue
  }
}

function autofix_raSavesFolders(){

  $sourceFolder = "$savesPath/RetroArch/saves"
  $destinationFolder = "$sourceFolder"
  $subfolders = Get-ChildItem -Path $sourceFolder -Directory

  if ($subfolders.Count -gt 0) {
	cloud_sync_createBackup "retroarch" > $null 2>&1
	confirmDialog -TitleText "Old RetroArch saves folders found" -MessageText "EmuDeck will create a backup of them in Emulation\saves-backup just in case, after that it will reorganize and delete the old subfolder. Please manually delete all subfolders you might have in your cloud provider ( EmuDeck/saves/retroarch/saves/* and EmuDeck/saves/retroarch/states/*)"
	foreach ($subfolder in $subfolders) {
	  $subfolderPath = $subfolder.FullName
	  robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
	  Remove-Item -Path $subfolderPath -Force -Recurse
	}
  }

  $sourceFolder = "$savesPath/RetroArch/states"
  $destinationFolder = "$sourceFolder"
  $subfolders = Get-ChildItem -Path $sourceFolder -Directory

  if ($subfolders.Count -gt 0) {
	foreach ($subfolder in $subfolders) {
	  $subfolderPath = $subfolder.FullName
	  robocopy "$subfolderPath" "$destinationFolder" /E /XC /XN /XO
	  Remove-Item -Path $subfolderPath -Force -Recurse
	}
  }

  setConfigRA "sort_savefiles_by_content_enable" "false" $RetroArch_configFile
  setConfigRA "sort_savefiles_enable" "false" $RetroArch_configFile
  setConfigRA "sort_savestates_by_content_enable" "false" $RetroArch_configFile
  setConfigRA "sort_savestates_enable" "false" $RetroArch_configFile
  setConfigRA "sort_screenshots_by_content_enable" "false" $RetroArch_configFile

}