function download($url, $output) {
	#Invoke-WebRequest -Uri $url -OutFile $output
	$wc = New-Object net.webclient
	$wc.Downloadfile($url, -join($emulationPath,$output))
   
	foreach ($line in $output) {
		$extn = [IO.Path]::GetExtension($line)
		if ($extn -eq ".zip" ){
			   #Expand-Archive  $output $output.replace('.zip','') -ErrorAction SilentlyContinue
			$dir = -join($output.replace('.zip',''), "\");
			WinRAR x -y $output $dir
			waitForWinRar
			Remove-Item $output
		}
		if ($extn -eq ".7z" ){
			$dir = -join($output.replace('.7z',''), "\");
			WinRAR x -y $output $dir
			waitForWinRar
			Remove-Item $output
		}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}