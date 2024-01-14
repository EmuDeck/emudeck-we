function cloud_sync_download_test($emuName){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {

		$target = "$emulationPath\saves\$emuName\"
		if ( Test-Path "$target" ){
			"test" | Set-Content "$target\.temp" -ErrorAction SilentlyContinue -Encoding UTF8
			$fileHash = "$target\.temp"
			Write-Host "Testing $emuName download..."
			& $cloud_sync_bin -q --log-file "$userFolder/EmuDeck/logs/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck\saves\$emuName\.temp" "$fileHash"
			if ($?) {
				Write-Host ""
			}else{
				Write-Host "Error: Testing $emuName download"
				rm -fo -r "$target\.temp" -ErrorAction SilentlyContinue
				exit
			}
			rm -fo -r "$target\.temp" -ErrorAction SilentlyContinue
		}

	}
}

function cloud_sync_upload_test($emuNAme){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {

		$target = "$emulationPath\saves\$emuName\"
		if ( Test-Path "$target" ){
			"test" | Set-Content "$target\.temp" -ErrorAction SilentlyContinue -Encoding UTF8
			$fileHash = "$target\.temp"

			Write-Host "Testing $emuName upload..."

			& $cloud_sync_bin -q --log-file "$userFolder/EmuDeck/logs/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$fileHash" "$cloud_sync_provider`:Emudeck\saves\$emuName\.temp"
			if ($?) {
				Write-Host ""
			}else{
				Write-Host "Error: Testing $emuName upload"
				rm -fo -r "$target\.temp" -ErrorAction SilentlyContinue
				exit
			}
			rm -fo -r "$target\.temp" -ErrorAction SilentlyContinue
		}


	}

}

function cloudSyncHealth(){

	if ( -not (Test-Path "$toolsPath\rclone\rclone.exe")) {
		echo "Error: No executable found. Please reinstall"
		exit
	}
	if ( -not (Test-Path "$toolsPath\rclone\rclone.conf")) {
		echo "Error: No config file found. Please reinstall"
		exit
	}
	if ( $cloud_sync_provider -eq '') {
		echo "Error: No provider found. Please reinstall"
		exit
	}

	$miArreglo = @("Cemu","citra","dolphin","duckstation","MAME","melonds","mgba","pcsx2","ppsspp","primehack","retroarch","rpcs3","scummvm","Vita3K","yuzu","ryujinx")

	foreach ($elemento in $miArreglo) {
		cloud_sync_upload_test $elemento
	}

	foreach ($elemento in $miArreglo) {
		cloud_sync_download_test $elemento
	}


}