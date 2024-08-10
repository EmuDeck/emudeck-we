function emulatorInit($emuName, $emulatorFile, $formattedArgs){
	hideMe
	fullScreenToast
	isLatestVersionGH($emuName)
	checkAndStartSteam
	if( $emuName -ne "pegasus-frontend"){
		cloud_sync_init($emuName)
	}

	#NetPlay
	# if( $emuName -eq "retroarch"){
	# 	if( $netPlay -eq "true"){
	# 		#Looks for devices listening
	# 		setSetting netplayCMD " -H"
	# 		Start-Sleep -Seconds 2
	# 		netplaySetIP
	# 	}else{
	# 		setSetting netplayCMD "' '"
	# 	}
	# 	. $env:USERPROFILE\emudeck\settings.ps1
	# }

	if($formattedArgs){
		#$formattedArgs += "`"$netplayCMD`""
		$process = Start-Process $emulatorFile -PassThru -WindowStyle Maximized -Wait -Args $formattedArgs
	}else{
		$process = Start-Process $emulatorFile -PassThru -WindowStyle Maximized -Wait
	}
	$process.WaitForExit()
	rm -fo -r "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo -r "$savesPath/.emulator" -ErrorAction SilentlyContinue
}