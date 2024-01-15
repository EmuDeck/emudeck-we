function cloud_sync_download_test($emuName){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {

		$target = "$emulationPath\saves\$emuName\"
		if ( Test-Path "$target" ){
			"test" | Set-Content "$target\.temp" -ErrorAction SilentlyContinue -Encoding UTF8
			$fileHash = "$target\.temp"
			#Write-Host "Testing $emuName download..."
			& $cloud_sync_bin -q --log-file "$userFolder/EmuDeck/logs/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck\saves\$emuName\.temp" "$fileHash"
			if ($?) {
				echo "<td>$elemento download Status: <td  class='alert--success'><strong>Success</strong></td>"
			}else{
				echo "<td>$elemento download Status: </td><td class='alert--danger'><strong>Failure</strong></td>"
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
				echo "<td>$elemento upload Status: </td><td class='alert--success'><strong>Success</strong></td>"
			}else{
				echo "<td>$elemento upload Status: </td><td class='alert--danger'><strong>Failure</strong></td>"
				rm -fo -r "$target\.temp" -ErrorAction SilentlyContinue
				exit
			}
			rm -fo -r "$target\.temp" -ErrorAction SilentlyContinue
		}


	}

}

function cloudSyncHealth(){
	echo "<td><table class='table'>"
		echo "<td><tr>"
	if ( -not (Test-Path "$toolsPath\rclone\rclone.exe")) {
		echo "<td>Executable Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td>"
		exit
	}else{
		echo "<td>Executable Status: </td><td class='alert--success'><strong>Success</strong></td>"
	}
	echo "</tr><tr>"
	if ( -not (Test-Path "$toolsPath\rclone\rclone.conf")) {
		echo "<td>Config file Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td>"
		exit
	}else{
		echo "<td>Config file Status: </td><td class='alert--success'><strong>Success</strong></td>"
	}
	echo "</tr><tr>"
	if ( $cloud_sync_provider -eq '') {
		echo "<td>Provider Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td>"
		exit
	}else{
		echo "<td>Provider Status: </td><td class='alert--success'><strong>Success</strong></td>"
	}
	echo "</tr><tr>"

	if (Get-Service -Name "CloudWatch" -ErrorAction SilentlyContinue) {
		echo "<td>Watcher Status: </td><td class='alert--success'><strong>Success</strong></td>"
	}else{
		echo "<td>Watcher Status: </td><td class='alert--danger'><strong>Failure, please reinstall</strong></td>"
		exit
	}
	echo "</tr>"
	$miArreglo = @("Cemu","citra","dolphin","duckstation","MAME","melonds","mgba","pcsx2","ppsspp","primehack","retroarch","rpcs3","scummvm","Vita3K","yuzu","ryujinx")

	foreach ($elemento in $miArreglo) {
		cloud_sync_upload_test $elemento
	}

	foreach ($elemento in $miArreglo) {
		cloud_sync_download_test $elemento
	}
	echo "<td></table>"
	Write-Host "true"

}