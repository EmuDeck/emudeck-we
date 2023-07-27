function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets | 
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } | 
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function download($url, $file) {
	$wc = New-Object net.webclient		
	$temp = Join-Path $env:USERPROFILE "Downloads"
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
			$dir = $file.replace('.7z','')
			7z x -o"$temp/$dir" -aoa "$temp/$file"	
			Remove-Item $temp/$file
		}
	}
	Write-Host "Done!" -ForegroundColor green -BackgroundColor black
}

clear
echo "Installing EmuDeck WE Dependencies"
&winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements
&winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements
if($?){
	echo "There was an error trying to install dependencies, please visit this url to learn how to fix it: https://github.com/EmuDeck/emudeck-we/wiki/Installation-Issues#7zip-and-git-are-not-being-installed"
}else{
	#We add 7z folders to the Path
	$env:path = $env:path + ";$env:ProgramFiles\7-zip"
	$env:path = $env:path + ";$env:ProgramFiles (x86)\7-zip"
	
	echo "Downloading EmuDeck"
	$url_emudeck = getLatestReleaseURLGH 'SteamGridDB/steam-rom-manager' 'exe' 'portable'
	download $url_emudeck "emudeck_install.exe"
	$temp = Join-Path $env:USERPROFILE "Downloads"
	&"$temp/emudeck_install.exe"
}

