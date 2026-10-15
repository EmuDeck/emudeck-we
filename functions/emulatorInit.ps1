function emulatorInit($emuName, $emulatorFile, $formattedArgs){
	hideMe
	if (-not $formattedArgs -and (isEarlyUnstable)) {
		switch ($emuName) {
			"ryujinx" { $autoMapEmulatorStatus = $autoMapSwitch }
			"eden" { $autoMapEmulatorStatus = $autoMapSwitch }
			"dolphin" { $autoMapEmulatorStatus = $autoMapDolphin }
			"cemu" { $autoMapEmulatorStatus = $autoMapCemu }
			default { $autoMapEmulatorStatus = "false" }
		}
		if ("$autoMapEmulatorStatus" -eq "true") {
			yesNoDialog -TitleText "EmuDeck" -MessageText "ATTENTION: AutoMap is enabled. You won't be able to change controller settings in this emulator, other settings are not locked. If you want to customize your controller settings please turn AutoMap off in the EmuDeck app" -OKButtonText "OK" -ShowCancelButton $false | Out-Null
		}
	}
	$focus = focusEmulator $emulatorFile
	. emulatorCheckAndInstall $emuName
	if (-not (isEarlyUnstable)) {
		checkAndStartSteam
	}
	#checkAndStartSteam
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
	# 	. $env:APPDATA\emudeck\settings.ps1
	# }

	$fixesFn = "$($emuName -replace '-','_')_launch_fixes"
	if(Get-Command $fixesFn -ErrorAction SilentlyContinue){
		Write-Output "Applying launch fixes: $fixesFn"
		try {
			& $fixesFn
		} catch {
			Write-Output "$fixesFn failed, continuing launch: $_"
		}
	}

	if($formattedArgs){
		#$formattedArgs += "`"$netplayCMD`""
		Start-Process $emulatorFile -WindowStyle Maximized -Wait -Args $formattedArgs
	}else{
		Start-Process $emulatorFile -WindowStyle Maximized -Wait
	}
	closeFocusEmulator $focus
	rm -fo -r "$savesPath/.watching" -ErrorAction SilentlyContinue
	rm -fo -r "$savesPath/.emulator" -ErrorAction SilentlyContinue
}