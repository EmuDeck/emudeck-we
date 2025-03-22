function setMSGTemp($message){
	$logFilePath = "$env:APPDATA\emudeck\logs\msg.log"

	$line = Get-Content -Path $logFilePath -TotalCount 1 -ErrorAction SilentlyContinue

	$progressBarValue = ($line -split '#')[0]

	if ($progressBarValue -match '^\d+$') {
		$progressBarUpdate = [int]$progressBarValue + 5
	} else {
		$progressBarUpdate = 5
	}

	if ($progressBarUpdate -ge 95) {
		$progressBarUpdate = 90
	}

	"$progressBarUpdate# $Message" | Out-File -Encoding ASCII $logFilePath

	Start-Sleep -Seconds 0.5
}
setMSGTemp 'Creating configuration files. please wait'

Write-Output "" > "$env:APPDATA\emudeck\logs\EmuDeckAndroidSetup.log"

Start-Sleep -Seconds 1.5

Start-Transcript "$env:APPDATA\emudeck\logs\EmuDeckAndroidSetup.log"

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
rm -fo -r $env:APPDATA/emudeck/android/temp
Write-Output ""
$copySavedGames="false"
$result = yesNoDialog -TitleText "Saved Games" -MessageText "Do you want to copy your current saved games to your Android Device?" -OKButtonText "Yes" -CancelButtonText "No"

if ($result -eq "OKButton") {
	$copySavedGames="true"
} else {
	$copySavedGames="false"
}





#Roms folders
#if ( $android_writable -eq "true" ){
#	setMSG "Creating rom folders in $androidStoragePath..."
#	Android_ADB_push "$env:APPDATA\EmuDeck\backend\android\roms" "$androidStoragePath/Emulation/roms"
#	setMSG "Copying BIOS"
#	Android_ADB_push "$biosPath" "$androidStoragePath/Emulation/bios"
#
#	if ($copySavedGames -eq "true") {
#		setMSG "Copying Saves & States"
#		#RA
#		Android_ADB_push "$savesPath/RetroArch" "$androidStoragePath/Emulation/saves/RetroArch/"
#		#PPSSPP
#		Android_ADB_push "$emusPath\PPSSPP\memstick\PSP\SAVEDATA"  "$androidStoragePath/Emulation/saves/PSP/SAVEDATA"
#		Android_ADB_push "$emusPath\PPSSPP\memstick\PSP\PPSSPP_STATE" "$androidStoragePath/Emulation/saves/PSP/PPSSPP_STATE"
#		#Yuzu
#		#Android_ADB_push "$savesPath/yuzu/saves/" "/storage/emulated/0/Android/data/org.yuzu.yuzu_emu/files/nand/user/saves/"
#		#Citra
#		Android_ADB_push "$savesPath\citra\saves" "/storage/emulated/0/citra-emu/sdmc/"
#
#	}
#
#}else{

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
		#copyFromTo "$savesPath/yuzu/saves/" "$Android_temp_internal/Android/data/org.yuzu.yuzu_emu/files/nand/user/saves/"
		#Citra
		copyFromTo "$savesPath\azahar\saves" "$Android_temp_internal/azahar-emu/sdmc/"
	}
#}


if($androidInstallPegasus -eq "true" ){
	Android_Pegasus_install
	Android_Pegasus_init
}
if($androidInstallESDE -eq "true" ){
	Android_ESDE_init
}
if($androidInstallNetherSX2 -eq "true" ){
	Android_NetherSX2_install
	Android_NetherSX2_init
}
if($androidInstallAzahar -eq "true" ){
	Android_Azahar_install
	Android_Azahar_init
}
if($androidInstallDolphin -eq  "true" ){
	Android_Dolphin_install
	Android_Dolphin_init
}
if($androidInstallRA -eq "true" ){
	Android_RetroArch_install
	Android_RetroArch_init
	if($androidRABezels -eq "true"){
		Android_RetroArch_bezelOnAll
	}else{
		Android_RetroArch_bezelOffAll
	}

}
if($androidInstallPPSSPP -eq "true" ){
	Android_PPSSPP_install
	Android_PPSSPP_init
}
if($androidInstallScummVM -eq "true" ){
	Android_ScummVM_install
	Android_ScummVM_init
}


#if ( $android_writable -eq "false" ){
	  setMSG "Moving data ussing MTP, expect some Windows dialogs"
	  $phone = Get-Phone
	  $InternalObject = $phone.GetFolder.items()| Select-Object -First 1
	  $InternalName = $InternalObject.Name
	  Move-To-MTP-Internal -parent "CopyToInternal" -path "$InternalName"
	  if ( $androidStoragePath -like "*-*" ){

		  $SDObject = $phone.GetFolder.items() | Select-Object -Skip 1 -First 1
		  $SDCARDNAME = $SDObject.Name
		  Move-To-MTP-SD -parent "CopyToSDCARD" -path "$SDCARDNAME"
	  }
	  confirmDialog -TitleText "Wait" -MessageText "Please wait for all transfers for complete before hitting Continue. Keep your device's screen turned on at all times" -Position "Manual"
#}


#adb shell 'dumpsys package | grep -Eo "^[[:space:]]+[0-9a-f]+[[:space:]]+org.dolphinemu.mmjr/[^[:space:]]+" | grep -oE "[^[:space:]]+$"'


$success="true"
#Check everything is installed
# if(!Android_Pegasus_IsInstalled){
# 	confirmDialog -TitleText "Pegasus" -MessageText "Pegasus Installation failed, please try again"
# 	$success="false"
# }
# if(!Android_Dolphin_IsInstalled){
# 	confirmDialog -TitleText "Dolphin" -MessageText "Dolphin Installation failed, please try again"
# 	$success="false"
# }
# if(!Android_RetroArch_IsInstalled){
# 	confirmDialog -TitleText "RetroArch" -MessageText "RetroArch Installation failed, please try again"
# 	$success="false"
# }
# if(!Android_PPSSPP_IsInstalled){
# 	confirmDialog -TitleText "PPSSPP" -MessageText "PPSSPP Installation failed, please try again"
# 	$success="false"
# }
# if(!Android_ScummVM_IsInstalled){
# 	confirmDialog -TitleText "ScummVM" -MessageText "ScummVM Installation failed, please try again"
# 	$success="false"
# }
# # if(!Android_Yuzu_IsInstalled){
# # 	confirmDialog -TitleText "Yuzu" -MessageText "Yuzu Installation failed, please try again"
# # 	$success="false"
# # }
# if(!Android_Citra_init){
# 	confirmDialog -TitleText "Citra" -MessageText "Citra Installation failed, please try again"
# 	$success="false"
# }

#Bring your own APK
$downloadPath = (Join-Path $env:HOMEDRIVE (Join-Path $env:HOMEPATH "Downloads"))
$apkFiles = Get-ChildItem -Path $downloadPath -Filter *.apk -Recurse

foreach ($file in $apkFiles) {
	$filePath = $file.FullName
	setMSG "Installing $filePath..."
	Android_ADB_installAPK $filePath
}

if($success -eq "false"){
	setMSG "500 #ANDROID"
}else{

	if($androidInstallAzahar -eq "true" ){
		Android_Azahar_setup
	}
	if($androidInstallPegasus -eq "true" ){
		Android_Pegasus_setup
	}
	if($androidInstallDolphin -eq "true" ){
		Android_Dolphin_setup
	}
	if($androidInstallScummVM -eq "true" ){
		Android_ScummVM_setup
	}



	setMSG "100 #FINISH"
	#adb shell am start -n org.pegasus_frontend.android/.MainActivity

}


Stop-Transcript