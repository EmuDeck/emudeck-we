#!/bin/bash

function Android_Vita3K_install(){
	setMSG "Installing Vita3K"
	$temp_url="$(Android_getLatestReleaseURLGH "Vita3K/Vita3K-Android" ".apk")"
	$temp_emu="vita3k"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Vita3K_init(){
	echo "NYI"
}

function Android_Citra_setup(){
	echo "NYI"
}

function Android_Vita3K_IsInstalled(){
	$package="com.retroarch.aarch64"
	$test= adb shell pm list packages $package
	if ($test){
		Write-Output  "true"
	}else{
		Write-Output  "false"
	}
}