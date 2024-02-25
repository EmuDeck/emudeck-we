#!/bin/bash

function Android_ScummVM_install(){
	setMSG "Installing ScummVM"
	$temp_url="https://downloads.scummvm.org/frs/scummvm/2.8.0/scummvm-2.8.0-android-arm64-v8a.apk"
	$temp_emu="scummvm"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_ScummVM_init(){
	echo "NYI"
}

function Android_ScummVM_IsInstalled(){
	$package="org.scummvm.scummvm"
	$test= adb shell pm list packages $package
	if ($test){
		Write-Output  "true"
	}else{
		Write-Output  "false"
	}
}