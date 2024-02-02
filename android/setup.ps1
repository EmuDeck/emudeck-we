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

#We set  $android_writable to true or false to enable or disable adb push
Android_ADB_testWrite
Start-Sleep 1
. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

#
#
# Installation
#
#

#Clear old installation msg log
Remove-Item "$userFolder\AppData\Roaming\EmuDeck\msg.log" -ErrorAction SilentlyContinue
Write-Output "Installing, please stand by..."
Write-Output ""

#Roms folders
if ( $android_writable -eq "true" ){
	Android_ADB_push "$env:APPDATA\EmuDeck\backend\android\roms" "$androidStoragePath"
}else{
	copyFromTo "$env:APPDATA\EmuDeck\backend\android\roms" "$Android_temp_external/Emulation/roms"
}


Android_Pegasus_install
Android_AetherSX2_install
Android_Citra_install
Android_Dolphin_install
Android_RetroArch_install
Android_PPSSPP_install
Android_Yuzu_install
Android_ScummVM_install
Android_Vita3K_install


Android_Pegasus_init
Android_AetherSX2_init
Android_Citra_init
Android_Dolphin_init
Android_RetroArch_init
Android_PPSSPP_init
Android_Yuzu_init
Android_ScummVM_init
Android_Vita3K_init


if ( $android_writable -eq "false" ){

	setMSG "Moving settings ussing MTP, expect some pop ups"

	  Move-To-MTP -parent "CopyToInternal" -path "Internal shared storage"
	  if ( $androidStoragePath -like "*-*" ){
		  $SDCARDNAME=Ask-SDCARD
		  Move-To-MTP -parent "CopyToSDCARD" -path "$SDCARDNAME"
	  }
}


Stop-Transcript