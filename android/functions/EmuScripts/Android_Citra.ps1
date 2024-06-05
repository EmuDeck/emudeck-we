#!/bin/bash

function Android_Citra_install(){
	setMSG "Installing Citra"
	$temp_url="$(Android_getLatestReleaseURLGH "weihuoya/citra" ".apk")"
	$temp_emu="citra"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Citra_init(){
	setMSG "Setting up Citra"

	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/citra-emu/" "$Android_temp_internal/citra-emu/"

	Android_ADB_push "$Android_temp_internal/citra-emu/" /storage/emulated/0/citra-emu/
}

function Android_Citra_setup(){
	adb shell pm grant org.citra.emu android.permission.WRITE_EXTERNAL_STORAGE
	adb shell am start -n org.citra.emu/.ui.MainActivity
	Start-Sleep -Seconds 1
	adb shell am force-stop org.citra.emu
}

function Android_Citra_IsInstalled(){
	$package="org.citra.emu"
	$test= adb shell pm list packages $package
	if ($test){
		Write-Output  "true"
	}else{
		Write-Output  "false"
	}
}