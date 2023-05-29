function appImageInit(){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $null)) {	
		setSetting "cloud_sync_status" "true"
	}
	if ($melondsResolution -eq $null) {	
		setSetting "melondsResolution" "720P"
	}
	Cemu_setupSaves
	Citra_setupSaves
	Dolphin_setupSaves
	RPCS3_setupSaves
	Yuzu_setupSaves
	PCSX2_setupSaves
	PCSX2QT_setupSaves
	melonDS_setupSaves
	RetroArch_setupSaves
	Ryujinx_setupSaves
	Duckstation_setupSaves
}