function emulatorInit($emuName, $emulatorFile, $formattedArgs){
	hideMe
	fullScreenToast
	checkAndStartSteam
	cloud_sync_init($emuName)
	if($formattedArgs){
		Start-Process $emulatorFile -WindowStyle Maximized -Wait -Args $formattedArgs
	}else{
		Start-Process $emulatorFile -WindowStyle Maximized -Wait
	}
	rm -fo "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo "$savesPath/.emulator" -ErrorAction SilentlyContinue
}