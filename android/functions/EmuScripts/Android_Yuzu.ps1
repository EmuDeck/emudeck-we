#!/bin/bash

function Android_Yuzu_install(){
	setMSG "Installing Yuzu"
	$temp_url="$(Android_getLatestReleaseURLGH "yuzu-emu/yuzu-android" ".apk")"
	$temp_emu="yuzu"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Yuzu_init(){
	setMSG "Setting up Yuzu"

	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/Android/data/org.yuzu.yuzu_emu/" "$Android_temp_android_data/org.yuzu.yuzu_emu/"

	$originFile="$Android_temp_android_data/org.yuzu.yuzu_emu/files/config/config.ini"
	$origin="XXXX"
	#SD or internal?
	if ( $androidStoragePath -like "*-*" ){
		$target = $androidStoragePath -replace "/storage/", ""
	}else{
		$target="primary"
	}

	sedFile $originFile $origin $target

	Android_ADB_push "$Android_temp_android_data/org.yuzu.yuzu_emu/" /storage/emulated/0/Android/data/org.yuzu.yuzu_emu/
}