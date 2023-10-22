$steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
if ($steamRunning) {
	$emulatorFile = "$env:USERPROFILE/EmuDeck/EmulationStation-DE/EmulationStation.exe"
	$scriptFileName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
	$NewTitle = "EmuDeck Launcher - $scriptFileName"
	[Console]::Title = $NewTitle
	. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
	. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/EmuScripts/emuDeckRPCS3.ps1"
	RPCS3_renameFolders
	cloud_sync_init($scriptFileName)
	if($args){
		Start-Process $emulatorFile -WindowStyle Maximized -Wait -Wait -Args ($args -join " ")
	}else{
		Start-Process $emulatorFile -WindowStyle Maximized -Wait
	}
	rm -fo "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo "$savesPath/.emulator" -ErrorAction SilentlyContinue
} else {
	. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
	toast = steamToast -MessageText "Steam is not running, closing..."
	Start-Sleep -Seconds 2
	$toast.Close()
}
