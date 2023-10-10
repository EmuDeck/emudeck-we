clear

$PSversionMajor = $PSVersionTable.PSVersion.Major
$PSversionMinor = $PSVersionTable.PSVersion.Minor
$PSversion = "$PSversionMajor$PSversionMinor"


function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets |
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } |
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function startScriptWithAdmin {
	param (
		[string]$ScriptContent
	)

	#$scriptContent = @"
	#. "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1";
	#Write-Host "I'm Admin"
	#"@

	$tempScriptPath = [System.IO.Path]::GetTempFileName() + ".ps1"
	$ScriptContent | Out-File -FilePath $tempScriptPath -Encoding utf8 -Force

	$psi = New-Object System.Diagnostics.ProcessStartInfo
	$psi.Verb = "runas"
	$psi.FileName = "powershell.exe"
	$psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File ""$tempScriptPath"""
	[System.Diagnostics.Process]::Start($psi).WaitForExit()

	Remove-Item $tempScriptPath -Force
}

function download($url, $file) {

	$wc = New-Object net.webclient
	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	$destination="$temp/$file"
	mkdir $temp -ErrorAction SilentlyContinue

	$wc.Downloadfile($url, $destination)

	Write-Host "Done!" -NoNewline -ForegroundColor green -BackgroundColor black
}

if ( $PSversion -lt 51 ){
	clear
	Write-Host "Updating PowerShell to 5.1" -ForegroundColor white
	Write-Host ""
	Write-Host " Downloading .NET..."
	download "https://go.microsoft.com/fwlink/?linkid=2088631" "dotNet.exe"
	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	&"$temp/dotNet.exe"
	rm -fo "$temp/dotNet.exe"

	Write-Host ""
	Write-Host " Downloading WMF 5.1..."
	download "https://go.microsoft.com/fwlink/?linkid=839516" "wmf51.msu"

	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	&"$temp/wmf51.msu"
	rm -fo "$temp/wmf51.msu"

	Write-Host ""
	Write-Host " If the WMF installation fails please restart Windows and run the installer again"  -ForegroundColor white
	Read-Host -Prompt "Press any key to continue or CTRL+C to quit"
	clear
	Write-Host "PowerShell updated to 5.1" -ForegroundColor white
}

	$FIPSAlgorithmPolicy = Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy
	$EnabledValue = $FIPSAlgorithmPolicy.Enabled

	if($EnabledValue -eq 1){
		Write-Host "Windows FIPS detected, we need to turn it off so cloudSync can be used, after that the computer will restart. Once back in the desktop just run this installer again. You can read about FIPS here and why is better to disable it: https://techcommunity.microsoft.com/t5/microsoft-security-baselines/why-we-re-not-recommending-fips-mode-anymore/ba-p/701037" -ForegroundColor white
		Read-Host -Prompt "Press any key to apply the fix and restart"
$scriptContent = @"
Set-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy -name Enabled -value 0; Restart-Computer -Force
"@
			startScriptWithAdmin -ScriptContent $scriptContent
	}


Write-Host "Installing EmuDeck WE Dependencies" -ForegroundColor white
Write-Host ""
if (Test-Path "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\winget.exe") {

	$wingetVersion = (winget -v) -replace '[^\d.]'
	$minVersion = '1.6.2721'
	# Compara las versiones
	if ([version]$wingetVersion -lt [version]$minVersion) {
		Write-Host "Updating Winget..."

		$url_git = getLatestReleaseURLGH 'microsoft/winget-cli' 'msixbundle'
		download $url_git "winget.msixbundle"
		$temp = Join-Path "$env:USERPROFILE" "Downloads"

		Start-Process "$temp/winget.msixbundle" -Wait
	}

	Start-Process "winget" -Wait -NoNewWindow -Args "install -e --id Git.Git --accept-package-agreements --accept-source-agreements"
	Start-Process "winget" -Wait -NoNewWindow -Args "install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements"
}

if (-not (Test-Path "$env:ProgramFiles\Git\bin\git.exe")) {

	$Host.UI.RawUI.BackgroundColor = "Red"

	#Clear-Host
	Write-Host ""
	Write-Host "There was an error trying to install dependencies using Winget."
	Write-Host "We are gonna try to install them manually..."
	Write-Host ""
	$Host.UI.RawUI.BackgroundColor = "Black"

	#Download git
	Write-Host "Downloading GIT..."
	$url_git = getLatestReleaseURLGH 'git-for-windows/git' 'exe' '64-bit'
	download $url_git "git_install.exe"
	$temp = Join-Path "$env:USERPROFILE" "Downloads"

	Write-Host " Launching GIT Installer, please wait..."

	$installDir="$env:ProgramFiles\Git\"

	Start-Process "$temp\git_install.exe" -Wait -Args "/VERYSILENT /INSTALLDIR=\$installDir"

	if (-not (Test-Path "$env:ProgramFiles\Git\bin\git.exe")) {
		$Host.UI.RawUI.BackgroundColor = "Red"
		Write-Host "GIT Download Failed" -ForegroundColor white
		$Host.UI.RawUI.BackgroundColor = "Black"
		Write-Host "Please visit this url to learn how to install all the dependencies manually by yourself:" -ForegroundColor white
		Write-Host ""
		Write-Host "https://emudeck.github.io/common-issues/windows/#dependencies" -ForegroundColor white
		Write-Host ""
		$Host.UI.RawUI.BackgroundColor = "Black"
		Read-Host -Prompt "Press any key to exit"
	}

}else{
	Write-Host "All dependencies are installed" -ForegroundColor white
	Write-Host ""
	Write-Host "Downloading EmuDeck..." -ForegroundColor white
	Write-Host ""
	$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
	download $url_emudeck "emudeck_install.exe"
	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	Write-Host " Launching EmuDeck Installer, please wait..."
	&"$temp/emudeck_install.exe"
}
