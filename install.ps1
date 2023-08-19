function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets | 
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } | 
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function download($url, $file) {
	#We add 7z folders to the Path
	$env:path = $env:path + ";$env:ProgramFiles\7-zip"
	$env:path = $env:path + ";$env:ProgramFiles (x86)\7-zip"

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
	Write-Host "Done!" -NoNewline -ForegroundColor green -BackgroundColor black
}

clear

Write-Host "Installing EmuDeck WE Dependencies" -ForegroundColor white
Write-Host ""
&winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements
&winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements

if ($LASTEXITCODE -eq '-1978335212') {
	$Host.UI.RawUI.BackgroundColor = "Red"
	#Clear-Host
	Write-Host ""
	Write-Host "There was an error trying to install dependencies, please visit this url to learn how to fix it:" -ForegroundColor white
	Write-Host  "https://emudeck.github.io/common-issues/windows/#7zip-and-git-are-not-being-installed" -ForegroundColor white
	
	Write-Host ""
	$Host.UI.RawUI.BackgroundColor = "Black"
	Read-Host -Prompt "Press any key to exit" 	
}else{
	Write-Host ""
	Write-Host "Downloading EmuDeck..." -ForegroundColor white
	Write-Host ""
	$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
	download $url_emudeck "emudeck_install.exe"
	$temp = Join-Path $env:USERPROFILE "Downloads" 
	
	Write-Host " Launching EmuDeck Installer, please wait..."
	&"$temp/emudeck_install.exe"
}