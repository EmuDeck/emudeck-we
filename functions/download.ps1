function download($url, $output, $dir) {
	#Invoke-WebRequest -Uri $url -OutFile $output
	$wc = New-Object net.webclient
	$7zFile=-join($emulationPath,'\',$output)
	$wc.Downloadfile($url, $7zFile)
	if($dir){
		7z x -y -o"$dir" $output
		Remove-Item $output
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}