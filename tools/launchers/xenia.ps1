$emulatorFile = "$env:APPDATA/emudeck/Emulators/xenia/xenia_canary.exe"
$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"

$wd = Split-Path -Parent $emulatorFile

$global:PSDefaultParameterValues['Start-Process:WorkingDirectory'] = $wd

$formattedArgs = ($args | ForEach-Object {
  if ($_ -match '^\s*$') { $null }
  elseif ($_ -match '^".*"$') { $_ }
  elseif ($_ -match '\s') { '"' + $_ + '"' }
  else { $_ }
}) -join ' '

if ($formattedArgs -and $formattedArgs -notmatch '\-\-fullscreen=') {
  $formattedArgs = "$formattedArgs --fullscreen=true"
}

emulatorInit $scriptFileName $emulatorFile $formattedArgs