function downloadCore($url, $output) {
	#Invoke-WebRequest -Uri $url -OutFile $output
	$file=-join('Emulation\',$output,'.zip')
	$zipFile=-join($winPath,$file)
	$destination = -join($winPath,'Emulation\tools\EmulationStation-DE\Emulators\RetroArch\cores\')
	$wc = New-Object net.webclient
	$wc.Downloadfile($url, $file)
	
	foreach ($line in $file) {
		$extn = [IO.Path]::GetExtension($line)
		if ($extn -eq ".zip" ){			
			Expand-Archive -Path $zipFile -DestinationPath $destination -Force
			Remove-Item $zipFile
		}
		#if ($extn -eq ".7z" ){
		#	$dir = -join($output.replace('.7z',''), "\");
		#	WinRAR x -y $output $dir
		#	waitForWinRar
		#	del $output
		#}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}