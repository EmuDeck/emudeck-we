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
setMSG "Installing, please stand by..."
rm -fo -r $env:USERPROFILE/EmuDeck/android/temp
Write-Output ""
$copySavedGames="false"
$result = yesNoDialog -TitleText "Saved Games" -MessageText "Do you want to copy your current saved games to your Android Device?" -OKButtonText "Yes" -CancelButtonText "No"

if ($result -eq "OKButton") {
	$copySavedGames="true"
} else {
	$copySavedGames="false"
}





#Roms folders
if ( $android_writable -eq "true" ){
	setMSG "Creating rom folders in $androidStoragePath..."
	Android_ADB_push "$env:APPDATA\EmuDeck\backend\android\roms" "$androidStoragePath/Emulation/roms"
	setMSG "Copying BIOS"
	Android_ADB_push "$biosPath" "$androidStoragePath/Emulation/bios"

	if ($copySavedGames -eq "true") {
		setMSG "Copying Saves & States"
		#RA
		Android_ADB_push "$savesPath/RetroArch" "$androidStoragePath/Emulation/saves/RetroArch/"
		#PPSSPP
		Android_ADB_push "$emusPath\PPSSPP\memstick\PSP\SAVEDATA"  "$androidStoragePath/Emulation/saves/PSP/SAVEDATA"
		Android_ADB_push "$emusPath\PPSSPP\memstick\PSP\PPSSPP_STATE" "$androidStoragePath/Emulation/saves/PSP/PPSSPP_STATE"
		#Yuzu
		Android_ADB_push "$savesPath/yuzu/saves/" "/storage/emulated/0/Android/data/org.yuzu.yuzu_emu/files/nand/user/saves/"
		#Citra
		Android_ADB_push "$savesPath\citra\saves" "/storage/emulated/0/citra-emu/sdmc/"

	}

}else{

	if ( $androidStoragePath -like "*-*" ){
		$Android_cond_path=$Android_temp_external
	}else{
		$Android_cond_path=$Android_temp_internal
	}
	setMSG "Creating rom folders in $androidStoragePath..."
	copyFromTo "$env:APPDATA\EmuDeck\backend\android\roms" "$Android_cond_path/Emulation/roms"
	setMSG "Copying BIOS"
	copyFromTo "$biosPath" "$Android_cond_path/Emulation/bios"

	if ($copySavedGames -eq "true") {
		setMSG "Copying Saves & States"
		#RA
		copyFromTo "$savesPath/RetroArch" "$Android_cond_path/Emulation/saves/RetroArch/"
		#PPSSPP
		Android_ADB_push "$savesPath\ppsspp\saves"  "$androidStoragePath/Emulation/saves/PSP/SAVEDATA"
		Android_ADB_push "$savesPath\ppsspp\states" "$androidStoragePath/Emulation/saves/PSP/PPSSPP_STATE"
		#Yuzu
		copyFromTo "$savesPath/yuzu/saves/" "$Android_temp_internal/Android/data/org.yuzu.yuzu_emu/files/nand/user/saves/"
		#Citra
		copyFromTo "$savesPath\citra\saves" "$Android_temp_internal/citra-emu/sdmc/"
	}
}



Android_Pegasus_install
Android_AetherSX2_install
Android_Citra_install
Android_Dolphin_install
Android_RetroArch_install
Android_PPSSPP_install
Android_Yuzu_install
Android_ScummVM_install
#Android_Vita3K_install


Android_Pegasus_init
Android_AetherSX2_init
Android_Citra_init
Android_Dolphin_init
Android_PPSSPP_init
Android_Yuzu_init
Android_ScummVM_init
Android_Vita3K_init
Android_RetroArch_init


$result = yesNoDialog -TitleText "Bezels" -MessageText "Do you want to use bezels?" -OKButtonText "Yes" -CancelButtonText "No"
if ($result -eq "OKButton") {
	Android_RetroArch_bezelOnAll
} else {
	Android_RetroArch_bezelOffAll
}

$result = yesNoDialog -TitleText "Shaders" -MessageText "Do you want to use shaders?" -OKButtonText "Yes" -CancelButtonText "No"
if ($result -eq "OKButton") {
	Android_RetroArch_CRTshaderOnAll
	Android_RetroArch_MATshadersOnAll

} else {
	Android_RetroArch_CRTshaderOffAll
	Android_RetroArch_MATshadersOffAll

}


if ( $android_writable -eq "false" ){
	  setMSG "Moving data ussing MTP, expect some pop ups behind this window"

	  Move-To-MTP -parent "CopyToInternal" -path "Internal shared storage"
	  if ( $androidStoragePath -like "*-*" ){
		  $phone = Get-Phone
		  $SDObject = $phone.GetFolder.items()| where { $_.Name -ne "Internal shared storage" }
		  $SDCARDNAME = $SDObject.Name
		  Move-To-MTP -parent "CopyToSDCARD" -path "$SDCARDNAME"
	  }
	  confirmDialog -TitleText "Wait" -MessageText "Please wait for all transfers for complete before hitting Continue" -Position "Manual"
}


#adb shell 'dumpsys package | grep -Eo "^[[:space:]]+[0-9a-f]+[[:space:]]+org.dolphinemu.mmjr/[^[:space:]]+" | grep -oE "[^[:space:]]+$"'

#Citra setup.
adb shell am start -n org.citra.emu/.ui.MainActivity
confirmDialog -TitleText "Citra" -MessageText "Go to your device, and click on allow access. Press Continue when you've done it."
adb shell am force-stop org.citra.emu

#Dolphin setup
adb shell am start -n org.dolphinemu.mmjr/org.dolphinemu.dolphinemu.ui.main.MainActivity
confirmDialog -TitleText "Dolphin" -MessageText "Go to your device, and click on allow access. Press Continue when you've done it."
adb shell am force-stop org.dolphinemu.mmjr

#Yuzu setup
adb shell am start -n org.yuzu.yuzu_emu/.ui.main.MainActivity
confirmDialog -TitleText "Yuzu" -MessageText "Go to your device, and click on Get Started and finish setup on your device. Your Keys should be in $androidStorage/Emulation/bios/yuzu/keys. Press Continue when you've done it."
adb shell am force-stop org.yuzu.yuzu_emu

#PPSSPP setup
adb shell am start -n org.ppsspp.ppsspp/.PpssppActivity
confirmDialog -TitleText "PPSSPP" -MessageText "Go to your device, and click on allow access, create the PSP folder in $androidStorage/Emulation/saves/. Press Continue when you've done it."
adb shell am force-stop org.ppsspp.ppsspp

#AetherSX2 setup
adb shell am start -n xyz.aethersx2.android/.MainActivity
confirmDialog -TitleText "AetherSX2" -MessageText "Go to your device, and click on allow access and setup your bios that should be in $androidStorage/Emulation/bios. Press Continue when you've done it."
adb shell am force-stop xyz.aethersx2.android

#Scummvm setup
adb shell am start -n org.scummvm.scummvm/.SplashActivity
confirmDialog -TitleText "Scummvm" -MessageText "Go to your device, and click on allow access. Press Continue when you've done it."
adb shell am force-stop org.scummvm.scummvm

#RetroArch setup
adb shell am start -n com.retroarch.aarch64/com.retroarch.browser.mainmenu.MainMenuActivity
confirmDialog -TitleText "RetroArch" -MessageText "Go to your device, click on allow access, go to Load Core, Install or Restore a Core and install all the cores you need. Then go to Settings, Directory. Set your System/Bios to $androidStorage/Emulation/bios. Set Save Files to $androidStorage/Emulation/saves/RetroArch/saves and Save States to $androidStorage/Emulation/saves/RetroArch/states"
adb shell am force-stop com.retroarch.aarch64



setMSG "100 #ANDROID"
Stop-Transcript