function downloadEmuDeck() {
	$url= 'https://github.com/EmuDeck/emudeck-we/archive/refs/heads/main.zip'
	$output=-join($HOME,'\emudeck')
	$file=-join($output,'.zip')
	$zipFile=-join($file)
	$destination = $HOME
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