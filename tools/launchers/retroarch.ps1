 . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1

$arguments = $args -join " "

$TiempoDeInicio = Get-Date
Measure-Command { cloud_sync_init("retroarch") }
$TiempoDeFin = Get-Date
$TiempoDeEjecucion = $TiempoDeFin - $TiempoDeInicio
Write-Host "El cloud_sync_init tomó $($TiempoDeEjecucion.TotalSeconds) segundos en ejecutarse."

Start-Process "C:/Users/rsedano/EmuDeck/EmulationStation-DE/Emulators/RetroArch/retroarch.exe" -Args $arguments -Wait

rm -fo "$savesPath/.watching"
rm -fo "$savesPath/.emulator"
rm -fo "$savesPath/retroarch/.pending_upload"