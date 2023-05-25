function download($url, $file) {
	$wc = New-Object net.webclient		
	$destination="$temp/$file"		
	mkdir $temp -ErrorAction SilentlyContinue
	
	$wc.Downloadfile($url, $destination)
	
	foreach ($line in $file) {
		$extn = [IO.Path]::GetExtension($line)
		if ($extn -eq ".zip" ){			
			$dir = $file.replace('.zip','')
			7z x -o"$temp/$dir" -aoa "$temp/$file"
			Remove-Item $temp/$file
		}
		if ($extn -eq ".7z" ){
			$dir = $output.replace('.7z','')
			7z x -o"$temp/$dir" -aoa "$temp/$file"	
			Remove-Item $temp/$file
		}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}