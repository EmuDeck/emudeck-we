function emulatorInit($emuName, $emulatorFile, $formattedArgs){
	hideMe
	fullScreenToast
	checkAndStartSteam
	if($formattedArgs){
		Start-Process $emulatorFile -WindowStyle Maximized -Wait -Args $formattedArgs
	}else{
		Start-Process $emulatorFile -WindowStyle Maximized -Wait
	}
	rm -fo -r "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo -r "$savesPath/.emulator" -ErrorAction SilentlyContinue
}