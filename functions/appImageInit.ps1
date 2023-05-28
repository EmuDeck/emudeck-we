function appImageInit(){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $null)) {	
		setSetting "cloud_sync_status" "true"
	}
	if ($melondsResolution -eq $null) {	
		setSetting "melondsResolution" "720P"
	}
	cd $env:USERPROFILE ; cd AppData ; cd Roaming  ; cd EmuDeck ; cd backend; git checkout early; git pull
}