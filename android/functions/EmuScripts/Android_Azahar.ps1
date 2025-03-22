#!/bin/bash

function Android_Azahar_install(){
	setMSG "Installing Azahar"
	$temp_url="$(Android_getLatestReleaseURLGH "azahar-emu/azahar" ".apk")"
	$temp_emu="azahar"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Azahar_init(){
	setMSG "Setting up Azahar"

	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/azahar-emu/" "$Android_temp_internal/azahar-emu/"

	Android_ADB_push "$Android_temp_internal/azahar-emu/" /storage/emulated/0/citra-emu/
}

function Android_Azahar_setup(){
	adb shell pm grant io.github.lime3ds.android android.permission.WRITE_EXTERNAL_STORAGE
	adb shell am start -n io.github.lime3ds.android/.ui.MainActivity
	Start-Sleep -Seconds 1
	adb shell am force-stop org.citra.emu
}

function Android_Azahar_IsInstalled(){
	$package="io.github.lime3ds.android"
	$test= adb shell pm list packages $package
	if ($test){
		Write-Output  "true"
	}else{
		Write-Output  "false"
	}
}