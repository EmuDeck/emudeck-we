function emulatorInit($emuName, $emulatorFile, $formattedArgs){
	hideMe
	fullScreenToast
	isLatestVersionGH($emuName)
	checkAndStartSteam
	if( $emuName -ne "pegasus-frontend"){
		cloud_sync_init($emuName)
	}
	if($formattedArgs){
		Start-Process $emulatorFile -WindowStyle Maximized -Wait -Args $formattedArgs
	}else{
		Start-Process $emulatorFile -WindowStyle Maximized -Wait
	}
	rm -fo -r "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo -r "$savesPath/.emulator" -ErrorAction SilentlyContinue
}