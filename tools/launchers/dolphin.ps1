$steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
if ($steamRunning) {
	$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/Emulators/Dolphin-x64/Dolphin.exe"
	$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
	$NewTitle = "EmuDeck Launcher - $scriptFileName"
	[Console]::Title = $NewTitle
	. $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1
	cloud_sync_init($scriptFileName)
	Start-Process $emulatorFile -Wait -Args ($args -join " ")
	rm -fo "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo "$savesPath/.emulator" -ErrorAction SilentlyContinue
} else {
	. $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1
	toast = steamToast -MessageText "Steam is not running, closing..."
	Start-Sleep -Seconds 2
	$toast.Close()
}