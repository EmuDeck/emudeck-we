function download($url, $output) {
	#Invoke-WebRequest -Uri $url -OutFile $output
	$wc = New-Object net.webclient
	$destination=-join($emulationPath,'\',$output)
	$wc.Downloadfile($url, $destination)
   
	foreach ($line in $output) {
		$extn = [IO.Path]::GetExtension($line)
		if ($extn -eq ".zip" ){
			   #Expand-Archive  $output $output.replace('.zip','') -ErrorAction SilentlyContinue
			$dir = -join($output.replace('.zip',''), "\");
			7z x $output		
			Remove-Item $output
		}
		if ($extn -eq ".7z" ){
			$dir = -join($output.replace('.7z',''), "\");
			7z x $output		
			Remove-Item $output
		}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}