function setMSGTemp($message){
	$progressBarValue = Get-Content -Path "$env:APPDATA\EmuDeck\msg.log" -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+1

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii "$env:APPDATA\EmuDeck\msg.log"
	Write-Output $message
	Add-Content "$env:APPDATA\EmuDeck\msg.log" "# $message" -NoNewline -Encoding UTF8
	Start-Sleep -Seconds 0.5
}
setMSGTemp 'Creating configuration files. please wait'

Write-Output "" > "$env:USERPROFILE\EmuDeck\logs\EmuDeckAndroidSetup.log"

Start-Sleep -Seconds 1.5

Start-Transcript "$env:USERPROFILE\EmuDeck\logs\EmuDeckAndroidSetup.log"

#We install 7zip - Now its on the appimage
#winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements

# JSON Parsing to ps1 file

. "$env:APPDATA\EmuDeck\backend\functions\JSONtoPS1.ps1"
JSONtoPS1


#
# Functions, settings and vars
#

. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

#setScreenDimensionsScale

#
# Installation
#
#
#Clear old installation msg log
Remove-Item "$userFolder\AppData\Roaming\EmuDeck\msg.log" -ErrorAction SilentlyContinue
Write-Output "Installing, please stand by..."
Write-Output ""

Android_ADB_push "$env:APPDATA\EmuDeck\backend\android\roms" "$androidStoragePath"


Android_RetroArch_install

Stop-Transcript