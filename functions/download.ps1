function download($url, $file, $token) {
	#We add 7z folders to the Path
	$env:path = $env:path + ";$env:ProgramFiles\7-zip"
	$env:path = $env:path + ";$env:ProgramFiles (x86)\7-zip"
	$env:path = $env:path + ";$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\wintools\"

	$wc = New-Object net.webclient
	$destination="$temp/$file"
	mkdir $temp -ErrorAction SilentlyContinue
	if ($token -ne $null -and $token -ne "") {
		$wc.Headers.Add("Authorization", "Bearer $token")
		$wc.Headers.Add("User-Agent", "EmuDeck")
	}

	$wc.Downloadfile($url, $destination)

	foreach ($line in $file) {
		$extn = [IO.Path]::GetExtension($line)
		if ($extn -eq ".zip" ){
			$dir = $file.replace('.zip','')
			& 7z x -o"$temp/$dir" -aoa "$temp/$file"
			Remove-Item $temp/$file
		}
		if ($extn -eq ".7z" ){
			$dir = $file.replace('.7z','')
			& 7z x -o"$temp/$dir" -aoa "$temp/$file"
			Remove-Item $temp/$file
		}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}
